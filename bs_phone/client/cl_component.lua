local phoneOpen = false

Phone = {
  Open = function(self)
    UI:SetFocus(true)
    UI:SendUIMessage('hud:phone:toggle', true)
    phoneOpen = true
  end,
  Close = function(self)
    UI:SetFocus(false)
    UI:SendUIMessage('hud:phone:toggle', false)
    phoneOpen = false
  end,
  IsPhoneOpen = function(self)
    return phoneOpen
  end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['bs_base']:RegisterComponent('Phone', Phone)
end)