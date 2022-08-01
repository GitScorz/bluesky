RegisterNUICallback('hud:setFocus', function(state, cb)
  UI:SetFocus(state)
  cb({})
end)

RegisterNUICallback('hud:sendAlert', function(data, cb)
  local msg = data.message

  if (data.type == "error") then
    Notification:SendError(msg)
  else
    Notification:SendAlert(msg)
  end
  cb({})
end)

RegisterNUICallback('hud:phone:close', function(data, cb)
  Phone:Close()
  cb({})
end)

RegisterNUICallback('hud:phone:getPhoneContacts', function(data, cb)
  cb(Phone:GetContacts())
end)