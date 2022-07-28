local _nearestPump = false
local _fueling = false
local _spawned = false

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    _spawned = false
end)

AddEventHandler('Characters:Client:Spawn', function()
    _spawned = true
    RunThreads()
end)

Citizen.CreateThread(function()
    DecorRegister('VEH_FUEL', 1)

    while true do
        GLOBAL_PED = PlayerPedId()

        if IsPedInAnyVehicle(GLOBAL_PED, true) then
            GLOBAL_VEH = GetVehiclePedIsIn(GLOBAL_PED)
        else
            GLOBAL_VEH = nil
        end

        Citizen.Wait(500)
    end
end)

function RunThreads()
    Citizen.CreateThread(function()
        while _spawned do
            if GLOBAL_VEH ~= nil then
                if not DecorExistOn(GLOBAL_VEH, 'VEH_FUEL') then
                    local val = math.random(200, 800) / 10
                    DecorSetFloat(GLOBAL_VEH, 'VEH_FUEL', val)
                    TriggerEvent('Vehicle:Client:Fuel', Round(val, 1))
                end
    
                FuelTick(GLOBAL_VEH)
                Citizen.Wait(3000)
            else
                Citizen.Wait(100)
            end
        end
    end)
    
    Citizen.CreateThread(function()
        while _spawned do
            local pumpObject, pumpDistance = FindNearestFuelPump()
            if pumpDistance < 5.0 then
                _nearestPump = pumpObject
            else
                _nearestPump = false
                Citizen.Wait(math.ceil(pumpDistance * 20))
            end
    
            Citizen.Wait(250)
        end
    end)
    
    Citizen.CreateThread(function()
        local actionShowing = false
        while _spawned do
            if GLOBAL_VEH == nil then
            if not _fueling and ((_nearestPump and GetEntityHealth(_nearestPump) > 0) or (GetSelectedPedWeapon(GLOBAL_PED) == 883325847 and not _nearestPump)) then
                local veh = GetClosestVehicle(GetEntityCoords(GLOBAL_PED), 2.0, 0, 71)
                
                if veh ~= 0 then
                    local current = DecorGetFloat(veh, 'VEH_FUEL')
                    if not actionShowing and not _fueling then
                        if current < 95.0 then
                            UI.Action:Show('[E] Start Fueling')
                        else
                            UI.Action:Show('Fuel Full', "error")
                        end
                        actionShowing = true
                    end
    
                    local vehCOords = GetEntityCoords(veh)
                    DrawMarker(20, vehCOords.x, vehCOords.y, vehCOords.z + 1.5, 0, 0, 0, 0, 0, GetEntityHeading(veh), 1.0, 1.0, 1.0, 58, 170, 249, 155, false, false, 2, false, false, false, false)
    
                    if IsControlJustReleased(0, 38) then
                        Callbacks:ServerCallback('Fuel:Check', {}, function(cash)
                            if cash >= Config.BaseCost then
                                local start = current
                                local start = current
                                local time = (100 - current) * 1000
    
                                if cash < ((100 - current) * Config.BaseCost) then
                                    time = Round(cash / Config.BaseCost) * 1000
                                end
            
                                Progress:ProgressWithStartAndTick({
                                    name = 'idle',
                                    duration = Round(time, 1),
                                    label = 'Refueling Vehicle',
                                    canCancel = true,
                                    tickrate = 1000,
                                    controlDisables = {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    },
                                    animation = {
                                        animDict = 'weapons@misc@jerrycan@',
                                        anim = 'fire',
                                        flags = 49,
                                    },
                                    prop = {
                                        model = 'prop_jerrycan_01a',
                                        bone = 60309,
                                        coords = { x = 0.0, y = 0.1, z = 0.5 },
                                        rotation = { x = 364.0, y = 180.0, z = 90.0 },
                                    }
                                }, function()
                                    _fueling = true
                                    UI.Action:Hide()
                                    actionShowing = false
            
                                    Citizen.CreateThread(function()
                                        while _fueling do
                                            Print3DText(GetOffsetFromEntityInWorldCoords(veh, 0, 0, 1.2), current)
                                            Citizen.Wait(0)
                                        end
                                    end)
                                end, function()
                                    local c = DecorGetFloat(veh, 'VEH_FUEL')
            
                                    if current < 100.0 then
                                        current = current + 1
                                    else
                                        Progress:Cancel()
                                    end
            
                                    if IsControlJustReleased(0, 178) or DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) or (isNearPump and GetEntityHealth(isNearPump) <= 0) then
                                        _fueling = false
                                        Progress:Cancel()
                                    end
                                end, function(status)
                                    Callbacks:ServerCallback('Fuel:Pay', Round((current - start), 1), function(status)
                                        DecorSetFloat(veh, 'VEH_FUEL', current)
                                        TriggerEvent('Vehicle:Client:Fuel', DecorGetFloat(veh, 'VEH_FUEL'))
                                        Vehicle.Fuel:Refueled(veh)
                                        _fueling = false
                                    end)
            
                                end)
                            else
                                Notification:SendError('Not Enough Cash')
                            end
                        end)
                        
                    end
                    Citizen.Wait(1)
                else
                    if actionShowing then
                        UI.Action:Hide()
                        actionShowing = false
                    end
                    Citizen.Wait(1000)
                end
            else
                if actionShowing then
                    UI.Action:Hide()
                    actionShowing = false
                end
    
                Citizen.Wait(1000)
            end
            else
                if actionShowing then
                    UI.Action:Hide()
                    actionShowing = false
                end
                
                Citizen.Wait(1000)
            end
        end
    end)
end