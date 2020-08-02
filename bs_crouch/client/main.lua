GLOBAL_PED = nil
characterLoaded = false

local crouchAnimSet = "move_ped_crouched"
local crouched = false

RegisterNetEvent('Characters:Client:Spawn')
AddEventHandler('Characters:Client:Spawn', function()
    characterLoaded = true
    Citizen.CreateThread(function()
        GLOBAL_PED = PlayerPedId()
        while characterLoaded do 
            Citizen.Wait(10000)
            GLOBAL_PED = PlayerPedId()
        end
    end)
    Citizen.CreateThread(function()
        while characterLoaded do
            DisableControlAction(0, 36, true) -- INPUT_DUCK  
            if IsDisabledControlJustPressed(0, 36) then 
                crouched = not crouched
                if crouched then 
                    ResetPedMovementClipset(GLOBAL_PED, 0)
                else
                    if IsPedOnFoot(GLOBAL_PED) then
                        RequestAnimSet(crouchAnimSet)
                        while not HasAnimSetLoaded(crouchAnimSet) do
                            Citizen.Wait(100)
                        end
                        SetPedMovementClipset(GLOBAL_PED, "move_ped_crouched", 0.25)
                    end
                end 
                TriggerEvent('Animations:Client:UpdateCrouch', crouched)
            end
            Citizen.Wait(5)
        end
    end)
end)


RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    characterLoaded = false
end)