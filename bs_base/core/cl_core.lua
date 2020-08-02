COMPONENTS.Core = {
    _required = { 'Init' },
    _name = 'base',
}

RegisterNetEvent('Core:RagDoll')
AddEventHandler('Core:RagDoll', function()
    local playerPed = PlayerPedId()
    local plyPos = GetEntityCoords(playerPed)
    NetworkResurrectLocalPlayer(plyPos, true, true, false)
    SetPedToRagdoll(playerPed, 6000, 6000, 0, 0, 0, 0)     ---ragdoll
    SetPlayerInvincible(playerPed, true)
    SetEntityHealth(playerPed, 1)
end)

function COMPONENTS.Core.Init(self)
    ShutdownLoadingScreenNui()
    ShutdownLoadingScreen()

    local startDeadAnim = false
    
    local function startDeadAnimation(start)
        local playerPed = PlayerPedId()
        if start then
            startDeadAnim = true
            Citizen.CreateThread(function()
                while startDeadAnim do
                    Citizen.Wait(1000)
                        TriggerEvent('Core:RagDoll')
                    Citizen.Wait(60000)
                end
            end)
        else
            startDeadAnim = false
        end
    end

    Citizen.CreateThread(function()
        while true do
            if NetworkIsPlayerActive(PlayerId()) then
                TriggerEvent('Core:Client:SessionStarted')
                TriggerServerEvent('Core:Server:SessionStarted')
                break
            end
            Citizen.Wait(100)
        end
    end)
    
    Citizen.CreateThread(function()
        while true do
            HideHudComponentThisFrame(7)
            HideHudComponentThisFrame(9)
            HideHudComponentThisFrame(6)
            HideHudComponentThisFrame(8)
            HideHudComponentThisFrame(19)
            HideHudComponentThisFrame(20)
            Citizen.Wait(1)
        end
    end)

    Citizen.CreateThread(function() 
        while true do
            InvalidateIdleCam()
            N_0x9e4cfff989258472()
            Wait(25000)
        end 
    end)

    Citizen.CreateThread(function()
        
        for i = 1, 25 do
            EnableDispatchService(i, false)
        end

        while true do
            local ped = PlayerPedId()
            SetPedHelmet(ped, false)
            if IsPedInAnyVehicle(ped, false) then
                if GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), 0) == ped then
                    if GetIsTaskActive(ped, 165) then
                        SetPedIntoVehicle(ped, GetVehiclePedIsIn(ped, false), 0)
                    end
                end
            end

            if IsEntityDead(ped) then
                local health = GetEntityHealth(ped)
                if health < 99 then
                    SetEntityHealth(ped, 99)
                end
            end

            if IsPedFatallyInjured(ped) and not startDeadAnim then
                startDeadAnimation(true)
            elseif not IsPedFatallyInjured(ped) and startDeadAnim then
                startDeadAnimation(false)
            end



            SetMaxWantedLevel(0)
            SetCreateRandomCopsNotOnScenarios(false)
            SetCreateRandomCops(false)
            SetCreateRandomCopsOnScenarios(false)

            Citizen.Wait(5)
        end
    end)
end

Citizen.CreateThread(function()
    while not exports or exports[GetCurrentResourceName()] == nil do
        Citizen.Wait(1)
    end

    COMPONENTS.Core:Init()

    TriggerEvent('Proxy:Shared:RegisterReady')
    for k, v in pairs(COMPONENTS) do TriggerEvent('Proxy:Shared:ExtendReady', k) end

    Citizen.Wait(1000)

    COMPONENTS.Proxy.ExportsReady = true
    TriggerEvent('Core:Shared:Ready')
    return
end)