PW = nil
local characterLoaded = false
local mp_pointing = false
GLOBAL_PED = 0

local _inVeh = false


AddEventHandler('Characters:Client:Spawn', function()
    characterLoaded = true
    StartThreads()
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    characterLoaded = false
end)

RegisterNetEvent('Events:Client:EnteredVehicle')
AddEventHandler('Events:Client:EnteredVehicle', function()
    _inVeh = true

    Citizen.CreateThread(function()
        while not IsPedOnFoot(GLOBAL_PED) do
            if mp_pointing then
                stopPointing()
            end
            Citizen.Wait(100)
        end
        _inVeh = false
    end)
end)

function startPointing()
    if mp_pointing then return end

    mp_pointing = true
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(100)
    end
    SetPedCurrentWeaponVisible(GLOBAL_PED, 0, 1, 1, 1)
    SetPedConfigFlag(GLOBAL_PED, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, GLOBAL_PED, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")

    Citizen.CreateThread(function()
        while mp_pointing do
            local pointingIthink = Citizen.InvokeNative(0x921CE12C489C4C41, GLOBAL_PED)

            if pointingIthink then
                if _inVeh or not mp_pointing then
                    stopPointing()
                else
                    local camPitch = GetGameplayCamRelativePitch()
                    if camPitch < -70.0 then
                        camPitch = -70.0
                    elseif camPitch > 42.0 then
                        camPitch = 42.0
                    end
                    camPitch = (camPitch + 70.0) / 112.0

                    local camHeading = GetGameplayCamRelativeHeading()
                    local cosCamHeading = Cos(camHeading)
                    local sinCamHeading = Sin(camHeading)
                    if camHeading < -180.0 then
                        camHeading = -180.0
                    elseif camHeading > 180.0 then
                        camHeading = 180.0
                    end
                    camHeading = (camHeading + 180.0) / 360.0

                    local blocked = 0
                    local nn = 0

                    local coords = GetOffsetFromEntityInWorldCoords(GLOBAL_PED, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                    local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, GLOBAL_PED, 7);
                    nn,blocked,coords,coords = GetRaycastResult(ray)

                    Citizen.InvokeNative(0xD5BB4025AE449A4E, GLOBAL_PED, "Pitch", camPitch)
                    Citizen.InvokeNative(0xD5BB4025AE449A4E, GLOBAL_PED, "Heading", camHeading * -1.0 + 1.0)
                    Citizen.InvokeNative(0xB0A6CFD2C69C1088, GLOBAL_PED, "isBlocked", blocked)
                    Citizen.InvokeNative(0xB0A6CFD2C69C1088, GLOBAL_PED, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)
                end
            end
            Citizen.Wait(5)
        end
    end)
end

function stopPointing()
    mp_pointing = false
    Citizen.InvokeNative(0xD01015C7316AE176, GLOBAL_PED, "Stop")
    if not IsPedInjured(GLOBAL_PED) then
        ClearPedSecondaryTask(GLOBAL_PED)
    end
    if not IsPedInAnyVehicle(GLOBAL_PED, 1) then
        SetPedCurrentWeaponVisible(GLOBAL_PED, 1, 1, 1, 1)
    end
    SetPedConfigFlag(GLOBAL_PED, 36, 0)
    ClearPedSecondaryTask(GLOBAL_PED)
end

function StartThreads()
    Citizen.CreateThread(function()
        GLOBAL_PED = PlayerPedId()
        while characterLoaded do 
            Citizen.Wait(10000)
            GLOBAL_PED = PlayerPedId()
        end
    end)

    Citizen.CreateThread(function()
        while characterLoaded do
            Citizen.Wait(5)
            if IsControlJustPressed(0, 29) then
                Citizen.Wait(200)
                if mp_pointing then
                    stopPointing()
                else
                    startPointing()
                end
            end
        end
    end)
end