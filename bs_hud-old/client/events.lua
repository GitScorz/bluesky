RegisterNetEvent('Events:Client:EnteredVehicle')
AddEventHandler('Events:Client:EnteredVehicle', function(currentVehicle, currentSeat, displayname)
    Hud.Vehicle:Show()
end)

RegisterNetEvent('Events:Client:ExitedVehicle')
AddEventHandler('Events:Client:ExitedVehicle', function(currentVehicle, currentSeat, displayname)
    Hud.Vehicle:Hide()
end)

AddEventHandler('Characters:Client:Spawn', function()
    Hud:Show()
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    Hud:Hide()
    Action:Hide()
    Notification:Clear()
end)

AddEventHandler('Vehicle:Client:Seatbelt', function(state)
    if not IsPedInAnyVehicle(PlayerPedId()) then Citizen.Wait(200) end

    SendNUIMessage({
        type = 'UPDATE_SEATBELT',
        data = { seatbelt = state }
    })
end)

AddEventHandler('Vehicle:Client:Cruise', function(state)
    if not IsPedInAnyVehicle(PlayerPedId()) then Citizen.Wait(200) end

    SendNUIMessage({
        type = 'UPDATE_CRUISE',
        data = { cruise = state }
    })
end)

AddEventHandler('Vehicle:Client:Ignition', function(state)
    SendNUIMessage({
        type = 'UPDATE_IGNITION',
        data = { ignition = state }
    })
end)

AddEventHandler('Vehicle:Client:Fuel', function(state)
    SendNUIMessage({
        type = 'UPDATE_FUEL',
        data = { fuel = state }
    })
end)

AddEventHandler('Status:Client:Update', function(status, value)
    SendNUIMessage({
        type = 'UPDATE_STATUS_VALUE',
        data = { name = status, value = value}
    })
end)