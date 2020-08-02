AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Clotheshop', CLOTHESHOP)
end)

AddEventHandler('Clotheshop:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Markers = exports['bs_base']:FetchComponent('Markers')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Clotheshop', {
        'Markers',
    }, function(error)  
        if #error > 0 then return; end
        RetrieveComponents()
    end)
end)

RegisterNetEvent('Ped:Client:SetClothesShopLocations')
AddEventHandler('Ped:Client:SetClothesShopLocations', function(locations)
    for k, v in pairs(locations) do
        local coords = vector3(v.Coords.x, v.Coords.y, v.Coords.z)
        Markers.MarkerGroups:Add(k .. '_clotheshop', coords, Config.DrawDistance)
        Markers.Markers:Add(k .. '_clotheshop', k .. '_clotheshop_shop', coords, 1, vector3(1, 1, 0.5), { r = 255, b = 255, g = 0 }, function()
            return true
        end, 'Press {key}E{/key} for Clothes Shop', function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            Clotheshop:Show({
                x = x,
                y = y,
                z = z,
                h = 326.63702392578
            })
        end)
    end
end)

local cam = nil
CLOTHESHOP = {
    Show = function(self, data)
        FROZEN = true
        local player = PlayerPedId()

        ClearPedTasksImmediately(player)
        SetEntityCoords(player, data.x, data.y, data.z)
        SetEntityHeading(player, data.h)

        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
        AttachCamToPedBone(cam, player, 31085, 0.5, 2.0, 0.5, 0.0)
        SetCamRot(cam, -15.0, 0.0, 150.0, 0)
        SetCamFov(cam, 75.0)

        NetworkSetEntityInvisibleToNetwork(player, true)
        SetEntityVisible(player, true)
        FreezeEntityPosition(player, true)
        SetPlayerInvincible(player, true)
        SetNuiFocus(true, true)
        Citizen.Wait(100)
        SendNUIMessage({
            type = "SET_STATE",
            data = {
                state = 'SHOP'
            }
        })
        SendNUIMessage({
            type = "APP_SHOW"
        })
    end,
    Hide = function(self)
        local player = PlayerPedId()
        DestroyAllCams(true)
        RenderScriptCams(false, true, 1, true, true)
        FreezeEntityPosition(player, false)
        NetworkSetEntityInvisibleToNetwork(player, false)
        SetEntityVisible(player, true)
        FreezeEntityPosition(player, false)
        SetPlayerInvincible(player, false)
        SetNuiFocus(false, false)
        cam = nil
        FROZEN = false
    end
}