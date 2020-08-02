AddEventHandler('Housing:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Logger = exports['bs_base']:FetchComponent('Logger')
    Fetch = exports['bs_base']:FetchComponent('Fetch')
    Database = exports['bs_base']:FetchComponent('Database')
    Default = exports['bs_base']:FetchComponent('Default')
    Chat = exports['bs_base']:FetchComponent('Chat')
    Housing = exports['bs_base']:FetchComponent('Housing')
    RegisterChatCommands()
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Housing', {
        'Callbacks',
        'Logger',
        'Fetch',
        'Database',
        'Default',
        'Chat',
        'Housing',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        RegisterCallbacks()
        DefaultData()
        Startup()
    end)
end)

HOUSING = {
    Manage = {
        Add = function(self, source, interior, price, label, pos)
            local doc = {
                label = label,
                price = price,
                sold = false,
                interior = interior,
                location = {
                    front = pos,
                }
            }

            Database.Game:insertOne({
                collection = 'properties',
                document = doc
            }, function(success, result, insertedIds)
                if not success then
                    return nil
                end
                doc.id = insertedIds[1]
                doc.interior = Config.INTERIORS[interior]
                doc.locked = true
                _properties[doc.id] = doc
                Chat.Send.Server:Single(source, 'Property Added, Property ID: ' .. doc.id)
                TriggerClientEvent('Housing:Client:Add', source, doc)
            end)
        end,
        AddBackdoor = function(self, source, id)
            if _properties[id] ~= nil then
                local coords = GetEntityCoords(GetPlayerPed(source))
                _properties[id].location.backdoor = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                    h = GetEntityHeading(GetPlayerPed(source))
                }
            else

            end
        end,
        Delete = function(self, id)
            Database.Game:deleteOne({
                collection = 'properties',
                _id = id
            }, function(success, result)
                if not success then
                    return nil
                end

                Chat.Send.Server:Single(source, id .. ' Has Been Deleted')
            end)
        end
    },
    Commerce = {
        Sell = function(self)

        end,
        Buy = function(self)

        end,
        Foreclose = function(self)

        end,
    },
    Utils = {
        SetLock = function(self, source, id, locked)
            _properties[id].locked = locked
            -- This is going to be used for display stuff, we check with server when it's actually needed
            TriggerClientEvent('Housing:Client:UpdateLock', -1, id, _properties[id].locked)
            return _properties[id].locked
        end,
        ToggleLock = function(self, source, id)
            _properties[id].locked = not _properties[id].locked
            -- This is going to be used for display stuff, we check with server when it's actually needed
            TriggerClientEvent('Housing:Client:UpdateLock', -1, id, _properties[id].locked)
            return _properties[id].locked
        end,
    },
    Keys = {
        Get = function(self, source)
            return Fetch:Source(source):GetData('Character'):GetData('Keys')
        end,
        Give = function(self, id)
            local char = Fetch:Source(source):GetData('Character')
            local keys = char:GetData('Keys')
            if keys == nil then keys = {} end
            keys[id] = true
            char:SetData('Keys', keys)
            TriggerClientEvent('Characters:Client:SetData', source, char:GetData())
        end,
        Take = function(self, source, id)
            local char = Fetch:Source(source):GetData('Character')
            local keys = char:GetData('Keys')
            if keys == nil then keys = {} end
            keys[id] = nil
            char:SetData('Keys', keys)
            TriggerClientEvent('Characters:Client:SetData', source, char:GetData())
        end,
    }
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Housing', HOUSING)
end)