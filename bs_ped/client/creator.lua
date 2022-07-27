local _data = nil
local creatorLocation = { x = -1313.93, y = 263.47, z = 62.77, h = 171.13 }


AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Creator', CREATOR)
end)

CREATOR = {
    Start = function(self, data)
        _data = data

        FROZEN = true
        local player = PlayerPedId()

        SetEntityMaxHealth(PlayerPedId(), 200)
        SetTimecycleModifier('default')

        local model = `mp_f_freemode_01`
        if tonumber(data.Gender) == 0 then
            model = `mp_m_freemode_01`
        end

        RequestModel(model)
    
        while not HasModelLoaded(model) do
            Citizen.Wait(500)
        end
        SetPlayerModel(PlayerId(), model)
        player = PlayerPedId()
        SetPedDefaultComponentVariation(player)
        SetEntityAsMissionEntity(player, true, true)
        SetModelAsNoLongerNeeded(model)
        Ped:ApplyToPed(LocalPed)
        SetEntityCoords(player, creatorLocation.x, creatorLocation.y, creatorLocation.z )
        SetEntityHeading(player, creatorLocation.h)

        DoScreenFadeIn(500)
        while not IsScreenFadedIn() do Citizen.Wait(10) end

        TransitionFromBlurred(500)

        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
        AttachCamToPedBone(cam, player, 31085, 0.5, 2.0, 0.5 , 0.0)
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
            data  = {
                state = 'CREATOR'
            }
        })
        SendNUIMessage({
            type = "APP_SHOW"
        })

        

        Citizen.CreateThread(function()
            while FROZEN do
                local pos = GetEntityCoords(PlayerPedId())
                DrawSpotLight(pos, 0, 0, 0, 255, 255, 255, 10, 1.0, 1.0, 10, 1)
                Citizen.Wait(1)
            end
        end)

        Citizen.CreateThread(function()

            RequestAnimDict("amb@world_human_hiker_standing@male@base")
            while not HasAnimDictLoaded("amb@world_human_hiker_standing@male@base") do
                Citizen.Wait(100)
            end

            local playerPed = PlayerPedId()
            while FROZEN do
                if not IsEntityPlayingAnim(playerPed, "amb@world_human_hiker_standing@male@base", "base") then
                    TaskPlayAnim(playerPed, 'amb@world_human_hiker_standing@male@base', 'base', 8.0, -8, -1, 0, 0, 0, 0, 0)
                end
                Citizen.Wait(0)
            end
            ClearPedTasksImmediately(PlayerPedId())
        end)
    end,
    End = function(self)
        local player = PlayerPedId()
        Spawn:PlacePedIntoWorld(_data)
        TriggerEvent('Characters:Client:SetFoucs', false)
        FROZEN = false
    end
}