AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Locations', LOCATIONS)
end)

AddEventHandler('Locations:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Chat = exports['bs_base']:FetchComponent('Chat')
    Database = exports['bs_base']:FetchComponent('Database')
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Locations = exports['bs_base']:FetchComponent('Locations')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Locations', {
        'Chat',
        'Callbacks',
        'Database',
        'Locations',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        RegisterCallbacks()
        RegisterChatCommands()
    end)
end)

function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Locations:GetAll', function(source, data, cb)
        Locations:GetAll(data.type, cb)
    end)
end

function RegisterChatCommands()
    Chat:RegisterAdminCommand('location', function(source, args, rawCommand)
        local playerPed = GetPlayerPed(source)
        local coords = GetEntityCoords(playerPed)
        local heading = GetEntityHeading(playerPed)
        if args[1]:lower() == 'add' and args[2] then
            Locations:Add(coords, heading, args[2], args[3])
        end
    end, {
        help = 'Add Location',
        params = {{
            name = 'Action',
            help = 'Available: add'
        },
        {
            name = 'Type',
            help = 'Type of Location'
        },
        {
            name = 'Name',
            help = 'Name of Location'
        }}
    }, 3)
end

LOCATIONS = {
    Add = function(self, coords, heading, type, name, cb)
        local doc = {
            Coords = {
                x = coords.x,
                y = coords.y,
                z = coords.z,
                h = heading
            },
            Type = type,
            Name = name
        }
        Database.Game:insertOne({
            collection = "locations",
            document = doc
        }, function(success, results)
            if not success then
                return
            end

            TriggerEvent('Locations:Server:Added', type, doc)
            if cb ~= nil then
                cb(results > 1)
            end
        end)
    end,
    GetAll = function(self, type, cb)
        Database.Game:find({
            collection = 'locations',
            query = {
                Type = type
            }
        }, function(success, results)
            if not success then
                return
            end
            for k, location in ipairs(results) do
                results[k].Coords = vector3(location.Coords.x, location.Coords.y, location.Coords.z)
            end
            cb(results)
        end)
    end
}