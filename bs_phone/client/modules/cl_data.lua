local selfData = nil

Phone.Data = {
  Set = function(self, data)
    selfData = data
  end,

  Get = function(self)
    UI:SendUIMessage('hud:phone:updatePhoneData', selfData)
  end,
}

RegisterNetEvent('Phone:Client:SetData')
AddEventHandler('Phone:Client:SetData', function(data)
  Phone.Data:Set(data)
end)