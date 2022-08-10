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
  UI = exports['bs_base']:FetchComponent('UI')
  Keybinds = exports['bs_base']:FetchComponent('Keybinds')
  -- Weapons = exports['bs_base']:FetchComponent('Weapons')
end

AddEventHandler('Core:Shared:Ready', function()
  exports['bs_base']:RequestDependencies('Inventory', {
    'Callbacks',
    'Inventory',
    'Utils',
    'Notification',
    'UI',
    'Keybinds',
    -- 'Weapons',
  }, function(error)
    if #error > 0 then return; end
    RetrieveComponents()
  end)
end)

Inventory = {
  _required = { 'SendUIMessage', 'SetFocus', 'Open', 'Close', },

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

  Open = {
    Player = function(self)
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

      Inventory:SetFocus(true)
      Inventory:SendUIMessage('openInventory')
    end,
  },

  Close = {

  }
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['bs_base']:RegisterComponent('Inventory', Inventory)
end)

RegisterCommand('+openinventory', function()
  Inventory.Open:Player()
end, false)
