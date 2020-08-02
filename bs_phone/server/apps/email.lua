PHONE.Email = {
    Read = function(self, charId, id, cb)
        Database.Game:update({
            collection = 'character_emails',
            query = {
                owner = owner,
                _id = id
            },
            update = {
                ['$set'] = {
                    unread = false,
                }
            }
        }, function(success, res)
            return(res > 0)
        end)
    end,
    Send = function(self, serverId, sender, time, subject, body, flags, noBanner)
        local char = Fetch:Source(serverId):GetData('Character')

        if char ~= nil then
            local doc = {
                owner = char:GetData('ID'),
                sender = sender,
                time = time,
                subject = subject,
                body = body,
                unread = true,
                flags = flags
            }

            Database.Game:insertOne({
                collection = 'character_emails',
                document = doc
            }, function(success, res, insertedIds)
                if not success then return end
                doc._id = insertedIds[1]
                TriggerClientEvent('Phone:Client:Email:Receive', serverId, doc, false)
            end)

        end
    end,
    Delete = function(self, charId, id)
        Database.Game:deleteOne({
            collection = 'character_emails',
            query = {
                owner = charId,
                _id = id
            }
        })
    end
}

RegisterServerEvent('Characters:Server:Spawn')
AddEventHandler('Characters:Server:Spawn', function()
    local src = source
    local char = Fetch:Source(src):GetData('Character')
    Database.Game:find({
        collection = 'character_emails',
        query = {
            owner = char:GetData('ID')
        }
    }, function(success, emails)
        TriggerClientEvent('Phone:Client:SetData', src, 'emails', emails)

        Citizen.CreateThread(function()
            for k, v in ipairs(emails) do
                if v.unread then
                    TriggerClientEvent('Phone:Client:Notifications:Add', src, 'email', 'view/' .. v._id, 'Unread Email', 'envelope', PHONE_APPS.email.color, v.time, true, nil)
                end
            end
        end)
    end)
end)

AddEventHandler('Phone:Server:RegisterCallbacks', function()
    Callbacks:RegisterServerCallback('Phone:Email:Read', function(source, data, cb)
        local src = source
        local char = Fetch:Source(src):GetData('Character')
        Phone.Email:Read(char:GetData('Phone'), data, cb)
    end)

    Callbacks:RegisterServerCallback('Phone:Email:Delete', function(source, data, cb)
        local src = source
        local char = Fetch:Source(src):GetData('Character')
        Phone.Email:Delete(char:GetData('ID'), data)
    end)

    Callbacks:RegisterServerCallback('Phone:Email:DeleteExpired', function(source, data, cb)
        local src = source
        local char = Fetch:Source(src):GetData('Character')
        Database.Game:find({
            collection = 'character_emails',
            query = {
                owner = char:GetData('ID'),
                ['flags.expires'] = { ['$lt'] = os.time() * 1000 }
            }
        }, function(success, res)
            Database.Game:delete({
                collection = 'character_emails',
                query = {
                    owner = char:GetData('ID'),
                    ['flags.expires'] = { ['$lt'] = os.time() * 1000 }
                }
            }, function(success2, res2)
                local ids = {}
                for k, v in ipairs(res) do
                    table.insert(ids, v._id)
                end
                cb(ids)
            end)
        end)
    end)
end)