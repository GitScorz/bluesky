local cam = nil

AddEventHandler('Proxy:Shared:ExtendReady', function(component)
    if component == 'Spawn' then
        exports['bs_base']:ExtendComponent(component, SPAWN)
    end
end)

SPAWN = {
    SpawnToWorld = function(self, data, cb)
        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do Citizen.Wait(10) end

        Callbacks:ServerCallback('Ped:CheckPed', {}, function(hasPed)
            if not hasPed then
                cb()
                Creator:Start(data)
            else
                cb()
                Spawn:PlacePedIntoWorld(data)
            end
        end)
    end,
    PlacePedIntoWorld = function(self, data)
        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Citizen.Wait(10)
        end

        local player = PlayerPedId()
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

        DestroyAllCams(true)
        RenderScriptCams(false, true, 1, true, true)
        FreezeEntityPosition(player, false)

        NetworkSetEntityInvisibleToNetwork(player, false)
        SetEntityVisible(player, true)
        FreezeEntityPosition(player, false)
        SetPlayerInvincible(player, false)

        cam = nil

        SetCanAttackFriendly(player, true, true)
        NetworkSetFriendlyFireOption(true)

        SetEntityMaxHealth(PlayerPedId(), 200)
        SetNuiFocus(false, false)
        DisplayHud(false)
        TriggerEvent('Characters:Client:SetFocus', false)

        Ped:ApplyToPed(LocalPed)
        if data.action ~= nil then
            TriggerEvent(data.action, data.data)
        else
            SetEntityCoords(player, data.spawn.location.x, data.spawn.location.y, data.spawn.location.z)
            DoScreenFadeIn(1500)
        end

        TransitionFromBlurred(1500)
    end
}
