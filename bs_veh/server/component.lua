local _keys = {}

AddEventHandler('Vehicle:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Database = exports['bs_base']:FetchComponent('Database')
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Fetch = exports['bs_base']:FetchComponent('Fetch')
    Locations = exports['bs_base']:FetchComponent('Locations')
    Vehicle = exports['bs_base']:FetchComponent('Vehicle')
    Repair = exports['bs_base']:FetchComponent('Repair')
    Chat = exports['bs_base']:FetchComponent('Chat')
    Wallet = exports['bs_base']:FetchComponent('Wallet')
    RegisterChatCommands()
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Vehicle', {
        'Database',
        'Callbacks',
        'Fetch',
        'Locations',
        'Vehicle',
        'Repair',
        'Chat',
        'Wallet',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        RegisterCallbacks()
    end)
end)

VEHICLE = {
    Keys = {
        Has = function(self, source, plate)
            local id = Fetch:Source(source):GetData('Character'):GetData('ID')
            if _keys[id] == nil then return false end
            return _keys[id][plate]
        end,
        Add = function(self, source, plate)
            local id = Fetch:Source(source):GetData('Character'):GetData('ID')
            if _keys[id] == nil then _keys[id] = {} end
            _keys[id][plate] = true
        end,
        Remove = function(self, source, plate)
            local id = Fetch:Source(source):GetData('Character'):GetData('ID')
            if _keys[id] == nil then _keys[id] = {} return end
            _keys[id][plate] = nil
        end,
    }
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Vehicle', VEHICLE)
end)

RegisterServerEvent('Characters:Server:Spawn')
AddEventHandler('Characters:Server:Spawn', function()
    local id = Fetch:Source(source):GetData('Character'):GetData('ID')
    if _keys[id] == nil then _keys[id] = {} end
    TriggerClientEvent('Vehicle:Client:SyncKeys', source, _keys[id])
end)