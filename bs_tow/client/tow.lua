AddEventHandler('Tow:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Logger = exports['bs_base']:FetchComponent('Logger')
    Game = exports['bs_base']:FetchComponent('Game')
    Markers = exports['bs_base']:FetchComponent('Markers')
    Blips = exports['bs_base']:FetchComponent('Blips')
    Jobs = exports['bs_base']:FetchComponent('Jobs')
    Menu = exports['bs_base']:FetchComponent('Menu')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Tow', {
        'Callbacks',
        'Logger',
        'Game',
        'Markers',
        'Blips',
        'Jobs',
        'Menu'
    }, function(error)
        if #error > 0 then return; end
        RetrieveComponents()
        RegisterMarkers()
    end)
end)

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Tow', TOW)
end)

RegisterNetEvent('Characters:Client:Spawn')
AddEventHandler('Characters:Client:Spawn', function()
    RegisterBlips()
end)

TOW = {}

function RegisterMarkers()
    for k, v in ipairs(Config.Impounds) do
        Markers.MarkerGroups:Add(v.Name .. "_tow", v.Impound, Config.DrawDistance)
        Markers.Markers:Add(v.Name .. "_tow", v.Name .. '_impound', v.Impound, 1, vector3(5, 5, 3),
            { r = 255, g = 255, b = 0 }, function()
                return Jobs:Has('Tow')
            end, '[H] Impound', function()
            OpenMenu(v)
        end)
    end
end

function RegisterBlips()
    for k, v in ipairs(Config.Impounds) do
        Blips:Add(v.Name, v.Name .. ' Impound', v.Impound, 68, 75, 0.8)
    end
end

function OpenMenu(impound)
    local playerPed = PlayerPedId()

    local menu = Menu:Create(impound.Name, impound.Name .. ' Impound')
    local vehicles = Game.Vehicles:GetInArea(impound.Impound, 10)
    if #vehicles > 0 then
        local impoundMenu = Menu:Create('Impound', 'Impound')
        for k, vehicle in ipairs(vehicles) do
            local plate = GetVehicleNumberPlateText(vehicle)
            local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            impoundMenu.Add:Button(plate .. ' - ' .. model, nil, function()
                Callbacks:ServerCallback('Garage:StoreVehicle', {
                    plate = plate,
                    location = impound.Name,
                    damage = Game.Vehicles:GetDamage(vehicle)
                }, function()
                    Game.Vehicles:Delete(vehicle)
                    menu:Close()
                end)
            end)
        end
        menu.Add:SubMenu('Impound', impoundMenu)
    end
    Callbacks:ServerCallback('Garage:GetVehicleForLocation', { location = impound.Name }, function(results)
        if #results > 0 then
            local releaseMenu = Menu:Create('Release', 'Release')
            for k, v in ipairs(results) do
                releaseMenu.Add:Button(v.Plate .. ' - ' .. GetDisplayNameFromVehicleModel(v.Properties.model), nil,
                    function()
                        Callbacks:ServerCallback('Garage:ReleaseVehicle', {
                            plate = v.Plate
                        }, function(result)
                            if result then
                                Game.Vehicles:Spawn(impound.Impound, v.Properties.model, 0.0, function(spawnedVehicle)
                                    Game.Vehicles:SetProperties(spawnedVehicle, v.Properties)
                                    Game.Vehicles:SetDamage(spawnedVehicle, v.Damage)
                                    menu:Close()
                                end)
                            end
                        end)
                    end)
            end
            menu.Add:SubMenu('Release', releaseMenu)
        end
        menu:Show()
    end)
end
