doors = {}

-- Event needed so we can be listening for any updates to components that may
-- occur as a result of overriding or extending
AddEventHandler('Doors:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Database = exports['bs_base']:FetchComponent('Database')
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Logger = exports['bs_base']:FetchComponent('Logger')
    Utils = exports['bs_base']:FetchComponent('Utils')
    Doors = exports['bs_base']:FetchComponent('Doors')
    Chat = exports['bs_base']:FetchComponent('Chat')
    Jobs = exports['bs_base']:FetchComponent('Jobs')
    -- Inventory = exports['bs_base']:FetchComponent('Inventory')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Doors', {
        'Database',
        'Callbacks',
        'Logger',
        'Utils',
        'Doors',
        'Chat',
        -- 'Inventory',
        'Jobs'
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        RegisterCallbacks()
        RegisterChatCommands()
        -- RegisterItems()
        Doors:SetDefaultLocks(function(done)
            Doors:Fetch(function(d)
                if Utils:GetTableLength(d) > 0 then
                    for k, v in pairs(d) do
                        v.id = tonumber(v.id)
                        doors[v.id] = v
                    end
                end
            end)
        end)
    end)
end)

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Doors', DOORS)
end)

function RegisterChatCommands()
    Chat:RegisterAdminCommand('doors', function(source, args, rawCommand)
        TriggerClientEvent('Doors:AddDoor', source)
    end, {
        help = 'Add a door'
    })

    Chat:RegisterCommand('policelock', function(source, args, rawCommand)
        TriggerClientEvent('Doors:Lockdown', source)
    end, {
        help = 'Lockdown a door',
        params = {}
    }, -1, { { name = "police", gradelevel = 1 } })
end

-- function RegisterItems()
--     Inventory.Items:RegisterUse('lockpick', 'Doors', function(source, item)
--         TriggerClientEvent('Doors:client:usedLockpick', source, item)
--     end)
-- end

function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Doors:Add', function(source, data, cb)
        Doors:Add(data.settings, source, cb)
    end)
    Callbacks:RegisterServerCallback('Doors:Remove', function(source, data, cb)
        Doors:Remove(data.door, cb)
    end)
    Callbacks:RegisterServerCallback('Doors:Fetch', function(source, data, cb)
        Doors:Fetch(cb)
    end)
    Callbacks:RegisterServerCallback('Doors:AdjustSettings', function(source, data, cb)
        Doors:AdjustSettings(data.door, data.setting, data.value, cb)
    end)
    Callbacks:RegisterServerCallback('Doors:SetLock', function(source, data, cb)
        Doors:SetLock(data.door, data.state, data.lockdown)
    end)
    Callbacks:RegisterServerCallback('Doors:GetJobs', function(source, data, cb)
        Jobs:GetAllJobs(function(jobs)
            cb(jobs)
        end)
    end)
end

