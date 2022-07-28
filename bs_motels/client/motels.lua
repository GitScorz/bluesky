local _objects = {}

AddEventHandler('Motels:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Logger = exports['bs_base']:FetchComponent('Logger')
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Markers = exports['bs_base']:FetchComponent('Markers')
    Interiors = exports['bs_base']:FetchComponent('Interiors')
    Motels = exports['bs_base']:FetchComponent('Motels')
    Inventory = exports['bs_base']:FetchComponent('Inventory')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Motels', {
        'Logger',
        'Callbacks',
        'Markers',
        'Interiors',
        'Motels',
        'Inventory',
    }, function(error)  
        if #error > 0 then return; end
        RetrieveComponents()
    end)
end)

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Motels', MOTELS)
end)

RegisterNetEvent('Motel:Clear')
AddEventHandler('Motel:Clear', function()
    Interiors:Delete(_objects)
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    Interiors:Delete(_objects)
end)

RegisterNetEvent('Motel:Client:AssignRandom')
AddEventHandler('Motel:Client:AssignRandom', function(location)
    Motels.Data.Motel = location
    Motels.Location:Register(location)
end)

MOTELS = {
    Data = {
        Motel = nil,
        MotelExit = nil
    },

    --- @param coords vector3
    Spawn = function(self, coords)
        local motel = Interiors.Create.Shell:Motel(coords)
        _objects = motel[1]
        Motels.Data.MotelExit = vector3(motel[2].exit.x + coords.x, motel[2].exit.y + coords.y, motel[2].exit.z + coords.z)
    end,
    
    Clear = function(self)
        Interiors:Delete(_objects)
    end,

    Location = {
        --- @param location string
        Register = function(self, location)
            local player = PlayerPedId()
            Markers.MarkerGroups:Add('motel', location.Coords, Config.DrawDistance)
            Markers.Markers:Add('motel', 'motel', location.Coords, 2, vector3(0.5, 0.5, 0.5), { r = 255, b = 255, g = 0 }, function()
                return true
            end, '[E] Enter Motel', function()
                Callbacks:ServerCallback('Motel:SpawnMotel', {
                    motel = location
                }, function(exitLocation)
                    Motels:Spawn(exitLocation.motelCoords)
                    local markerCoords = vector3(exitLocation.motelCoords.x, exitLocation.motelCoords.y, exitLocation.motelCoords.z)
                    Markers.MarkerGroups:Add('motel', markerCoords, Config.DrawDistance)
                    Markers.Markers:Add('motel', 'motel_exit', Motels.Data.MotelExit, 2, vector3(0.5, 0.5, 0.5), { r = 255, b = 255, g = 0 }, function()
                        return true
                    end, '[E] Leave Motel', function()
                        SetEntityCoords(player, location.Coords)
                        Motels:Clear()
                    end)
                    local stashCoords = vector3(Motels.Data.MotelExit.x, Motels.Data.MotelExit.y + 4.5, Motels.Data.MotelExit.z)
                    Markers.Markers:Add('motel', 'motel_stash', stashCoords, 2, vector3(0.5, 0.5, 0.5), { r = 255, b = 255, g = 0 }, function()
                        return true
                    end, '[E] Stash', function()
                        TriggerServerEvent('Motels:server:loadInventory')
                        --Callbacks:ServerCallback('Inventory:GetSecondInventory', {
                        --    invType = 2
                        --}, function(inventory)
                        --    Inventory.Set.Secondary:Inventory(inventory)
                        --    Inventory.Open:Player()
                        --    Inventory.Open:Secondary()
                        --end)
                    end)
                end)
            end)
        end
    }
}
