AddEventHandler('Wallet:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Database = exports['bs_base']:FetchComponent('Database')
    Logger = exports['bs_base']:FetchComponent('Logger')
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Execute = exports['bs_base']:FetchComponent('Execute')
    Wallet = exports['bs_base']:FetchComponent('Wallet')
    CurrencyConfig = exports['bs_base']:FetchComponent('Config').Currency
    Chat = exports['bs_base']:FetchComponent('Chat')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Wallet', {
        'Database',
        'Logger',
        'Callbacks',
        'Execute',
        'Wallet',
        'Config',
        'Chat',
    }, function(error)
        if #error > 0 then
            return
        end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        RegisterChatCommands()
        RegisterCallbacks()
    end)
end)

function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Wallet:GetCash', function(source, data, cb)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        local char = player:GetData('Character')
        Wallet:Get(char, function(wallet)
            cb(wallet.Cash)
        end)
    end)
end

function RegisterChatCommands()
    Chat:RegisterCommand('cash', function(source, args, rawCommand)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        local char = player:GetData('Character')
        Wallet:Get(char, function(wallet)
            Execute:Client(source, 'Notification', 'Success', "You have " .. CurrencyConfig.Sign .. wallet.Cash)
        end)
    end, {
        help = 'Show Current Cash'
    })
end

WALLET = {
    Create = function(self, char)
        local doc = {
            Char = char:GetData('ID'),
            Cash = 0
        }
        Database.Game:insertOne({
            collection = 'wallets',
            document = doc
        }, function(success, results)
            return
        end)
    end,
    Get = function(self, char, cb)
        Database.Game:findOne({
            collection = 'wallets',
            query = {
                Char = char:GetData('ID')
            }
        }, function(success, results)
            if not success then
                return
            end
            if #results > 0 then
                local _data = results[1]
                _data.Modify = function(self, count)
                    Database.Game:updateOne({
                        collection = 'wallets',
                        query = {
                            Char = results[1].Char
                        },
                        update = {
                            ["$inc"] = {
                                Cash = count
                            }
                        }
                    })
                end
                cb(_data)
            else
                Logger:Error('Wallet', "Looking for non-existent Wallet")
                cb(nil)
            end
        end)
    end
}

RegisterServerEvent('Characters:Server:Spawn')
AddEventHandler('Characters:Server:Spawn', function()
    local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
    local char = player:GetData('Character')
    Database.Game:findOne({
        collection = 'wallets',
        query = {
            Char = char:GetData('ID')
        }
    }, function(success, results)
        if not success then
            return
        end
        if #results == 0 then
            Wallet:Create(char)
        end
    end)
end)

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Wallet', WALLET)
end)