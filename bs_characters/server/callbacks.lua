AddEventHandler('Characters:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Middleware = exports['bs_base']:FetchComponent('Middleware')
    Database = exports['bs_base']:FetchComponent('Database')
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    DataStore = exports['bs_base']:FetchComponent('DataStore')
    Logger = exports['bs_base']:FetchComponent('Logger')
    Fetch = exports['bs_base']:FetchComponent('Fetch')
    Logger = exports['bs_base']:FetchComponent('Logger')
    Chat = exports['bs_base']:FetchComponent('Chat')
    AlzarIsAPrickCauseHeDoesStupidThings = exports['bs_base']:FetchComponent('Config')
    RegisterCommands()
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Characters', {
        'Callbacks',
        'Database',
        'Middleware',
        'DataStore',
        'Logger',
        'Fetch',
        'Logger',
        'Chat',
        'Config',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        RegisterCallbacks()
        RegisterMiddleware()
        Startup()
    end)
end)

RegisterNetEvent('haracters:Server:StoreUpdate')
AddEventHandler('haracters:Server:StoreUpdate', function()
    local src = source
    local char = Fetch:Source(src):GetData('Character')

    if char ~= nil then
        local data = char:GetData()
    end
end)

function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Characters:GetServerData', function(source, data, cb)
        local motd = GetConvar('motd', 'Welcome to Blue Sky!')
        Database.Game:find({
            collection = 'changelogs',
            options = {
                sort = {
                    date = -1
                }
            },
            limit = 1
        }, function (success, results)
            if not success then print(json.encode(results)) cb({ changelog = nil, motd = ''}) return end

            if #results > 0 then
                cb({ changelog = results[1], motd = motd})
            else
                cb({ changelog = nil, motd = motd})
            end
        end)
    end)

    Callbacks:RegisterServerCallback('Characters:GetCharacters', function(source, data, cb)
        local player = Fetch:Source(source)
        Database.Game:find({
            collection = 'characters',
            query = {
                User = tostring(player:GetData('ID'))
            }
        }, function (success, results)
            if not success then cb(nil) return end
            local cData = {}
            for k, v in ipairs(results) do
                table.insert(cData, {
                    ID = v._id,
                    First = v.First,
                    Last = v.Last,
                    Phone = v.Phone,
                    DOB = v.DOB,
                    Gender = v.Gender,
                    LastPlayed = v.LastPlayed,
                    Job = v.Job,
                })
            end
            player:SetData('Characters', chars)
            cb(cData)
        end)
    end)

    Callbacks:RegisterServerCallback('Characters:CreateCharacter', function(source, data, cb)
        local player = Fetch:Source(source)
        local pNumber = GeneratePhoneNumber()
        while IsNumberInUse(pNumber) do
            pNumber = GeneratePhoneNumber()
        end

        local doc = {
            User = player:GetData('ID'),
            First = data.first,
            Last = data.last,
            Phone = pNumber,
            Gender = tonumber(data.gender),
            Bio = data.bio,
            DOB = data.dob,
            LastPlayed = -1,
            Job = AlzarIsAPrickCauseHeDoesStupidThings.DefaultJob,
            Armor = 100,
            HP = 200,
            STATUS = {
                PLAYER_HUNGER = 100,
                PLAYER_THIRST = 100,
            }
        }
        
        Database.Game:insertOne({ 
            collection="characters",
            document = doc
        }, function (success, result, insertedIds)
            if not success then return nil end
            doc.ID = insertedIds[1]
            TriggerEvent('Characters:Server:CharacterCreated', doc.ID)
            cb(doc)
        end)
    end)

    Callbacks:RegisterServerCallback('Characters:DeleteCharacter', function(source, data, cb)
        local player = Fetch:Source(source)
        Database.Game:findOne({
            collection = 'characters',
            query = {
                User = player:GetData('ID'), 
                _id = data
            }
        }, function (success, results)
            if not success or not #results then cb(nil) return end
            Database.Game:deleteOne({
                collection = 'characters',
                query = {
                    User = player:GetData('ID'),
                    _id = data
                }
            }, function (success, results)
                TriggerEvent('Characters:Server:CharacterDeleted', data)
                cb(success)
            end)
        end)
    end)

    Callbacks:RegisterServerCallback('Characters:GetSpawnPoints', function(source, data, cb)
        local player = Fetch:Source(source)
        Database.Game:findOne({
            collection = 'characters',
            query = {
                User = player:GetData('ID'),
                _id = data
            }
        }, function (success, results)
            if not success or not #results then cb(nil) return end
            if results[1].LastPlayed == -1 then
                cb({ Config.NewSpawn })
            else
                cb(Spawns)
            end
        end)
    end)

    Callbacks:RegisterServerCallback('Characters:GetCharacterData', function(source, data, cb)
        local player = Fetch:Source(source)
        Database.Game:findOne({
            collection = 'characters',
            query = {
                User = player:GetData('ID'),
                _id = data
            }
        }, function (success, results)
            if not success or not #results then cb(nil) return end
            Database.Game:updateOne({
                collection = 'characters',
                query = {
                    User = player:GetData('ID'),
                    _id = data
                }, 
                update = { 
                    ["$set"] = { 
                        LastPlayed = os.time() * 1000
                    }
                }
            })

            local cData = results[1]
            cData.Source = source
            cData.ID = results[1]._id
            cData._id = nil

            player:SetData('Character', DataStore:CreateStore(source, 'Character', cData))
            cb(cData)
        end)
    end)

    Callbacks:RegisterServerCallback('Characters:Logout', function(source, data, cb)
        local player = Fetch:Source(source)
        Middleware:TriggerEvent('Characters:Logout', source)
        player:SetData('Character', nil)
        cb('ok')
        TriggerClientEvent('Characters:Client:Logout', source)
    end)
end

function RegisterMiddleware() 
    Middleware:Add('Characters:Logout', function(source)
        local player = Fetch:Source(source)
        if player ~= nil then
            local char = player:GetData('Character')
            if char ~= nil then
                StoreData(player:GetData('ID'), char)
            end
        end
    end, 10000)

    Middleware:Add('playerDropped', function(source, message)
        local player = Fetch:Source(source)
        if player ~= nil then
            local char = player:GetData('Character')
            if char ~= nil then
                StoreData(player:GetData('ID'), char)
            end
        end
    end, 10000)
end

function IsNumberInUse(number)
    local var = nil
    Database.Game:findOne({
        collection = 'characters',
        query = {
            phone = number
        }
    }, function (success, results)
        if not success then var = true return end
        var = #results > 0
    end)

    while var == nil do
        Citizen.Wait(10)
    end
end

function GeneratePhoneNumber()
    local areaCode = math.random(50) > 25 and 415 or 628
    local numBase2 = math.random(100,999)
    local numBase3 = math.random(1000,9999)

    return string.format('%s%s%s', areaCode, numBase2, numBase3)
end