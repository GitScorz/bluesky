RegisterNUICallback('hud:phone:close', function(data, cb)
  Phone:Close()
  cb({})
end)