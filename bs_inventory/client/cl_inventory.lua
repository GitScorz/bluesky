local _open = false
local _disabled = false
local hotBarOpen = false
local trunkOpen = false

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
    if #error > 0 then return; end
    RetrieveComponents()
  end)
end)

INVENTORY = {
  _required = { 'SendUIMessage', 'SetFocus', 'Open', 'Close' },

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

    -- Callbacks:ServerCallback('Inventory:GetPlayerInventory', {}, function(inventory)
    --   Inventory.Set.Player:Inventory(inventory)
    --   Inventory.Set.Player.Data.Open = true
    -- end)

    INVENTORY:SetFocus(true)
    INVENTORY:SendUIMessage('inventory:open', true)
    INVENTORY:Animation()
  end,

  Close = function(self)
    _open = false
    INVENTORY:SetFocus(false)
    INVENTORY:Animation()
  end,

  LoadAnimDict = function(self, dict)
    while (not HasAnimDictLoaded(dict)) do
      RequestAnimDict(dict)
      Wait(5)
    end
  end,

  Animation = function(self)
    local ped = PlayerPedId()

    INVENTORY:LoadAnimDict('pickup_object')
    TaskPlayAnim(ped, 'pickup_object', 'putdown_low', 5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
    Wait(1000)
    ClearPedSecondaryTask(ped)
  end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['bs_base']:RegisterComponent('Inventory', INVENTORY)
end)

RegisterCommand('+openinventory', function()
  INVENTORY:Open()
end, false)

function RegisterKeybinds()
  Keybinds:Register("Inventory", "Open inventory.", "+openinventory", "-openinventory", "keyboard", 'K')
end
