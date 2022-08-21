AddEventHandler('Admin:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Database = exports['bs_base']:FetchComponent('Database')
    Logger = exports['bs_base']:FetchComponent('Logger')
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Fetch = exports['bs_base']:FetchComponent('Fetch')
    Utils = exports['bs_base']:FetchComponent('Utils')
    Jobs = exports['bs_base']:FetchComponent('Jobs')
    Chat = exports['bs_base']:FetchComponent('Chat')
    Wallet = exports['bs_base']:FetchComponent('Wallet')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Admin', {
        'Database',
        'Logger',
        'Callbacks',
        'Fetch',
        'Utils',
        'Jobs',
        'Chat',
        'Wallet'
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        RegisterCallbacks()
        registerChatCommands()
    end)
end)

function registerChatCommands()
    Chat:RegisterAdminCommand('noclip', function(source, args, rawCommand)
        TriggerClientEvent('Admin:noclip:fromServer', source)
    end, {
        help = '[Admin] Toggle NoClip',
    }, 0)

    Chat:RegisterAdminCommand('givecash', function(src, args, raw)
        local amount = tonumber(args[1])

        if amount then
            TriggerEvent('Admin:Wallet:AddCash', src, amount)
        end
    end, {
        help = '[Admin] Give Cash',
        params = {
            {
                name = 'amount',
                help = 'Amount of cash to give'
            }
        }
    }, 1)
end

RegisterServerEvent('Admin:Wallet:AddCash')
AddEventHandler('Admin:Wallet:AddCash', function(source, amount)
    local src = source
    local player = Fetch:Source(src)
    if player ~= nil then
        local char = player:GetData('Character')
        if char ~= nil then
            Wallet:Add(char, amount)
        end
    end
end)

RegisterServerEvent('Admin:Revive:WithinRange')
AddEventHandler('Admin:Revive:WithinRange', function(coords)
    local src = source
    local player = exports['bs_base']:FetchComponent('Fetch'):Source(src)
    if player ~= nil then
        local char = player:GetData('Character')
        if char ~= nil then
            Logger:Trace('Admin', char:GetData('First') .. ' ' .. char:GetData('Last') .. ' has used Revive within Range')
            TriggerClientEvent('Admin:Revive:Client:WithinRange', -1, coords)
        end
    end
end)

RegisterServerEvent('Admin:Revive:Player')
AddEventHandler('Admin:Revive:Player', function(playerIdenter)
    local src = source
    local player = exports['bs_base']:FetchComponent('Fetch'):Source(src)
    if player ~= nil then
        local char = player:GetData('Character')
        if char ~= nil then
            Logger:Trace('Admin',
                char:GetData('First') ..
                ' ' .. char:GetData('Last') .. ' has used Revive Player - Revived Player: ' .. playerIdenter)
            TriggerClientEvent('Admin:Revive:Client:All', playerIdenter)
        end
    end
end)

RegisterServerEvent('Admin:Revive:All')
AddEventHandler('Admin:Revive:All', function()
    local src = source
    local player = exports['bs_base']:FetchComponent('Fetch'):Source(src)
    if player ~= nil then
        local char = player:GetData('Character')
        if char ~= nil then
            Logger:Trace('Admin', char:GetData('First') ..
                ' ' .. char:GetData('Last') .. ' has used Revive All Server Players')
            TriggerClientEvent('Admin:Revive:Client:All', -1)
        end
    end
end)

function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Admin:receiveRecentDisconnects', function(source, data, cb)
        local RecentDisconnects = exports['bs_base']:FetchComponent('RecentDisconnects')
        cb(RecentDisconnects)
    end)

    Callbacks:RegisterServerCallback('Admin:receiveActivePlayers', function(source, data, cb)
        local activePlayers = exports['bs_base']:FetchComponent('Fetch'):All()
        local playersToReturn = {}
        for k, v in pairs(activePlayers) do
            local player = v:GetData('Character')
            if player ~= nil then
                table.insert(playersToReturn,
                    { ['name'] = player:GetData('First') .. ' ' .. player:GetData('Last'),
                        ['source'] = v:GetData('Source'), ['sid'] = v:GetData('SID'), ['cid'] = player:GetData('ID') })
            end
        end
        cb(playersToReturn)
    end)

    Callbacks:RegisterServerCallback('Admin:receiveSpawnLocations', function(source, data, cb)
        Database.Game:find({
            collection = 'locations',
            query = {
                Type = 'spawn'
            }
        }, function(success, results)
            if not success then
                return
            end
            cb(results)
        end)
    end)
end

RegisterServerEvent('Admin:server:toggleDuty')
AddEventHandler('Admin:server:toggleDuty', function()
    Jobs.Player:ToggleAutoDefineDuty(source)
end)

RegisterServerEvent('Admin:server:banPlayer')
AddEventHandler('Admin:server:banPlayer', function(plySrc, time, reason)
    if source then
        local src = source
        if plySrc and time and reason then
            exports['bs_base']:FetchComponent('Punishment').Ban:Source(tonumber(plySrc), tonumber(time), reason, src)
        end
    end
end)

RegisterServerEvent('Admin:server:kickPlayer')
AddEventHandler('Admin:server:kickPlayer', function(plySrc, reason)
    if source then
        local src = source
        if plySrc and reason then
            exports['bs_base']:FetchComponent('Punishment'):Kick(tonumber(plySrc), reason, src)
        end
    end
end)
