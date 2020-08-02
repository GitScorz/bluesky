Blips = nil
Logger = nil
blips = {}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Blips', BLIPS)
end)

AddEventHandler('Blips:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Logger = exports['bs_base']:FetchComponent('Logger')
    Blips = exports['bs_base']:FetchComponent('Blips')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Blips', {
        'Logger',
        'Blips',
    }, function(error)
        if #error > 0 then
            return ;
        end
        RetrieveComponents()
    end)
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler("Characters:Client:Logout", function()
    Blips:RemoveAll()
end)

BLIPS = {
    Add = function(self, id, name, coords, sprite, colour, scale)
        if coords == nil then
            Logger:Error('Blips', "Coords needed for Blip")
            return
        end

        if type(coords) == 'table' then
            coords = vector3(coords.x, coords.y, coords.z)
        end

        local _blip = AddBlipForCoord(coords)
        SetBlipSprite(_blip, sprite or 1)
        SetBlipAsShortRange(_blip, true)
        SetBlipDisplay(_blip, 4)
        SetBlipScale(_blip, scale or 0.8)
        SetBlipColour(_blip, colour or 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(name or 'Name Missing')
        EndTextCommandSetBlipName(_blip)
        blips[id] = {
            blip = _blip,
            coords = coords
        }
    end,
    Remove = function(self, id)
        RemoveBlip(blips[id].blip)
        blips[id] = nil
    end,
    RemoveAll = function(self)
        for k, v in pairs(blips) do
            RemoveBlip(blips[k].blip)
            blips[k] = nil
        end
    end,
    SetMarker = function(self, id)
        print(id)
        local blip = blips[id]
        print(blip)
        SetNewWaypoint(blip.coords.x, blip.coords.y)
    end
}