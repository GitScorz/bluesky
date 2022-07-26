UI = {
  _required = { 'SendUIMessage', 'SetFocus' },

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
    Logger:Info("UI", ("Set focus status: %s"):format(shouldShow))
  end,

  Hud = {
    Show = function(self)
      UI:SendUIMessage('hud:status:visible', true)
    end,
    Hide = function(self)
      UI:SendUIMessage('hud:status:visible', false)
    end,
    --- @param data table The data you wish to send along with this action
    Update = function(self, data)
      if data.id == "thirst" or data.id == "hunger" then
        print(json.encode(data))
      end
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

    --- @param cash number
    UpdateCash = function(self, cash)
      UI:SendUIMessage('hud:balance:updateCash', cash)
    end,

    --- @param cash number
    UpdateBank = function(self, cash)
      UI:SendUIMessage('hud:balance:updateBank', cash)
    end,
  },
  
  Voip = {
    --- @param enabled boolean Whether or not to enable the voip listener
    ToggleTalking = function(self, enabled)
      UI:SendUIMessage('hud:voip:toggleTalking', enabled)
    end,

    --- @param enabled boolean Whether or not to enable the voip listener
    ToggleRadio = function(self, enabled)
      UI:SendUIMessage('hud:voip:toggleRadio', enabled)
    end,
  }
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['bs_base']:RegisterComponent('UI', UI)
end)

CreateThread(function() while true do collectgarbage() Wait(30000) end end) -- Garbage collection thread