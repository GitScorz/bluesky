RegisterServerEvent('Characters:Server:Spawn')
AddEventHandler('Characters:Server:Spawn', function()
    local src = source
    local char = Fetch:Source(src):GetData('Character')
    Database.Game:find({
        collection = 'phone_contacts',
        query = {
            character = char:GetData('ID')
        }
    }, function(success, contacts)
        TriggerClientEvent('Phone:Client:SetData', src, 'contacts', contacts)
    end)
end)

AddEventHandler('Phone:Server:RegisterCallbacks', function()
    Callbacks:RegisterServerCallback('Phone:Contacts:Create', function(source, data, cb)
        local src = source
        local char = Fetch:Source(src):GetData('Character')

        data.character = char:GetData('ID')
        Database.Game:insertOne({
            collection = 'phone_contacts',
            document = data
        }, function(success, result, insertedIds)
            if not success then return nil end
            cb(insertedIds[1])
        end)
    end)

    Callbacks:RegisterServerCallback('Phone:Contacts:Update', function(source, data, cb)
        local src = source
        local char = Fetch:Source(src):GetData('Character')
        data.character = char:GetData('ID')
        Database.Game:updateOne({
            collection = 'phone_contacts',
            query = {
                character = char:GetData('ID'),
                _id = data.id
            },
            update = {
                ["$set"] = {
                    name = data.name,
                    number = data.number,
                    color = data.color,
                    avatar = data.avatar,
                    favorite = data.favorite
                }
            }
        }, function(success, results)
            if not success then
                cb(nil)
                return nil
            end
            cb(true)
        end)
    end)

    Callbacks:RegisterServerCallback('Phone:Contacts:Delete', function(source, data, cb)
        local src = source
        local char = Fetch:Source(src):GetData('Character')
        Database.Game:deleteOne({
            collection = 'phone_contacts',
            query = {
                character = char:GetData('ID'),
                _id = data
            }
        }, function (success, results)
            cb(success)
        end)
    end)
end)