local _phoneOpen = false

Phone = {
  Open = function(self)
    UI:SetFocus(true)
    UI:SendUIMessage('hud:phone:toggle', true)
    _phoneOpen = true
  end,
  Close = function(self)
    UI:SetFocus(false)
    UI:SendUIMessage('hud:phone:toggle', false)
    _phoneOpen = false
  end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['bs_base']:RegisterComponent('Phone', Phone)
end)