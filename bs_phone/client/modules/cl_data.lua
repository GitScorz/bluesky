local cachedData = {}

Phone.Data = {
  Set = function(self, data)
    for k, v in pairs(data) do
      cachedData[k] = v
    end
  end,

  Get = function(self)
    UI:SendUIMessage('phone:updatePhoneData', cachedData)
  end,

  --- @param data table
  Update = function(self, data)
    cachedData[data.type] = data.value
    UI:SendUIMessage('phone:updatePhoneData', cachedData)
  end,

  UpdateSettings = function(self, data)
    cachedData[data.type] = data.value
    Callbacks:ServerCallback('Phone:Settings:Update', data)
    UI:SendUIMessage('phone:updatePhoneData', cachedData)
  end,
}

RegisterNetEvent('Phone:Client:SetData')
AddEventHandler('Phone:Client:SetData', function(data)
  Phone.Data:Set(data)
end)

RegisterNetEvent('Phone:Client:Settings')
AddEventHandler('Phone:Client:Settings', function(settings)
  cachedData.wallpaper = settings.wallpaper
  cachedData.brand = settings.brand
  cachedData.notifications = settings.notifications
end)
