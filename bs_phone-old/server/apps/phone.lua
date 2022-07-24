local _calls = {}

PHONE.Call = {
    CreateRecord = function(self, record)
        Database.Game:insertOne({
            collection = 'phone_calls',
            document = record
        })
    end,
    Decrypt = function(self, owner, number)
        Database.Game:update({
            collection = 'phone_calls',
            document = {
                owner = owner,
                number = number
            },
            update = {
                ['$set'] = {
                    anonymouse = false
                }
            }
        })
    end,
    Read = function(self, owner)
        Database.Game:update({
            collection = 'phone_calls',
            query = {
                owner = owner
            },
            update = {
                ['$set'] = {
                    unread = false,
                }
            }
        })
    end,
}

RegisterServerEvent('Characters:Server:Spawn')
AddEventHandler('Characters:Server:Spawn', function()
    local src = source
    local char = Fetch:Source(src):GetData('Character')
    Database.Game:find({
        collection = 'phone_calls',
        query = {
            owner = char:GetData('Phone'),
            deleted = false or nil
        },
        options = {
            filter = {
                time = -1
            }
        }
    }, function(success, calls)
        TriggerClientEvent('Phone:Client:SetData', src, 'calls', calls)

        Citizen.CreateThread(function()
            for k, v in ipairs(calls) do
                if v.unread then
                    TriggerClientEvent('Phone:Client:Notifications:Add', src, 'phone', 'phone', 'Missed Call', 'phone', '#c75050', v.time, true, nil)
                end
            end
        end)
    end)
end)

AddEventHandler('Phone:Server:RegisterCallbacks', function()
    Callbacks:RegisterServerCallback('Phone:Phone:CreateCall', function(src, data, cb)
        local char = Fetch:Source(src):GetData('Character')

        _calls[src] = _calls[src] or {}
        table.insert(_calls[src], {
            id = char:GetData('Source'),
            owner = char:GetData('Phone'),
            number = data,
            duration = -1,
            start = os.time(),
            source = char:GetData('Source')
        })

        local target = Fetch:CharacterData('Phone', data)
        if target ~= nil and char:GetData('Phone') ~= target:GetData('Phone') then
            table.insert(_calls[src], {
                id = char:GetData('Source'),
                owner = data,
                number = char:GetData('Phone'),
                duration = -1,
                start = os.time(),
                source = target:GetData('Source')
            })

            TriggerClientEvent('Phone:Client:Phone:RecieveCall', target:GetData('Source'), char:GetData('Source'), char:GetData('Phone'))
        end
        
        cb(char:GetData('Source'))
    end)

    Callbacks:RegisterServerCallback('Phone:Phone:AcceptCall', function(src, data, cb)
        local char = Fetch:Source(src):GetData('Character')

        for k, v in ipairs(_calls[data.id]) do
            TriggerClientEvent('Phone:Client:Phone:AcceptCall', v.source, char:GetData('Phone'))
        end
    end)

    Callbacks:RegisterServerCallback('Phone:Phone:EndCall', function(src, data, cb)
        local char = Fetch:Source(src):GetData('Character')

        print(#_calls[data.id])
        for k, v in ipairs(_calls[data.id]) do
            if #_calls[data.id] == 2 or v.owner == char:GetData('Phone') then
                if v.ended ~= nil then
                    v.duration = math.ceil((v.ended - v.start) / 1000)
                end

                local unread = true
                if v.source == data.id then
                    unread = false
                end

                local call = {
                    owner = v.number,
                    number = v.number,
                    time = v.started,
                    duration = data.duration,
                    method = (v.source == data.id),
                    anonymous = false,
                    unread = unread
                }
                Phone.Call:CreateRecord(call)
                TriggerClientEvent('Phone:Client:Phone:EndCall', v.source, call)
            end
        end
    end)

    Callbacks:RegisterServerCallback('Phone:Phone:ReadCalls', function(src, data, cb)
        local char = Fetch:Source(src):GetData('Character')
        Phone.Call:Read(char:GetData('Phone'))
    end)
end)