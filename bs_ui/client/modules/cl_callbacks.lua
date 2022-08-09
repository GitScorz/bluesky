RegisterNUICallback('hud:setFocus', function(state, cb)
  UI:SetFocus(state)
  cb('ok')
end)

RegisterNUICallback('hud:sendAlert', function(data, cb)
  local msg = data.message

  if (data.type == "error") then
    Notification:SendError(msg)
  else
    Notification:SendAlert(msg)
  end
  cb('ok')
end)

--## PHONE ##--

RegisterNUICallback('hud:phone:close', function(data, cb)
  Phone:Close()
  cb('ok')
end)

RegisterNUICallback('hud:phone:addContact', function(data, cb)
  Phone.Contacts:Create(data.state)
  cb('ok')
end)

RegisterNUICallback('hud:phone:getContacts', function(data, cb)
  cb(Phone.Contacts:Get())
end)

RegisterNUICallback('hud:phone:editContact', function(data, cb)
  Phone.Contacts:Update(data.state)
  cb('ok')
end)

RegisterNUICallback('hud:phone:deleteContact', function(data, cb)
  Phone.Contacts:Delete(data.id)
  cb('ok')
end)

RegisterNUICallback('hud:phone:isNotificationActive', function(data, cb)
  cb(Phone.Notification:IsActive())
end)

RegisterNUICallback('hud:phone:shutdownNotification', function(data, cb)
  if Phone.Notification:IsActive() then
    cb(Phone.Notification:Close())
  end
end)

--## RADIO ##--
RegisterNUICallback('hud:radio:setPower', function(power, cb)
  Voip.Voice:SetVoiceProperty('radioEnabled', power)
  cb('ok')
end)

RegisterNUICallback('hud:radio:setFrequency', function(frequency, cb)
  Voip.Radio:SetRadioChannel(frequency)
  cb('ok')
end)

RegisterNUICallback('hud:radio:close', function(frequency, cb)
  Radio:Close()
  cb('ok')
end)