Callbacks = nil
Punishment = nil
Pwnzor = nil
Logger = nil

local _players = {}
local _blockedExplosions = {}

AddEventHandler('Pwnzor:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Punishment = exports['bs_base']:FetchComponent('Punishment')
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Logger = exports['bs_base']:FetchComponent('Logger')
    Fetch = exports['bs_base']:FetchComponent('Fetch')
    Pwnzor = exports['bs_base']:FetchComponent('Pwnzor')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Pwnzor', {
        'Punishment',
        'Callbacks',
        'Logger',
        'Fetch',
        'Pwnzor',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        RegisterCallbacks()
    end)
end)

AddEventHandler('playerDropped', function()
    Pwnzor.Players:Disconnected(source)
end)

-- AddEventHandler("entityCreated",  function(entity)
--     print(GetEntityModel(entity))
-- end)

AddEventHandler('explosionEvent', function(sender, ev)
    local src = sender
    local player = exports['bs_base']:FetchComponent('Fetch'):Source(src)
    for _, v in ipairs(Config.Components.Explosions.Options.Types) do
        if ev.explosionType == v then
            CancelEvent()

            if _blockedExplosions[src] ~= nil and #_blockedExplosions[src] >= Config.Components.Explosions.Options.Count then
                if not player.Permissions:IsAdmin() then
                    Punishment.Ban:Source(src, -1, 'Explosion Trigger', 'Pwnzor')
                end
            else
                if _blockedExplosions[src] == nil then
                    _blockedExplosions[src] = {
                        { time = os.time(), type = ev.explosionType }
                    }
                else
                    table.insert(_blockedExplosions[src], { time = os.time(), type = ev.explosionType })
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        for k, v in pairs(_blockedExplosions) do
            for k2, v2 in ipairs(v) do
                if os.time() - v2.time > 600000 then
                    table.remove(_blockedExplosions[k], k2)
                end
            end
        end
        Citizen.Wait(5000)
    end
end)

PWNZOR = PWNZOR or {
    _required = { 'Players' },
    Players = {
        Disconnected = function(self, source)
            _players[source] = nil
        end,
        Get = function(self, source, key)
            if _players[source] == nil then
                _players[source] = {}
            end

            return _players[source][key]
        end,
        Set = function(self, source, key)
            _players[source][key] = true
        end,
        Unset = function(self, source, key)
            _players[source][key] = nil
        end
    }
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Pwnzor', PWNZOR)
end)
