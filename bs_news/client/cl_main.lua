local newspaper = nil

AddEventHandler('Peek:Shared:DependencyUpdate', RetrieveComponents)
local function RetrieveComponents()
  Peek = exports['bs_base']:FetchComponent('Peek')
  UI = exports['bs_base']:FetchComponent('UI')
  Sounds = exports['bs_base']:FetchComponent('Sounds')
  RegisterPeekZones()
end

AddEventHandler('Core:Shared:Ready', function()
  exports['bs_base']:RequestDependencies('News', {
    'Peek',
    'UI',
    'Sounds',
  }, function(error)
    if #error > 0 then return end
    RetrieveComponents()
  end)
end)

News = {
  Open = function(self)
    local ped = PlayerPedId()

    newspaper = CreateObject(GetHashKey("prop_cliff_paper"), 0, 0, 0, true, true, true)
    RequestAnimDict("missfam4")
    while not HasAnimDictLoaded("missfam4") do Wait(5) end
    TaskPlayAnim(ped, "missfam4", "base", 3.0, 2.0, -1, 33, 0.0, false, false, false)
    AttachEntityToEntity(newspaper, ped, GetPedBoneIndex(ped, 18905), 0.26, 0.06, 0.16, 320.0, 310.0, 0.0, true, true,
      false, true, 1, true)

    Sounds.Do.Play:Distance(GetPlayerServerId(PlayerId()), 5.0, "newsOpen", 0.5)
    UI:SetFocus(true)
    UI:SendUIMessage("newspaper:toggle", true)
  end,

  Close = function(self)
    if not newspaper then return end
    ClearPedTasks(PlayerPedId())
    DeleteEntity(newspaper)
    newspaper = nil

    Sounds.Do.Play:Distance(GetPlayerServerId(PlayerId()), 5.0, "newsClose", 0.5)
    UI:SetFocus(false)
    UI:SendUIMessage("newspaper:toggle", false)
  end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['bs_base']:RegisterComponent('News', News)
end)

RegisterNetEvent('newspaper:open')
AddEventHandler('newspaper:open', function()
  News:Open()
end)

function RegisterPeekZones()
  local entities = {
    1211559620,
    720581693,
    -1186769817,
    -377891123
  }

  Peek:AddTargetModel(entities, {
    options = {
      {
        label = "Read Newspaper",
        icon = "newspaper",
        event = "newspaper:open",
      },
    },
    job = { "all" },
    distance = 2.5
  })
end
