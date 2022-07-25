Callbacks = nil
Status = nil

local _statuses = {}
local _recentCd = {}
local _statusCount = 0
local isEnabled = true

AddEventHandler('Status:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Logger = exports['bs_base']:FetchComponent('Logger')
    Damage = exports['bs_base']:FetchComponent('Damage')
    UI = exports['bs_base']:FetchComponent('UI')
    Status = exports['bs_base']:FetchComponent('Status')
    Utils = exports['bs_base']:FetchComponent('Utils')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Status', {
        'Callbacks',
        'Logger',
        'Damage',
        'UI'
        'Status',
        'Utils'
    }, function(error)
        if #error > 0 then
            return ;
        end
        RetrieveComponents()
        RegisterStatuses()
    end)
end)

STATUS = {
    TYPES = {
        FLOAT = 1,
        BOOL = 2,
        INT = 3,
    },
    Register = function(self, name, type, max, id, flash, modify)
        local update = false
        if _statuses[name] ~= nil then
            update = true
        end

        _statuses[name] = {
            name = name,
            type = type,
            max = max,
            id = id,
            flash = flash,
            modify = modify,
        }

        if not update then
            _statusCount = _statusCount + 1
        end

        DecorRegister(name, type)
    end,
    GetRegistered = function(self)
        return _statuses
    end,
    Set = { -- Really much more performant to just interact directly with Decor natives ... but available just in case?
        All = function(self, entity, value)
            for k, v in pairs(_statuses) do
                if v.type == Status.TYPES.FLOAT then
                    DecorSetFloat(entity, v.name, value)
                elseif v.type == Status.TYPES.BOOL then
                    DecorSetBool(entity, v.name, value)
                else
                    DecorSetInt(entity, v.name, value)
                end
                TriggerServerEvent('Status:Server:Update', { status = v.name, value = value })
                TriggerEvent('Status:Client:Update', v.name, value)
            end
        end,
        Single = function(self, entity, name, value)
            if _statuses[name] ~= nil then
                if _statuses[name].type == Status.TYPES.FLOAT then
                    DecorSetFloat(entity, _statuses[name].name, value)
                elseif _statuses[name].type == Status.TYPES.BOOL then
                    DecorSetBool(entity, _statuses[name].name, value)
                else
                    DecorSetInt(entity, _statuses[name].name, value)
                end
                TriggerServerEvent('Status:Server:Update', { status = name, value = value })
                TriggerEvent('Status:Client:Update', name, value)
            end
        end,
    },
    Modify = {
        Add = function(self, status, value, addCd)
            if _statuses[status] ~= nil then
                _statuses[status].modify(value)

                if addCd then
                    _recentCd[status] = 1
                end
            else
                Logger:Error('Status', 'Attempt To Add To Non-Existent Status')
            end
        end,
        Remove = function(self, status, value)
            if _statuses[status] ~= nil then
                _statuses[status].modify(-value)
            else
                Logger:Error('Status', 'Attempt To Add To Non-Existent Status')
            end
        end,
    },
    Toggle = function(self)
        isEnabled = not isEnabled
    end,
    Check = function(self)
        return isEnabled
    end
}

local spawned = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- Wait 5 mins before we start ticks
        if spawned then
            if isEnabled then
                for k, v in pairs(_statuses) do
                    if _recentCd[v.name] == nil or _recentCd[v.name] > 10 then
                        _recentCd[v.name] = nil
                        v.modify()
                    else
                        _recentCd[v.name] = _recentCd[v.name] + 1
                    end
                    Citizen.Wait((60000 / _statusCount)) -- Split tick events across the second-long tick to try to avoid spiking
                end
            end
            Citizen.Wait(0) -- Im just here so you dont crash
        end
    end
end)

RegisterNetEvent('Status:Client:Reset')
AddEventHandler('Status:Client:Reset', function()
    Callbacks:ServerCallback('Commands:ValidateAdmin', {}, function(isAdmin)
        if isAdmin then
            for k, v in pairs(_statuses) do
                Status.Set:Single(PlayerPedId(), v.name, v.max)
            end
        end
    end)
end)

RegisterNetEvent('Characters:Client:Spawn')
AddEventHandler('Characters:Client:Spawn', function()
    spawned = true
    isEnabled = true
    for k, v in pairs(Status:GetRegistered()) do
        Callbacks:ServerCallback('Status:Get', { name = v.name, type = v.type, max = v.max }, function(val)
            waiting = false
            if v.type == Status.TYPES.FLOAT then
                DecorSetFloat(PlayerPedId(), v.name, val)
                UI.Hud.Update({ id = v.id, value = val })
            elseif v.type == Status.TYPES.BOOL then
                DecorSetBool(PlayerPedId(), v.name, val)
                UI.Hud.Update({ id = v.id, value = val })
            else
                DecorSetInt(PlayerPedId(), v.name, val)
                UI.Hud.Update({ id = v.id, value = val })
            end
        end, v.name)
        while waiting do
            Citizen.Wait(100)
        end
    end

end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    spawned = false
    isEnabled = true
    UI.Hud:Reset()
end)

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Status', STATUS)
end)