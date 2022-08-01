RegisterServerEvent('Notification:SendAlert')
AddEventHandler('Notification:SendAlert', function(source, message, duration)
  TriggerClientEvent('Notification:SendAlert', source, message, duration)
end)

RegisterServerEvent('Notification:SendError')
AddEventHandler('Notification:SendError', function(source, message, duration)
  TriggerClientEvent('Notification:SendError', source, message, duration)
end)

RegisterServerEvent('Notification:Clear')
AddEventHandler('Notification:Clear', function(source)
  TriggerClientEvent('Notification:Clear', source)
end)