PHONE = {
  Open = function(self)
    UI:SendUIMessage('phone:shouldOpen', true)
  end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['bs_base']:RegisterComponent('Phone', PHONE)
end)