AddEventHandler('Motels:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Database = exports['bs_base']:FetchComponent('Database')
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Logger = exports['bs_base']:FetchComponent('Logger')
    Chat = exports['bs_base']:FetchComponent('Chat')
    Locations = exports['bs_base']:FetchComponent('Locations')
    Inventory = exports['bs_base']:FetchComponent('Inventory')
    Motels = exports['bs_base']:FetchComponent('Motels')
    RegisterChatCommands()
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Motels', {
        'Database',
        'Callbacks',
        'Logger',
        'Chat',
        'Locations',
        'Inventory',
        'Motels',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        RegisterCallbacks()
    end)
end)

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Motels', MOTELS)
end)

RegisterServerEvent('Motels:server:loadInventory')
AddEventHandler('Motels:server:loadInventory', function()
    local src = source
    local player = exports['bs_base']:FetchComponent('Fetch'):Source(src)
    local id = player:GetData('Character'):GetData('ID')
    Inventory:OpenSecondary(src, 2, 'motel-'..id)
end)

RegisterServerEvent('Characters:Server:Spawn')
AddEventHandler('Characters:Server:Spawn', function()
    Motels.Locations:AssignRandom(source)
end)

AddEventHandler('playerDropped', function()
    Motels.Locations:ClearLocation(source)
end)

function RegisterChatCommands()
    Chat:RegisterCommand('motel', function(source, args, rawCommand)
        TriggerClientEvent('Motel:Spawn', source)
    end, {
        help = 'Spawn a Motel'
    })
    Chat:RegisterCommand('clearmotel', function(source, args, rawCommand)
        TriggerClientEvent('Motel:Clear', source)
    end, {
        help = 'Clears The Motel'
    })
end

function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Motel:SpawnMotel', function(source, data, cb)
        local coords = vector3(data.motel.Coords.x, data.motel.Coords.y, data.motel.Coords.z - 100)
        cb({
            motelCoords = {
                x = coords.x,
                y = coords.y,
                z = coords.z,
                h = 0.0
            }
        })
    end)
end

MOTELS = {
    Locations = {
        Data = {
            AssignLocations = {},
            SpawnedMotels = {}
        },
        AssignRandom = function(self, source)
            Locations:GetAll('motel', function(locations)
                if #locations == 0 then
                    Logger:Error('No Motels Available')
                    return
                end
                local random = math.random(#locations)
                self.Data.AssignLocations[source] = locations[random]
                TriggerClientEvent('Motel:Client:AssignRandom', source, locations[random])
            end)
        end,
        ClearLocation = function(self, source)
            self.Data.AssignLocations[source] = nil
        end
    },
    Spawn = function(self)

    end,

}