DOORS = {
    Add = function(self, settings, source, cb)
        local nextId = 1
        Doors:GetNext(function(next)
            nextId = next
            local dataTable = {
                id = nextId,
                Coords = {
                    x = settings.coords.x,
                    y = settings.coords.y,
                    z = settings.coords.z,
                    h = settings.coords.h
                },
                Pitch = settings.pitch,
                Yaw = settings.yaw,
                DrawDistance = settings.draw,
                Public = settings.privacy,
                Multi = settings.multi,
                DoorType = settings.type,
                Model = settings.model,
                Lock = settings.lock,
                DefaultLock = (settings.defaultLock ~= nil and settings.defaultLock or settings.lock),
                Auth = settings.auth,
                Static = settings.static,
                Lockpickable = settings.lockpickable,
                Lockdown = false
            }
            Database.Game:insertOne({
                collection = 'doors',
                document = dataTable
            }, function(success, result)
                doors[nextId] = dataTable
                if doors[nextId].Multi > 0 then
                    Database.Game:updateOne({
                        collection = 'doors',
                        query = { id = doors[nextId].Multi },
                        update = { ['$set'] = { Multi = nextId } }
                    }, function(s, r)
                        doors[Doors:GetMultiID(nextId)].Multi = nextId
                        TriggerClientEvent('Doors:client:updateNewDoor', -1, tonumber(nextId), dataTable)
                        TriggerClientEvent('Doors:client:adminCancelDoor', source)
                        cb(success)
                        return
                    end)
                end

                if not success then
                    cb(success)
                    return
                end

                TriggerClientEvent('Doors:client:updateNewDoor', -1, tonumber(nextId), dataTable)
                TriggerClientEvent('Doors:client:adminCancelDoor', source)
                cb(success)
                return
            end)
        end)
    end,
    Remove = function(self, door, cb)
        if doors[door].Multi > 0 then
            Doors:AdjustSettings(doors[door].Multi, 'Multi', 0, function() end)
        end
        Database.Game:deleteOne({
            collection = 'doors',
            query = { id = door }
        }, function(success, result)
            if not success then
                cb(success)
                return
            end
            doors[door] = nil
            TriggerClientEvent('Doors:client:deleteDoor', -1, door)
            cb(success)
        end)
    end,
    SetDefaultLocks = function(self, cb)
        Doors:Fetch(function(d)
            if Utils:GetTableLength(d) > 0 then
                for k, v in pairs(d) do
                    Database.Game:updateOne({
                        collection = 'doors',
                        query = { id = v.id },
                        update = { ['$set'] = { Lock = v.DefaultLock } }
                    })
                end
            end
            cb(true)
        end)
    end,
    SetLock = function(self, door, state, lockdown)
        if doors[door] then
            doors[door].Lock = state
            doors[door].Lockdown = lockdown and state or false
            local multi = (doors[door].Multi > 0 and doors[door].Multi or false)
            if multi then doors[Doors:GetMultiID(door)].Lock = state end
            Database.Game:updateOne({
                collection = 'doors',
                query = { id = door },
                update = { ['$set'] = { Lock = state, Lockdown = lockdown and state or false } }
            }, function(success, result)
                if multi then
                    Database.Game:updateOne({
                        collection = 'doors',
                        query = { id = multi },
                        update = { ['$set'] = { Lock = state, Lockdown = lockdown and state or false } }
                    }, function(s, r)
                        TriggerClientEvent('Doors:client:updateDoor', -1, door, state)
                    end)
                else
                    TriggerClientEvent('Doors:client:updateDoor', -1, door, state)
                end
            end)
        end
    end,
    ToggleLock = function(self, door)
        if doors[door] then
            doors[door].Lock = not doors[door].Lock
            local multi = (doors[door].Multi > 0 and doors[door].Multi or false)
            if multi then doors[Doors:GetMultiID(door)].Lock = not doors[Doors:GetMultiID(door)].Lock end
            Database.Game:updateOne({
                collection = 'doors',
                query = { id = door },
                update = { ['$set'] = { Lock = not doors[door].Lock } }
            }, function(success, result)
                if multi then
                    Database.Game:updateOne({
                        collection = 'doors',
                        query = { id = multi },
                        update = { ['$set'] = { Lock = not doors[Doors:GetMultiID(door)].Lock } }
                    }, function(s, r)
                        TriggerClientEvent('Doors:client:updateDoor', -1, door, not doors[Doors:GetMultiID(door)].Lock)
                    end)
                else
                    TriggerClientEvent('Doors:client:updateDoor', -1, door, not doors[Doors:GetMultiID(door)].Lock)
                end
            end)
        end
    end,
    AdjustSettings = function(self, door, setting, value, cb)
        Database.Game:updateOne({
            collection = 'doors',
            query = { id = door },
            update = { ['$set'] = { [setting] = value } }
        }, function(success, result)
            if doors[door].Multi > 0 then
                Database.Game:updateOne({
                    collection = 'doors',
                    query = { id = doors[door].Multi },
                    update = { ['$set'] = { [setting] = value } }
                }, function(s, r)
                    local multiIndex = Doors:GetMultiID(door)
                    doors[multiIndex][setting] = value
                    TriggerClientEvent('Doors:client:updateSettings', -1, multiIndex, setting, value)
                end)
            end
            doors[door][setting] = value
            TriggerClientEvent('Doors:client:updateSettings', -1, door, setting, value)
            cb(success)
        end)
    end,
    Fetch = function(self, cb)
        Database.Game:find({
            collection = 'doors',
            query = {}
        }, function(success, d)
            cb(d)
        end)
    end,
    GetNext = function(self, cb)
        local nextId = Database.Game:updateOne({
            collection = 'counters',
            update = { ['$inc'] = { next = 1 } },
            query = { type = 'doors' },
            options = { upsert = true }
        }, function(success, wtf)
            Database.Game:findOne({
                collection = 'counters',
                query = { type = 'doors' }
            }, function(success, v)
                cb(tonumber(v[1].next))
            end)
        end)
    end,
    GetMultiID = function(self, door)
        if doors[door] then
            local multi = doors[door].Multi
            if multi > 0 then
                for k, v in pairs(doors) do
                    if v.id == multi then
                        return k
                    end
                end
            end

            return 0
        end
    end
}
