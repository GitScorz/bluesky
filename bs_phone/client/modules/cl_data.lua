local cachedData = nil

Phone.Data = {
  Set = function(self, data)
    cachedData = data
  end,

  Get = function(self)
    UI:SendUIMessage('phone:updatePhoneData', cachedData)
  end,

  --- @param data table
  Update = function(self, data)
    cachedData[data.type] = data.value
    Callbacks:ServerCallback('Phone:Settings:Update', data)
  end
}

RegisterNetEvent('Phone:Client:SetData')
AddEventHandler('Phone:Client:SetData', function(data)
  Phone.Data:Set(data)
end)
