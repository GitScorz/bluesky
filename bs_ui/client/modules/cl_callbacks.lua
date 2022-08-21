RegisterNUICallback('hud:setFocus', function(state, cb)
  cb('ok')
  UI:SetFocus(state)
end)

RegisterNUICallback('ui:sendAlert', function(data, cb)
  cb('ok')
  local msg = data.message

  if (data.type == "error") then
    Notification:SendError(msg)
  else
    Notification:SendAlert(msg)
  end
end)

--## PHONE ##--

RegisterNUICallback('phone:close', function(data, cb)
  cb('ok')
  Phone:Close()
end)

RegisterNUICallback('phone:updatePhoneSettings', function(data, cb)
  cb('ok')
  Phone.Data:UpdateSettings(data)
end)

RegisterNUICallback('phone:addContact', function(data, cb)
  cb('ok')
  Phone.Contacts:Create(data.state)
end)

RegisterNUICallback('phone:editContact', function(data, cb)
  cb('ok')
  Phone.Contacts:Update(data.state)
end)

RegisterNUICallback('phone:deleteContact', function(data, cb)
  cb('ok')
  Phone.Contacts:Delete(data.id)
end)

RegisterNUICallback('phone:isNotificationActive', function(data, cb)
  cb(Phone.Notification:IsActive())
end)

RegisterNUICallback('phone:shutdownNotification', function(data, cb)
  if Phone.Notification:IsActive() then
    cb(Phone.Notification:Close())
  end
end)

RegisterNUICallback('phone:openCamera', function(data, cb)
  cb('ok')
  Phone:Close()
  Phone:SelfieMode()
end)

--## RADIO ##--
RegisterNUICallback('hud:radio:setPower', function(power, cb)
  cb('ok')
  Voip.Voice:SetVoiceProperty('radioEnabled', power)
end)

RegisterNUICallback('hud:radio:setFrequency', function(frequency, cb)
  cb('ok')
  Voip.Radio:SetRadioChannel(frequency)
end)

RegisterNUICallback('hud:radio:close', function(frequency, cb)
  cb('ok')
  Radio:Close()
end)

--## PEEK ##--
RegisterNUICallback('peek:close', function(data, cb)
  cb('ok')
  Peek:Close()
end)

RegisterNUICallback('peek:triggerEvent', function(event, cb)
  cb('ok')
  Peek:SelectOption(event)
end)
