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