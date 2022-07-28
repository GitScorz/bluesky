AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Garage', GARAGES)
end)

GARAGES = {}

AddEventHandler('Garage:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Logger = exports['bs_base']:FetchComponent('Logger')
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Game = exports['bs_base']:FetchComponent('Game')
    Markers = exports['bs_base']:FetchComponent('Markers')
    Menu = exports['bs_base']:FetchComponent('Menu')
    Blips = exports['bs_base']:FetchComponent('Blips')
    Vehicle = exports['bs_base']:FetchComponent('Vehicle')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Garage', {
        'Logger',
        'Callbacks',
        'Game',
        'Markers',
        'Menu',
        'Blips',
        'Vehicle'
    }, function(error)
        if #error > 0 then
            return ;
        end
        RetrieveComponents()
    end)
end)

RegisterNetEvent('Characters:Client:Spawn')
AddEventHandler('Characters:Client:Spawn', function()
    RegisterMarkers()
    RegisterBlips()
end)

function RegisterBlips()
    for k, v in ipairs(Config.Garages) do
        Blips:Add(v.Name, v.Name .. ' Parking', v.Manage, 267, 74, 0.8)
    end
end

function RegisterMarkers()
    for k, v in ipairs(Config.Garages) do
        Markers.MarkerGroups:Add(v.Name, v.Manage, Config.DrawDistance)
        Markers.Markers:Add(v.Name, v.Name .. '_manage', v.Manage, 2, vector3(1, 1, 1), { r = 255, b = 0, g = 0 }, function()
            return true
        end, 'Parking', 1, function()
            OpenMenu(v.Name, v.Spawn)
        end)
        Markers.Markers:Add(v.Name, v.Name .. '_store', v.Store, 1, vector3(5, 5, 3), { r = 255, b = 255, g = 0 }, function()
            return true
        end, '[E] Store', 1, function()
            StoreVehicle(v.Name)
        end)
    end
end

function OpenMenu(location, spawnCoords)
    local manageMenu = Menu:Create('garages_manage', location .. ' Parking')

    Callbacks:ServerCallback('Garage:GetAllVehicles', {}, function(vehicles)
        for _, v in pairs(vehicles) do
            local menuName = v.Plate .. ' - ' .. GetDisplayNameFromVehicleModel(v.Properties.model) .. ' - ' .. v.Location
            if v.State == 0 and v.Location == location then
                local menu = Menu:Create(v.Plate, menuName)
                menu.Add:Button('Spawn', nil, function()
                    Callbacks:ServerCallback('Garage:ReleaseVehicle', {
                        plate = v.Plate
                    }, function(result)
                        if result then
                            Callbacks:ServerCallback('Garage:GetVehicle', {
                                plate = v.Plate
                            }, function(vehicle)
                                Game.Vehicles:Spawn(spawnCoords, vehicle.Properties.model, 0.0, function(spawnedVehicle)
                                    Game.Vehicles:SetProperties(spawnedVehicle, vehicle.Properties)
                                    Game.Vehicles:SetDamage(spawnedVehicle, vehicle.Damage)
                                    Vehicle.Keys:GetKeys(v.Plate, true)
                                end)
                            end)
                        end
                        manageMenu:Close()
                    end)
                end)
                menu.Add:SubMenuBack('Back')
                manageMenu.Add:SubMenu(menuName, menu)
            elseif v.State == 1 then
                local menu = Menu:Create(v.Plate, menuName)
                menu.Add:Button('Request Tow', nil, function()
                    Callbacks:ServerCallback('Garage:Recall', {
                        plate = v.Plate,
                        location = location
                    }, function()
                        manageMenu:Close()
                    end)
                end)
                menu.Add:SubMenuBack('Back')
                manageMenu.Add:SubMenu(menuName, menu)
            else
                local menu = Menu:Create(v.Plate, menuName)
                menu.Add:Button('Set Marker', nil, function()
                    Blips:SetMarker(v.Location)
                    manageMenu:Close()
                end)
                menu.Add:SubMenuBack('Back')
                manageMenu.Add:SubMenu(menuName, menu)
            end
        end
        manageMenu:Show()
    end)
end

RegisterNetEvent('Garage:SaveCar')
AddEventHandler('Garage:SaveCar', function()
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed) then
        local vehicle = GetVehiclePedIsIn(playerPed)
        local data = {
            plate = GetVehicleNumberPlateText(vehicle),
            props = Game.Vehicles:GetProperties(vehicle)
        }
        TriggerServerEvent('Garage:CreateVehicle', data)
    end
end)

function StoreVehicle(location)
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed) then
        local vehicle = GetVehiclePedIsIn(playerPed)
        Callbacks:ServerCallback('Garage:StoreVehicle', {
            location = location,
            plate = GetVehicleNumberPlateText(vehicle),
            damage = Game.Vehicles:GetDamage(vehicle)
        }, function(success)
            if success then
                Game.Vehicles:Delete(vehicle)
            end
        end)
    end
end