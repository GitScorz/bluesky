local _interior = {}

AddEventHandler('Interiors:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Interiors = exports['bs_base']:FetchComponent('Interiors')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Interiors', {
        'Callbacks',
        'Interiors',
    }, function(error)  
        if #error > 0 then return; end
        RetrieveComponents()
    end)
end)

function CreateInterior(spawn, interior, offsets)
    local objects = {}
    for k, v in ipairs(interior) do
        local obj = CreateObject(v.object, spawn.x + v.x, spawn.y + v.y, spawn.z + v.y, false, false, false)
        if v.rot ~= nil then
            SetEntityHeading(obj, GetEntityHeading(obj) + v.rot)
        end
        FreezeEntityPosition(obj, true)
        table.insert(objects, obj)
    end
    return { objects, offsets }
end

--[[ TODO: Need To Add Way For Sending Extra Items For Player Custom Spawned Items ]]
INTERIORS = {
    Create = {
        Shell = {
            Motel = function(self, spawn)
                local data = CreateInterior(spawn, Config.Interiors.Motel.Shell, Config.Interiors.Motel.Offsets)
                Interiors.Utils:SendToInterior(spawn.x + Config.Interiors.Motel.Spawn.x, spawn.y + Config.Interiors.Motel.Spawn.y, spawn.z + Config.Interiors.Motel.Spawn.z, spawn.h)
                return data
            end,
            Tier1 = function(self, spawn, isBackdoor)
                local data = CreateInterior(spawn, Config.Interiors.Tier1House.Shell, Config.Interiors.Tier1House.Offsets)

                if not isBackdoor then
                    Interiors.Utils:SendToInterior(spawn.x + Config.Interiors.Tier1House.Spawn.x, spawn.y + Config.Interiors.Tier1House.Spawn.y, spawn.z + Config.Interiors.Tier1House.Spawn.z, spawn.h)
                else
                    Interiors.Utils:SendToInterior(spawn.x + Config.Interiors.Tier1House.Backdoor.x, spawn.y + Config.Interiors.Tier1House.Backdoor.y, spawn.z + Config.Interiors.Tier1House.Backdoor.z, spawn.h)
                end

                return data
            end,
            Tier2 = function(self, spawn, isBackdoor)
                local data = CreateInterior(spawn, Config.Interiors.Tier2House.Shell, Config.Interiors.Tier2House.Offsets)

                if not isBackdoor then
                    Interiors.Utils:SendToInterior(spawn.x + Config.Interiors.Tier2House.Spawn.x, spawn.y + Config.Interiors.Tier2House.Spawn.y, spawn.z + Config.Interiors.Tier1House.Spawn.z, spawn.h)
                else
                    Interiors.Utils:SendToInterior(spawn.x + Config.Interiors.Tier2House.Backdoor.x, spawn.y + Config.Interiors.Tier2House.Backdoor.y, spawn.z + Config.Interiors.Tier1House.Backdoor.z, spawn.h)
                end

                return data
            end,
            Tier3 = function(self, spawn, isBackdoor)
                local data = CreateInterior(spawn, Config.Interiors.Tier3House.Shell, Config.Interiors.Tier3House.Offsets)

                if not isBackdoor then
                    Interiors.Utils:SendToInterior(spawn.x + Config.Interiors.Tier3House.Spawn.x, spawn.y + Config.Interiors.Tier3House.Spawn.y, spawn.z + Config.Interiors.Tier1House.Spawn.z, spawn.h)
                else
                    Interiors.Utils:SendToInterior(spawn.x + Config.Interiors.Tier3House.Backdoor.x, spawn.y + Config.Interiors.Tier3House.Backdoor.y, spawn.z + Config.Interiors.Tier1House.Backdoor.z, spawn.h)
                end

                return data
            end,
        },
        Furnished = {
            Motel = function(self, spawn)
                local data = CreateInterior(spawn, Config.Interiors.Motel.Furnished, Config.Interiors.Motel.Offsets)
                Interiors.Utils:SendToInterior(spawn.x + Config.Interiors.Motel.Spawn.x, spawn.y + Config.Interiors.Motel.Spawn.y, spawn.z + Config.Interiors.Motel.Spawn.z, spawn.h)
                return data
            end,
            Tier1 = function(self, spawn, isBackdoor)
                local data = CreateInterior(spawn, Config.Interiors.Tier1House.Furnished, Config.Interiors.Tier1House.Offsets)

                if not isBackdoor then
                    Interiors.Utils:SendToInterior(spawn.x + Config.Interiors.Tier1House.Spawn.x, spawn.y + Config.Interiors.Tier1House.Spawn.y, spawn.z + Config.Interiors.Tier1House.Spawn.z, spawn.h)
                else
                    Interiors.Utils:SendToInterior(spawn.x + Config.Interiors.Tier1House.Backdoor.x, spawn.y + Config.Interiors.Tier1House.Backdoor.y, spawn.z + Config.Interiors.Tier1House.Backdoor.z, spawn.h)
                end

                return data
            end,
            Tier2 = function(self, spawn, isBackdoor)
                local data = CreateInterior(spawn, Config.Interiors.Tier2House.Furnished, Config.Interiors.Tier2House.Offsets)

                if not isBackdoor then
                    Interiors.Utils:SendToInterior(spawn.x + Config.Interiors.Tier2House.Spawn.x, spawn.y + Config.Interiors.Tier2House.Spawn.y, spawn.z + Config.Interiors.Tier1House.Spawn.z, spawn.h)
                else
                    Interiors.Utils:SendToInterior(spawn.x + Config.Interiors.Tier2House.Backdoor.x, spawn.y + Config.Interiors.Tier2House.Backdoor.y, spawn.z + Config.Interiors.Tier1House.Backdoor.z, spawn.h)
                end

                return data
            end,
            Tier3 = function(self, spawn, isBackdoor)
                local data = CreateInterior(spawn, Config.Interiors.Tier3House.Furnished, Config.Interiors.Tier3House.Offsets)

                if not isBackdoor then
                    Interiors.Utils:SendToInterior(spawn.x + Config.Interiors.Tier3House.Spawn.x, spawn.y + Config.Interiors.Tier3House.Spawn.y, spawn.z + Config.Interiors.Tier1House.Spawn.z, spawn.h)
                else
                    Interiors.Utils:SendToInterior(spawn.x + Config.Interiors.Tier3House.Backdoor.x, spawn.y + Config.Interiors.Tier3House.Backdoor.y, spawn.z + Config.Interiors.Tier1House.Backdoor.z, spawn.h)
                end

                return data
            end,
        }
    },
    Delete = function(self, objects, cb)
        if objects == nil then
            return
        end

        Citizen.CreateThread(function()
            for k, v in pairs(objects) do
                if DoesEntityExist(v) then
                    DeleteEntity(v)
                end
            end
            if cb ~= nil then
                cb()
            end
        end)
    end,
    Utils = {
        SendToInterior = function(self, x, y, z, h)
            Citizen.CreateThread(function()
                DoScreenFadeOut(500)
                --TriggerServerEvent('mythic_sounds:server:PlayOnSource', 'door_open', 0.1)
                while not IsScreenFadedOut() do
                    Citizen.Wait(10)
                end

                SetEntityCoords(PlayerPedId(), x, y, z, 0, 0, 0, false)
                SetEntityHeading(PlayerPedId(), h)

                Citizen.Wait(100)

                DoScreenFadeIn(1000)
            end)
        end,
    }
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Interiors', INTERIORS)
end)