Callbacks = nil
Game = nil
Vehicle = nil

AddEventHandler('Commands:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Game = exports['bs_base']:FetchComponent('Game')
    Vehicle = exports['bs_base']:FetchComponent('Vehicle')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Commands', {
        'Callbacks',
        'Game',
        'Vehicle'
    }, function(error)  
        if #error > 0 then return; end
        RetrieveComponents()
    end)
end)

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Commands', CMDS)
end)

CMDS = {}

RegisterNetEvent('Commands:Client:SpawnVehicle')
AddEventHandler('Commands:Client:SpawnVehicle', function(model)
    Callbacks:ServerCallback('Commands:ValidateAdmin', {}, function(isAdmin)
        if isAdmin then
            local playerPed = PlayerPedId()
            local entityCoords = GetEntityCoords(playerPed)
            local entityHeading = GetEntityHeading(playerPed)
            Game.Vehicles:Spawn(entityCoords, model, entityHeading, function(vehicle)
                TaskEnterVehicle(playerPed, vehicle, 100, -1, 2.0, 16, 0)
                Vehicle.Keys:GetKeys(GetVehicleNumberPlateText(vehicle), false)
            end)
        end
    end)
end)

RegisterNetEvent('Commands:Client:RemoveVehicle')
AddEventHandler('Commands:Client:RemoveVehicle', function()
    Callbacks:ServerCallback('Commands:ValidateAdmin', {}, function(isAdmin)
        if isAdmin then
            local playerPed = PlayerPedId()
            local vehicle = Game.Vehicles:GetInFrontOfPlayer(5.0)
            if IsPedInAnyVehicle(playerPed) then
                vehicle = GetVehiclePedIsIn(playerPed)
            end
            Game.Vehicles:Delete(vehicle)
        end
    end)
end)

RegisterNetEvent('Commands:Client:FixVehicle')
AddEventHandler('Commands:Client:FixVehicle', function()
    Callbacks:ServerCallback('Commands:ValidateAdmin', {}, function(isAdmin)
        if isAdmin then
            local playerPed = PlayerPedId()
            local vehicle = Game.Vehicles:GetInFrontOfPlayer(5.0)
            if IsPedInAnyVehicle(playerPed) then
                vehicle = GetVehiclePedIsIn(playerPed)
            end
            
            SetVehicleEngineHealth(vehicle, 1000)
            SetVehicleEngineOn( vehicle, true, true )
            SetVehicleFixed(vehicle)
        end
    end)
end)