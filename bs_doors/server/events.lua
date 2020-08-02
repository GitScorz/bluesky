RegisterServerEvent('Doors:server:updateLockingState')
AddEventHandler('Doors:server:updateLockingState', function(door, state)
    TriggerClientEvent('Doors:client:updateLockingState', -1, door, state)
end)

RegisterServerEvent('Doors:server:drawShit')
AddEventHandler('Doors:server:drawShit', function(door, locking)
    TriggerClientEvent('Doors:client:drawShit', -1, door, locking)
end)