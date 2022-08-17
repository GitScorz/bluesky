_isLoggedIn = false
local _open = false
local hotBarOpen = false
local trunkOpen = false
local SECOND_INVENTORY = {}

AddEventHandler('Inventory:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['bs_base']:FetchComponent('Callbacks')
  Inventory = exports['bs_base']:FetchComponent('Inventory')
  Utils = exports['bs_base']:FetchComponent('Utils')
  Notification = exports['bs_base']:FetchComponent('Notification')
  Keybinds = exports['bs_base']:FetchComponent('Keybinds')
  -- Weapons = exports['bs_base']:FetchComponent('Weapons')
  RegisterKeybinds()
end

AddEventHandler('Core:Shared:Ready', function()
  exports['bs_base']:RequestDependencies('Inventory', {
    'Callbacks',
    'Inventory',
    'Utils',
    'Notification',
    'Keybinds',
    -- 'Weapons',
  }, function(error)
    if #error > 0 then return end
    RetrieveComponents()
  end)
end)

local function loadAnimDict(dict)
  while (not HasAnimDictLoaded(dict)) do
    RequestAnimDict(dict)
    Wait(5)
  end
end

INVENTORY = {
  _required = { 'SendUIMessage', 'SetFocus', 'Open', 'Close', 'Animation', 'Player', 'Secondary' },

  --- @param action string The action you wish to target
  --- @param data any The data you wish to send along with this action
  SendUIMessage = function(self, action, data)
    SendNUIMessage({
      action = action,
      data = data
    })
  end,

  --- @param shouldFocus boolean Whether or not to focus the NUI frame
  SetFocus = function(self, shouldFocus)
    SetNuiFocus(shouldFocus, shouldFocus)
  end,

  Open = function(self)
    if not _open then
      _open = true

      CreateThread(function()
        TransitionToBlurred(50)
        while _open do
          Wait(50)
        end
        TransitionFromBlurred(1000)
      end)
    end

    Inventory.Player:Refresh()

    Inventory:SetFocus(true)
    Inventory:SendUIMessage('inventory:open', true)
    Inventory:Animation()
  end,

  Close = function(self, force)
    _open = false
    Inventory:SendUIMessage('inventory:open', false)
    Inventory:SetFocus(false)

    TriggerServerEvent('Inventory:Server:CloseSecondary')
    SECOND_INVENTORY = {}

    if trunkOpen and trunkOpen > 0 then
      SetVehicleDoorShut(trunkOpen, 5, false)
      trunkOpen = false
    end

    if not force then
      Inventory:Animation()
    end
  end,

  Animation = function(self)
    local ped = PlayerPedId()

    loadAnimDict('pickup_object')
    TaskPlayAnim(ped, 'pickup_object', 'putdown_low', 5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
    Wait(1000)
    ClearPedSecondaryTask(ped)
  end,

  ShowNotification = function(self, id, label, text, quantity)
    local data = {
      id = id,
      label = label,
      text = text,
      quantity = quantity
    }

    Inventory:SendUIMessage('inventory:showNotification', data)
  end,

  Player = {
    HasItem = function(self, item)
      Callbacks:ServerCallback('Inventory:Server:HasItem', {
        item = item
      }, function(hasItem)
        return hasItem
      end)
    end,

    Update = function(self, data)
      Inventory:SendUIMessage('inventory:updatePlayerInventory', data)
    end,

    Refresh = function(self)
      Callbacks:ServerCallback('Inventory:FetchPlayerInventory', {}, function(inventory)
        Inventory.Player:Update(inventory)
      end)
    end,
  },

  Secondary = {
    Update = function(self, data)
      Inventory:SendUIMessage('inventory:updateSecondaryInventory', data)
    end,

    Refresh = function(self)
      Callbacks:ServerCallback('Inventory:FetchSecondInventory', {}, function(inventory)
        Inventory.Secondary:Update(inventory)
      end)
    end,
  },
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['bs_base']:RegisterComponent('Inventory', INVENTORY)
end)

local function getVehicleNearby()
  local player = PlayerPedId()
  local startPos = GetOffsetFromEntityInWorldCoords(player, 0, 0.5, 0)
  local endPos = GetOffsetFromEntityInWorldCoords(player, 0, 5.0, 0)

  local rayHandle = StartShapeTestRay(startPos['x'], startPos['y'], startPos['z'], endPos['x'], endPos['y'], endPos['z']
    , 10, player, 0)

  local a, b, c, d, veh = GetShapeTestResult(rayHandle)

  if veh ~= 2 then
    local plyCoords = GetEntityCoords(player)
    local offCoords = GetOffsetFromEntityInWorldCoords(veh, 0.0, -2.5, 1.0)
    local dist = #(vector3(offCoords.x, offCoords.y, offCoords.z) - plyCoords)

    if dist < 2.5 then
      return veh
    end
  else
    return nil
  end
end

local function checkTrunkDistance(vehicle)
  CreateThread(function()
    while trunkOpen do
      local sleep = 500
      local pos = GetEntityCoords(PlayerPedId())

      local dist = #(vector3(pos.x, pos.y, pos.z) - GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -2.5, 1.0))
      if dist > 1 and trunkOpen then
        sleep = 1
        trunkOpen = false
      end

      Wait(sleep)
    end
  end)
end

RegisterCommand('+openinventory', function()
  Callbacks:ServerCallback('Inventory:CheckIfNearDropZone', {}, function(dropzone)
    local playerPed = PlayerPedId()
    local plate
    local requestSecondary = false
    local isPedInVehicle = IsPedInAnyVehicle(playerPed)

    if isPedInVehicle then
      local vehicle = GetVehiclePedIsIn(playerPed)
      if vehicle ~= nil and vehicle > 0 then
        plate = GetVehicleNumberPlateText(vehicle)

        -- do fake plate check

        -- do player owned check

        SECOND_INVENTORY = {
          invType = 5,
          owner = plate
        }

        requestSecondary = true
      end
    end

    -- do trunk check here aswell maybe?
    local vehicle = getVehicleNearby()
    if vehicle and IsEntityAVehicle(vehicle) and not requestSecondary then
      local plate = GetVehicleNumberPlateText(vehicle)

      -- Check here for false plates

      if GetVehicleDoorLockStatus(vehicle) == 1 then
        trunkOpen = vehicle
        -- check here for player owned vehs

        SECOND_INVENTORY = {
          invType = 4,
          owner = plate
        }

        requestSecondary = true

        SetVehicleDoorOpen(vehicle, 5, true, false)
        checkTrunkDistance(vehicle)
      else
        Notification:SendError('Vehicle locked.')
      end
    end

    -- Trash Container Checks here?
    local container, entity = ScanContainer()

    if container and not isPedInVehicle and not requestSecondary then
      if entity > 0 then
        containerid = DecorGetInt(entity, 'TrashContainer-Inventory')
        SECOND_INVENTORY = {
          invType = 16,
          owner = containerid
        }

        requestSecondary = true
      end
    end

    if dropzone ~= nil and not isPedInVehicle and not requestSecondary then
      SECOND_INVENTORY = {
        invType = 10,
        owner = dropzone
      }

      requestSecondary = true
    elseif dropzone == nil and not isPedInVehicle and not requestSecondary then
      TriggerServerEvent('Inventory:Server:CreateNewDropzone')
    end

    if requestSecondary then
      TriggerServerEvent('Inventory:Server:RequestSecondaryInventory', SECOND_INVENTORY)
    end

    Inventory:Open()
  end)
end, false)

function RegisterKeybinds()
  Keybinds:Register("Inventory", "Open inventory.", "+openinventory", "-openinventory", "keyboard", 'K')
end

RegisterNUICallback('inventory:close', function(data, cb)
  cb('ok')
  Inventory:Close()
end)

RegisterNetEvent('Inventory:CloseUI')
AddEventHandler('Inventory:CloseUI', function()
  Inventory:Close(true)
end)

RegisterNetEvent('Inventory:SendNotification')
AddEventHandler('Inventory:SendNotification', function(id, label, text, quantity)
  Inventory:ShowNotification(id, label, text, quantity)
end)

RegisterNetEvent('Inventory:Client:RefreshPlayer')
AddEventHandler('Inventory:Client:RefreshPlayer', function()
  Inventory.Player:Refresh()
end)

RegisterNetEvent('Inventory:Client:RefreshSecondary')
AddEventHandler('Inventory:Client:RefreshSecondary', function()
  Inventory.Secondary:Refresh()
end)

RegisterNetEvent('Characters:Client:Spawn')
AddEventHandler('Characters:Client:Spawn', function()
  Callbacks:ServerCallback('Inventory:Server:ReceiveAllDrops', {}, function(drops)
    DROP_ZONES = drops
    _isLoggedIn = true
    startDropsTick()
  end)
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
  _isLoggedIn = false
  DROP_ZONES = {}
end)

RegisterNetEvent('Inventory:Client:LoadSecondary')
AddEventHandler('Inventory:Client:LoadSecondary', function(data)
  Inventory.Secondary:Update(data)
end)

RegisterNetEvent('Inventory:Client:AddItem')
AddEventHandler('Inventory:Client:AddItem', function(itemId)
  Inventory:SendUIMessage('inventory:addItem', itemId)
end)

RegisterNUICallback('inventory:sendClientNotify', function(data, cb)
  cb('ok')
  if data then
    if data.alert == "info" then
      Notification:SendAlert(data.message, data.time)
    elseif data.alert == "error" then
      Notification:SendError(data.message, data.time)
    end
  end
end)

RegisterNUICallback('inventory:useItem', function(data, cb)
  cb('ok')

  Callbacks:ServerCallback('Inventory:UseItem', {
    slot = data.slot,
    owner = data.owner,
    invType = data.invType
  }, function(success) end)
end)

RegisterNUICallback('inventory:moveItem', function(data, cb)
  cb('ok')

  Callbacks:ServerCallback('Inventory:MoveItem', data, function(success)
    if success then
      Inventory.Player:Refresh()

      if data.invTypeTo ~= 1 or data.invTypeFrom ~= 1 then
        Inventory.Secondary:Refresh()
      end
    end
  end)

end)

RegisterNUICallback('inventory:nextSlotInSecondary', function(data, cb)
  cb('ok')

  Callbacks:ServerCallback('Inventory:Server:NextSlotInSecondary', data, function(success)
    if success then
      Inventory.Player:Refresh()
      Inventory.Secondary:Refresh()
    end
  end)
end)

RegisterNetEvent('Inventory:UsedItem')
AddEventHandler('Inventory:UsedItem', function(item)
  Inventory:ShowNotification(item.id, SHARED_ITEMS[item.id].label, 'Used', 1)
end)

RegisterNetEvent('Inventory:AddItem')
AddEventHandler('Inventory:AddItem', function(itemId, quantity)
  Inventory:ShowNotification(itemId, SHARED_ITEMS[itemId].label, 'Received', quantity)
end)
