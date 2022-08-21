-- Script base from https://github.com/brentN5/bt-target

--- @class vector3
--- @field x number
--- @field y number
--- @field z number

local Models = {}
local Zones = {}
local targetActive = false
local success = false

local PlayerJob = { -- just testing
  name = "police"
}

AddEventHandler('Peek:Shared:DependencyUpdate', RetrieveComponents)
local function RetrieveComponents()
  Keybinds = exports['bs_base']:FetchComponent('Keybinds')
  UI = exports['bs_base']:FetchComponent('UI')
  RegisterKeybinds()
end

AddEventHandler('Core:Shared:Ready', function()
  exports['bs_base']:RequestDependencies('Peek', {
    'Keybinds',
    'UI',
  }, function(error)
    if #error > 0 then return; end
    RetrieveComponents()
  end)
end)


local function RotationToDirection(rotation)
  local adjustedRotation =
  {
    x = (math.pi / 180) * rotation.x,
    y = (math.pi / 180) * rotation.y,
    z = (math.pi / 180) * rotation.z
  }

  local direction =
  {
    x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
    y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
    z = math.sin(adjustedRotation.x)
  }
  return direction
end

local function RayCastGamePlayCamera(distance)
  local cameraRotation = GetGameplayCamRot()
  local cameraCoord = GetGameplayCamCoord()
  local direction = RotationToDirection(cameraRotation)
  local destination =
  {
    x = cameraCoord.x + direction.x * distance,
    y = cameraCoord.y + direction.y * distance,
    z = cameraCoord.z + direction.z * distance
  }
  local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x,
    destination.y, destination.z, -1, PlayerPedId(), 0))
  return b, c, e
end

Peek = {
  Show = function(self)
    if success then return end

    targetActive = true

    UI:SendUIMessage("peek:toggle", true)

    while targetActive do
      local plyCoords = GetEntityCoords(PlayerPedId())
      local hit, coords, entity = RayCastGamePlayCamera(20.0)

      if hit == 1 then
        if GetEntityType(entity) ~= 0 then
          for _, model in pairs(Models) do
            if _ == GetEntityModel(entity) then
              for k, v in ipairs(Models[_]["job"]) do
                if v == "all" or v == PlayerJob.name then
                  if _ == GetEntityModel(entity) then
                    if #(plyCoords - coords) <= Models[_]["distance"] then
                      success = true

                      UI:SendUIMessage("peek:enterTarget", Models[_]["options"])
                      while success and targetActive do
                        local plyCoords = GetEntityCoords(PlayerPedId())
                        local hit, coords, entity = RayCastGamePlayCamera(20.0)

                        DisablePlayerFiring(PlayerPedId(), true)

                        if (IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24)) then
                          UI:SetFocus(true, 0.5)
                        end

                        if GetEntityType(entity) == 0 or #(plyCoords - coords) > Models[_]["distance"] then
                          success = false
                        end

                        Wait(1)
                      end

                      UI:SendUIMessage("peek:leaveTarget")
                    end
                  end
                end
              end
            end
          end
        end

        for _, zone in pairs(Zones) do
          if Zones[_]:isPointInside(coords) then
            for k, v in ipairs(Zones[_]["targetoptions"]["job"]) do
              if v == "all" or v == PlayerJob.name then
                if #(plyCoords - Zones[_].center) <= zone["targetoptions"]["distance"] then
                  success = true

                  UI:SendUIMessage("peek:enterTarget", Zones[_]["targetoptions"]["options"])
                  while success and targetActive do
                    local plyCoords = GetEntityCoords(PlayerPedId())
                    local hit, coords, entity = RayCastGamePlayCamera(20.0)

                    DisablePlayerFiring(PlayerPedId(), true)

                    if (IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24)) then
                      UI:SetFocus(true)
                      SetCursorLocation(0.5, 0.5)
                    end

                    if not Zones[_]:isPointInside(coords) or #(plyCoords - Zones[_].center) > zone.targetoptions.distance then
                      success = false
                    end

                    Wait(1)
                  end

                  UI:SendUIMessage("peek:leaveTarget")
                end
              end
            end
          end
        end
      end
      Wait(250)
    end
  end,

  Hide = function(self)
    if success then return end

    targetActive = false

    UI:SendUIMessage("peek:toggle", false)
    UI:SetFocus(false)
  end,

  Close = function(self)
    UI:SetFocus(false)

    success = false

    targetActive = false
  end,

  --- @param event string
  SelectOption = function(self, event)
    UI:SetFocus(false)
    success = false
    targetActive = false

    TriggerEvent(event)
    TriggerServerEvent(event)
  end,

  --- @param name string
  --- @param center vector3
  --- @param radius number
  --- @param options table
  --- @param targetoptions table
  AddCircleZone = function(self, name, center, radius, options, targetoptions)
    Zones[name] = CircleZone:Create(center, radius, options)
    Zones[name].targetoptions = targetoptions
  end,

  --- @param name string
  --- @param center vector3
  --- @param length number
  --- @param width number
  --- @param options table
  --- @param targetoptions table
  AddBoxZone = function(self, name, center, length, width, options, targetoptions)
    Zones[name] = BoxZone:Create(center, length, width, options)
    Zones[name].targetoptions = targetoptions
  end,

  --- @param name string
  --- @param points table
  --- @param options table
  --- @param targetoptions table
  AddPolyzone = function(self, name, points, options, targetoptions)
    Zones[name] = PolyZone:Create(points, options)
    Zones[name].targetoptions = targetoptions
  end,

  --- @param models table
  --- @param params table
  AddTargetModel = function(self, models, params)
    for _, model in pairs(models) do
      Models[model] = params
    end
  end,

  --- @param name string
  RemoveZone = function(self, name)
    if not Zones[name] then return end
    if Zones[name].destroy then
      Zones[name]:destroy()
    end

    Zones[name] = nil
  end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['bs_base']:RegisterComponent('Peek', Peek)
end)

RegisterCommand("+peekTarget", function(src, cmd, raw)
  Peek:Show()
end, false)

RegisterCommand("-peekTarget", function(src, cmd, raw)
  Peek:Hide()
end, false)

function RegisterKeybinds()
  Keybinds:Register("Peek", "Third eye peek.", "+peekTarget", "-peekTarget", "keyboard", 'LMENU')
end

RegisterNetEvent('peek:pee')
AddEventHandler('peek:pee', function()
  print("pee")
end)
