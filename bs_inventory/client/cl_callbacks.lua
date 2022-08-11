RegisterNUICallback('inventory:close', function(data, cb)
  Inventory:Close()
  cb('ok')
end)
