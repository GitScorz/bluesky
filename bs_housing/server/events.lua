RegisterServerEvent('Housing:Server:LogOffset')
AddEventHandler('Housing:Server:LogOffset', function(offset)
    Logger:Trace('Housing', GetCurrentResourceName(), json.encode({ x = offset.x, y = offset.y, z = offset.z }), { console = true, file = true })
end)