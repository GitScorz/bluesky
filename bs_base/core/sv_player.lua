COMPONENTS.Players = {}
COMPONENTS.RecentDisconnects = {}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    COMPONENTS.Middleware:Add('playerDropped', function(source, message)
        local player = COMPONENTS.Players[source]
        if player ~= nil then
            local char = player:GetData('Character')
            
            if char ~= nil then
                table.insert(COMPONENTS.RecentDisconnects, { 
                    ['name'] = char:GetData('First')..' '..char:GetData('Last'), 
                    ['reason'] = message, 
                    ['source'] = source, 
                    ['sid'] = COMPONENTS.Players[source]:GetData('SID'), 
                    ['cid'] = char:GetData('ID')
                })
            else
                local player = COMPONENTS.Players[source]
                table.insert(COMPONENTS.RecentDisconnects, { 
                    ['name'] = player:GetData('Name'), 
                    ['reason'] = message, 
                    ['source'] = source, 
                    ['sid'] = player:GetData('SID') 
                })
            end
        end
    end, 10000)
end)

AddEventHandler('playerDropped', function(message)
    local src = source
    COMPONENTS.Middleware:TriggerEvent('playerDropped', src, message)
    COMPONENTS.Players[src] = nil 
    collectgarbage()
end)

AddEventHandler('Queue:Server:SessionActive', function(source, data)
    Citizen.CreateThread(function()
        local pData = COMPONENTS.Player:GetData(source, data)
        if pData == nil then
            DropPlayer(source, 'Unable To Get Your User Data, Please Try To Rejoin')
        else
            COMPONENTS.Players[source] = Player(source, pData)
            TriggerClientEvent('Player:Client:SetData', source, COMPONENTS.Players[source]:GetData())
        end
    end)
end)

COMPONENTS.Player = {
    _required = { 'GetData' },
    _name = 'base',

    --- @param source number The source of the player.
    --- @param data string The data you want to get.
    GetData = function(self, source, data)
        local retVal = -1

        COMPONENTS.Database.Auth:find({
            collection = "users",
            query = {
                sid = data.SID
            },
            limit = 1
        }, function (success, results)
            if not success then retVal = nil return end

            if #results > 0 then
                retVal = {
                    Source = source,
                    ID = results[1]._id,
                    Name = data.Name,
                    SID = data.SID,
                    Identifier = data.Identifier,
                    Roles = data.Roles
                }
            else
                COMPONENTS.Database.Auth:insertOne({ 
                    collection = "users",
                    document = {
                        sid = data.SID,
                        identifier = data.Identifier,
                        priority = 0,
                        name = GetPlayerName(source)
                    }
                }, function (success, result, insertedIds)
                    if not success then
                        COMPONENTS.Logger:Error('Database', '[^8Error^7] Error in insertOne: ' .. tostring(result), { console = true })
                        return
                    end

                    retVal = {
                        Source = source,
                        ID = insertedIds[1],
                        Name = data.Name,
                        SID = data.SID,
                        Identifier = data.Identifier,
                        Roles = data.Roles
                    }
                end)
            end
        end)

        while retVal == -1 do
            Citizen.Wait(10)
        end

        return retVal
    end
}

function Player(source, data)
    local _data = COMPONENTS.DataStore:CreateStore(source, 'Player', data)

    _data.Permissions = {
        IsAdmin = function(self)
            for k, v in ipairs(_data:GetData('Roles')) do
                if v.isDev or v.isAdmin then
                    return true
                end
            end
        end,
        GetLevel = function(self)
            local highest = 0        
            for k, v in ipairs(_data:GetData('Roles')) do
                if v.isDev then
                    highest = 99
                end

                if v.isAdmin then
                    highest = 1
                end
            end

            return highest
        end
    }

    for k, v in ipairs(_data:GetData('Roles')) do
        local group = "user"

        if v.isDev then
            group = "developer"
        elseif v.isAdmin then
            group = "admin"
        end

        ExecuteCommand(('add_principal identifier.%s group.%s'):format(_data:GetData('Identifier'), group))
    end

    return _data
end