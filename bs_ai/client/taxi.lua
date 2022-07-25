local playerRidingInTaxi = false

AICONTROL.Taxi = {
    Request = function(self)
        if not playerRidingInTaxi then

            playerRidingInTaxi = true
            local playerPed = PlayerPedId()
            local pedCoords = GetEntityCoords(playerPed)
            local vehicle = 0
            local x, y, z = table.unpack(pedCoords)
            local _, coords = GetNthClosestVehicleNode((x + 450.0), (y + 450.0), z, 70, 0, 0, 0) -- Add Distance On To Spawn the Taxi Far Away From the Player
            
            Game.Vehicles:Spawn(coords, 'taxi', 0.0, function(vehicle)
                SetVehicleDoorsLockedForAllPlayers(vehicle, true)

                local blip = AddBlipForEntity(vehicle)
                SetBlipSprite(blip, 198)
                SetBlipColour(blip, 5)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Taxi Cab")
                EndTextCommandSetBlipName(blip)

                local taxiPedModel = GetHashKey("a_m_y_stlat_01")
                local taxiPed = CreatePedInsideVehicle(vehicle, 26, taxiPedModel, -1, true, false)
                SetAmbientVoiceName(ped, "A_M_M_EASTSA_02_LATINO_FULL_01")
                SetBlockingOfNonTemporaryEvents(ped, true)
                SetEntityAsMissionEntity(ped, true, true)

                local function endTaxi()
                    playerPed = PlayerPedId()
                    RemoveBlip(blip)
                    ClearPedTasks(taxiPed)
                    BringVehicleToHalt(vehicle, 5.0, 2000, 0)
                    Citizen.Wait(2000)
                    TaskLeaveVehicle(playerPed, vehicle, 0)
                    Citizen.Wait(5000)
                    TaskVehicleDriveWander(taxiPed, vehicle, 20.0, 786603)

                    Citizen.SetTimeout(300000, function() -- So People Don't Call a Taxi one after another constantly, they can't call another one for 5 minutes after
                        playerRidingInTaxi = false
                    end)
                end

                Citizen.CreateThread(function()
                    local playerPed = PlayerPedId()
                    local pedCoords = GetEntityCoords(playerPed)
                    local vehicleCoords = GetEntityCoords(vehicle)
                    local distance = #(pedCoords - vehicleCoords)
                    TaskVehicleDriveToCoord(taxiPed, vehicle, x, y, z, 20.0, 1, `taxi`, 786603, 3.0, true)
                    SetPedKeepTask(taxiPed, true)

                    Notification:SendAlert('A Taxi Has Been Dispatched To Your Location. It Will be there As Soon As Possible.', 8000)
                    while distance > 15.0 do
                        vehicleCoords = GetEntityCoords(vehicle)
                        distance = #(pedCoords - vehicleCoords)
                        Citizen.Wait(100)
                    end


                    local hasPedEnteredTheVehicle = false
                    SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                    Notification:SendAlert('The Taxi has Reached the Destination you Called From. Press F to Get In to The Back', 8000)
                    Citizen.CreateThread(function()
                        while not hasPedEnteredTheVehicle do
                            Citizen.Wait(5)
                            if IsControlJustReleased(1, 23) then
                                playerPed = PlayerPedId()
                                playerCoords = GetEntityCoords(playerPed)
                                vehicleCoords = GetEntityCoords(vehicle)
                                local distance = #(playerCoords - vehicleCoords)
                                print(distance)
                                if distance < 50.0 then
                                    TaskEnterVehicle(playerPed, vehicle, -1, 2, 1.0, 1, 0)
                                    Citizen.Wait(3000)
                                    Notification:SendAlert('Please set a waypoint on The GPS for the taxi driver to follow. Press E when you have set it. You can override this at any time in the journey. Press SPACEBAR to cancel the journey at any time.', 20000)
                                    hasPedEnteredTheVehicle = true
                                end
                            end
                        end
                    end)

                    Citizen.SetTimeout(120000, function() -- Taxi can fuck off if they don't get in in two minutes
                        if not hasPedEnteredTheVehicle then
                            Game.Vehicles:Delete(vehicle)
                            DeletePed(taxiPed)
                            playerRidingInTaxi = false
                        end
                    end)

                    local driving = false
                    local blipCoords
                    while not driving do
                        Citizen.Wait(5)
                        if IsControlJustReleased(1, 51) then
                            local waypointID = GetFirstBlipInfoId(8)
                            if DoesBlipExist(waypointID) then
                                blipCoords = GetBlipCoords(waypointID)
                                local blipX, blipY, blipZ = table.unpack(blipCoords)
                                TaskVehicleDriveToCoord(taxiPed, vehicle, blipX, blipY, blipZ, 20.0, 1, `taxi`, 786603, 20.0, true)
                                SetDriverAbility(taxiPed, 1.0) 
                                SetDriverAggressiveness(taxiPed, 0.0) 
                                SetPedKeepTask(taxiPed, true)
                                driving = true
                            end
                        end
                    end

                    Citizen.CreateThread(function()
                        while driving do
                            Citizen.Wait(5)
                            if IsControlJustReleased(1, 51) then
                                local waypointID = GetFirstBlipInfoId(8)
                                if DoesBlipExist(waypointID) then
                                    blipCoords = GetBlipCoords(waypointID)
                                    local blipX, blipY, blipZ = table.unpack(blipCoords)
                                    ClearPedTasks(taxiPed)

                                    TaskVehicleDriveToCoord(taxiPed, vehicle, blipX, blipY, blipZ, 20.0, 1, `taxi`, 786603, 20.0, true)
                                    SetPedKeepTask(taxiPed, true)
                                    Notification:SendAlert('Route Redirected')
                                end
                            elseif IsControlJustReleased(1, 55) or IsControlJustReleased(1, 23) then -- SPACE or If They Decide to Fucking Jump Out of a Moving Car
                                driving = false
                                Notification:SendAlert('Taxi Journey Completed Early.')
                                endTaxi()
                            end
                        end
                    end)

                    Citizen.CreateThread(function()
                        while driving do
                            Citizen.Wait(600)
                            vehicleCoords = GetEntityCoords(vehicle)
                            local distance = #(vector2(blipCoords.x, blipCoords.y) - vector2(vehicleCoords.x, vehicleCoords.y))
                            print(distance)
                            if distance < 10.0 then
                                driving = false
                                Notification:SendAlert('You Have Reached Your Destination.')
                                endTaxi()
                            end
                        end
                    end)
                end)

            end)
        else
            Notification:SendError('Cannot Call Taxi at This Time.')
        end
    end
}

RegisterNetEvent('AI:Taxi:Request')
AddEventHandler('AI:Taxi:Request', function()
    AI.Taxi:Request()
end)