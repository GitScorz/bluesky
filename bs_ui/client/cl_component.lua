UI = {
  _required = { 'SendUIMessage', 'SetFocus' },

  --- @param action string The action you wish to target
  --- @param data any The data you wish to send along with this action
  SendUIMessage = function(self, action, data)
    SendReactMessage(action, data)
  end,

  --- @param shouldFocus boolean Whether or not to focus the NUI frame
  SetFocus = function(self, shouldFocus)
    SetNuiFocus(shouldFocus, shouldFocus)
  end,

  Hud = {
    Show = function(self)
      UI:SendUIMessage('hud:status:visible', true)
      StartThreads()
    end,
    Hide = function(self)
      UI:SendUIMessage('hud:status:visible', false)
    end,
    Update = function(self, data)
      UI:SendUIMessage('hud:status:update', data)
    end,
    Reset = function(self)
      UI:SendUIMessage('hud:status:reset')
    end,
  },

  Balance = {
    ShowBank = function(self)
      UI:SendUIMessage('hud:balance:setBankVisible', true)
    end,
    ShowCash = function(self)
      UI:SendUIMessage('hud:balance:setCashVisible', true)
    end,
  }
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['bs_base']:RegisterComponent('UI', UI)
end)