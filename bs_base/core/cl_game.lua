COMPONENTS.Game = {
    _protected = true,
    _name = 'base',
}

COMPONENTS.Game = {
    Players = {
        GetPlayerPeds = function(self)
            local players = {}
        
            for _,player in ipairs(GetActivePlayers()) do
                local ped = GetPlayerPed(player)
        
                if DoesEntityExist(ped) then
                    table.insert(players, { ['ped'] = ped, ['id'] = player })
                end
            end
            
            return players
        end,
        GetClosestPlayer = function(self, coords)
            local players         = self:GetPlayerPeds()
            local closestDistance = -1
            local closestPlayer   = -1
            local coords          = coords
            local usePlayerPed    = false
            local playerPed       = PlayerPedId()
            local playerId        = PlayerId()
            if coords == nil then
                usePlayerPed = true
                coords       = GetEntityCoords(playerPed)
            end
        
            for i=1, #players, 1 do
                local target = players[i].ped
        
                if not usePlayerPed or (usePlayerPed and players[i].id ~= playerId) then
                    local targetCoords = GetEntityCoords(target)
                    local distance     = #(targetCoords - vector3(coords.x, coords.y, coords.z))
        
                    if closestDistance == -1 or closestDistance > distance then
                        closestPlayer   = players[i].id
                        closestDistance = distance
                    end
                end
            end
        
            return closestPlayer, closestDistance
        end
    },
    Objects = {
        GetAll = function(self)
            local objects = {}
            for obj in EnumerateObjects() do
                table.insert(objects, obj)
            end
            return objects
        end,
        GetInArea = function(self, coords, radius)
            local objects = {}
            for obj in EnumerateObjects() do
                local objectCoords = GetEntityCoords(obj)
                if GetDistanceBetweenCoords(objectCoords, coords) <= radius then
                    table.insert(objects, obj)
                end
            end
            return objects
        end,
        Spawn = function(self, coords, modelName, heading, cb)
            local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
            Citizen.CreateThread(function()
                COMPONENTS.Stream.RequestModel(model)
                local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)
                SetEntityHeading(obj, heading)
                if cb ~= nil then
                    cb(obj)
                end
            end)
        end,
        SpawnLocal = function(self, coords, modelName, heading, cb)
            local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
            Citizen.CreateThread(function()
                COMPONENTS.Stream.RequestModel(model)

                local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)
                SetEntityHeading(obj, heading)
                if cb ~= nil then
                    cb(obj)
                end
            end)
        end,
        SpawnLocalNoOffset = function(self, coords, modelName, heading, cb)
            local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
            Citizen.CreateThread(function()
                COMPONENTS.Stream.RequestModel(model)

                local obj = CreateObjectNoOffset(model, coords.x, coords.y, coords.z, false, false, true)
                SetEntityHeading(obj, heading)
                if cb ~= nil then
                    cb(obj)
                end
            end)
        end,
        Delete = function(self, obj)
            SetEntityAsMissionEntity(obj, false, true)
            DeleteObject(obj)
        end
    },
    Vehicles = {
        GetAll = function(self)
            local objects = {}
            for obj in EnumerateVehicles() do
                table.insert(objects, obj)
            end
            return objects
        end,
        GetInArea = function(self, coords, radius)
            local objects = {}
            for obj in EnumerateVehicles() do
                local vehicleCoords = GetEntityCoords(obj)
                if GetDistanceBetweenCoords(coords, vehicleCoords) <= radius then
                    table.insert(objects, obj)
                end
            end
            return objects
        end,
        Spawn = function(self, coords, modelName, heading, cb)
            local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
            Citizen.CreateThread(function()
                COMPONENTS.Stream.RequestModel(model)
                local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
                local id = NetworkGetNetworkIdFromEntity(vehicle)
                SetNetworkIdCanMigrate(id, true)
                SetEntityAsMissionEntity(vehicle, true, false)
                SetVehicleHasBeenOwnedByPlayer(vehicle, true)
                SetVehicleNeedsToBeHotwired(vehicle, false)
                RequestCollisionAtCoord(coords.x, coords.y, coords.z)
                SetVehRadioStation(vehicle, 'OFF')
                SetModelAsNoLongerNeeded(model)
                while not HasCollisionLoadedAroundEntity(vehicle) do
                    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
                    Citizen.Wait(0)
                end
                if cb then
                    cb(vehicle)
                end
            end)
        end,
        SpawnLocal = function(self, coords, modelName, heading, cb)
            local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
            Citizen.CreateThread(function()
                COMPONENTS.Stream.RequestModel(model)
                local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, false, false)
                SetEntityAsMissionEntity(vehicle, true, false)
                SetVehicleHasBeenOwnedByPlayer(vehicle, true)
                SetVehicleNeedsToBeHotwired(vehicle, false)
                SetModelAsNoLongerNeeded(model)
                RequestCollisionAtCoord(coords.x, coords.y, coords.z)
                while not HasCollisionLoadedAroundEntity(vehicle) do
                    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
                    Citizen.Wait(0)
                end
                SetVehRadioStation(vehicle, 'OFF')
                if cb then
                    cb(vehicle)
                end
            end)
        end,
        Delete = function(self, vehicle)
            SetEntityAsMissionEntity(vehicle, false, true)
            DeleteVehicle(vehicle)
        end,
        GetInFrontOfPlayer = function(self, distance)
            local playerPed = PlayerPedId()
            local startCoords = GetEntityCoords(playerPed)
            local endCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, distance, 0.0)
            local entityHit = COMPONENTS.ShapeTest.Ray.EntityHit(startCoords, endCoords)
            if entityHit and GetEntityType(entityHit) == 2 then
                return entityHit
            end
            return nil
        end,
        GetProperties = function(self, vehicle)
            if DoesEntityExist(vehicle) then
                local paintType1, _, _ = GetVehicleModColor_1(vehicle)
                local paintType2, _, _ = GetVehicleModColor_2(vehicle)
                local color1, color2 = {}, {}
                color1[1], color1[2], color1[3] = GetVehicleCustomPrimaryColour(vehicle)
                color2[1], color2[2], color2[3] = GetVehicleCustomSecondaryColour(vehicle)
                local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
                local extras = {}

                for id = 0, 12 do
                    if DoesExtraExist(vehicle, id) then
                        local state = IsVehicleExtraTurnedOn(vehicle, id) == 1
                        extras[tostring(id)] = state
                    end
                end
                local fuelLevel = nil
                if DecorExistOn(vehicle, 'VEH_FUEL') then
                    fuelLevel = DecorGetFloat(vehicle, 'VEH_FUEL')
                end

                return {
                    model = GetEntityModel(vehicle),

                    plate = GetVehicleNumberPlateText(vehicle),
                    plateIndex = GetVehicleNumberPlateTextIndex(vehicle),

                    bodyHealth = GetVehicleBodyHealth(vehicle),
                    engineHealth = GetVehicleEngineHealth(vehicle),

                    fuelLevel = fuelLevel or GetVehicleFuelLevel(vehicle),
                    dirtLevel = GetVehicleDirtLevel(vehicle),
                    color1 = color1,
                    color2 = color2,
                    paintType = {paintType1, paintType2},

                    pearlescentColor = pearlescentColor,
                    wheelColor = wheelColor,

                    wheels = GetVehicleWheelType(vehicle),
                    windowTint = GetVehicleWindowTint(vehicle),

                    neonEnabled = {
                        IsVehicleNeonLightEnabled(vehicle, 0),
                        IsVehicleNeonLightEnabled(vehicle, 1),
                        IsVehicleNeonLightEnabled(vehicle, 2),
                        IsVehicleNeonLightEnabled(vehicle, 3)
                    },

                    neonColor = table.pack(GetVehicleNeonLightsColour(vehicle)),
                    extras = extras,
                    tyreSmokeColor = table.pack(GetVehicleTyreSmokeColor(vehicle)),

                    modSpoilers = GetVehicleMod(vehicle, 0),
                    modFrontBumper = GetVehicleMod(vehicle, 1),
                    modRearBumper = GetVehicleMod(vehicle, 2),
                    modSideSkirt = GetVehicleMod(vehicle, 3),
                    modExhaust = GetVehicleMod(vehicle, 4),
                    modFrame = GetVehicleMod(vehicle, 5),
                    modGrille = GetVehicleMod(vehicle, 6),
                    modHood = GetVehicleMod(vehicle, 7),
                    modFender = GetVehicleMod(vehicle, 8),
                    modRightFender = GetVehicleMod(vehicle, 9),
                    modRoof = GetVehicleMod(vehicle, 10),

                    modEngine = GetVehicleMod(vehicle, 11),
                    modBrakes = GetVehicleMod(vehicle, 12),
                    modTransmission = GetVehicleMod(vehicle, 13),
                    modHorns = GetVehicleMod(vehicle, 14),
                    modSuspension = GetVehicleMod(vehicle, 15),
                    modArmor = GetVehicleMod(vehicle, 16),

                    modTurbo = IsToggleModOn(vehicle, 18),
                    modSmokeEnabled = IsToggleModOn(vehicle, 20),
                    modXenon = IsToggleModOn(vehicle, 22),
                    modXenonColor = GetVehicleXenonLightsColour(vehicle) or -1,

                    modFrontWheels = GetVehicleMod(vehicle, 23),
                    modBackWheels = GetVehicleMod(vehicle, 24),

                    modPlateHolder = GetVehicleMod(vehicle, 25),
                    modVanityPlate = GetVehicleMod(vehicle, 26),
                    modTrimA = GetVehicleMod(vehicle, 27),
                    modOrnaments = GetVehicleMod(vehicle, 28),
                    modDashboard = GetVehicleMod(vehicle, 29),
                    modDial = GetVehicleMod(vehicle, 30),
                    modDoorSpeaker = GetVehicleMod(vehicle, 31),
                    modSeats = GetVehicleMod(vehicle, 32),
                    modSteeringWheel = GetVehicleMod(vehicle, 33),
                    modShifterLeavers = GetVehicleMod(vehicle, 34),
                    modAPlate = GetVehicleMod(vehicle, 35),
                    modSpeakers = GetVehicleMod(vehicle, 36),
                    modTrunk = GetVehicleMod(vehicle, 37),
                    modHydrolic = GetVehicleMod(vehicle, 38),
                    modEngineBlock = GetVehicleMod(vehicle, 39),
                    modAirFilter = GetVehicleMod(vehicle, 40),
                    modStruts = GetVehicleMod(vehicle, 41),
                    modArchCover = GetVehicleMod(vehicle, 42),
                    modAerials = GetVehicleMod(vehicle, 43),
                    modTrimB = GetVehicleMod(vehicle, 44),
                    modTank = GetVehicleMod(vehicle, 45),
                    modWindows = GetVehicleMod(vehicle, 46),
                    modLivery = GetVehicleLivery(vehicle)
                }
            else
                return {}
            end
        end,
        SetProperties = function(self, vehicle, props)
            if DoesEntityExist(vehicle) then
                SetVehicleModKit(vehicle, 0)

                local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
                local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
                if props.paintType ~= nil then
                    SetVehicleModColor_1(vehicle, props.paintType[1], 0, 0)
                    SetVehicleModColor_2(vehicle, props.paintType[2], 0, 0)
                end

                if props.plate then
                    SetVehicleNumberPlateText(vehicle, props.plate)
                end
                if props.plateIndex then
                    SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
                end
                if props.bodyHealth then
                    SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0)
                end
                if props.engineHealth then
                    SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0)
                end
                if props.fuelLevel then
                    SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0)
                    DecorSetFloat(vehicle, 'VEH_FUEL', props.fuelLevel + 0.0)
                end
                if props.dirtLevel then
                    SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)
                end
                if props.color1 then
                    ClearVehicleCustomPrimaryColour(vehicle)
                    SetVehicleCustomPrimaryColour(vehicle, props.color1[1], props.color1[2], props.color1[3])
                end
                if props.color2 then
                    ClearVehicleCustomSecondaryColour(vehicle)
                    SetVehicleCustomSecondaryColour(vehicle, props.color2[1], props.color2[2], props.color2[3])
                end
                if props.pearlescentColor then
                    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
                    SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
                end
                if props.wheelColor then
                    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
                    SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor)
                end
                if props.wheels then
                    SetVehicleWheelType(vehicle, props.wheels)
                end
                if props.windowTint then
                    SetVehicleWindowTint(vehicle, props.windowTint)
                end

                if props.neonEnabled then
                    SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
                    SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
                    SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
                    SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
                end

                if props.extras then
                    for id, enabled in pairs(props.extras) do
                        if enabled then
                            SetVehicleExtra(vehicle, tonumber(id), 0)
                        else
                            SetVehicleExtra(vehicle, tonumber(id), 1)
                        end
                    end
                end

                if props.neonColor then
                    SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
                end
                if props.modSmokeEnabled then
                    ToggleVehicleMod(vehicle, 20, true)
                end
                if props.tyreSmokeColor then
                    SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
                end
                if props.modSpoilers then
                    SetVehicleMod(vehicle, 0, props.modSpoilers, false)
                end
                if props.modFrontBumper then
                    SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
                end
                if props.modRearBumper then
                    SetVehicleMod(vehicle, 2, props.modRearBumper, false)
                end
                if props.modSideSkirt then
                    SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
                end
                if props.modExhaust then
                    SetVehicleMod(vehicle, 4, props.modExhaust, false)
                end
                if props.modFrame then
                    SetVehicleMod(vehicle, 5, props.modFrame, false)
                end
                if props.modGrille then
                    SetVehicleMod(vehicle, 6, props.modGrille, false)
                end
                if props.modHood then
                    SetVehicleMod(vehicle, 7, props.modHood, false)
                end
                if props.modFender then
                    SetVehicleMod(vehicle, 8, props.modFender, false)
                end
                if props.modRightFender then
                    SetVehicleMod(vehicle, 9, props.modRightFender, false)
                end
                if props.modRoof then
                    SetVehicleMod(vehicle, 10, props.modRoof, false)
                end
                if props.modEngine then
                    SetVehicleMod(vehicle, 11, props.modEngine, false)
                end
                if props.modBrakes then
                    SetVehicleMod(vehicle, 12, props.modBrakes, false)
                end
                if props.modTransmission then
                    SetVehicleMod(vehicle, 13, props.modTransmission, false)
                end
                if props.modHorns then
                    SetVehicleMod(vehicle, 14, props.modHorns, false)
                end
                if props.modSuspension then
                    SetVehicleMod(vehicle, 15, props.modSuspension, false)
                end
                if props.modArmor then
                    SetVehicleMod(vehicle, 16, props.modArmor, false)
                end
                if props.modTurbo then
                    ToggleVehicleMod(vehicle, 18, props.modTurbo)
                end
                if props.modXenon then
                    ToggleVehicleMod(vehicle, 22, props.modXenon)
                end
                if props.modXenonColor ~= nil then
                    SetVehicleXenonLightsColour(vehicle, props.modXenonColor)
                end
                if props.modFrontWheels then
                    SetVehicleMod(vehicle, 23, props.modFrontWheels, false)
                end
                if props.modBackWheels then
                    SetVehicleMod(vehicle, 24, props.modBackWheels, false)
                end
                if props.modPlateHolder then
                    SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
                end
                if props.modVanityPlate then
                    SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
                end
                if props.modTrimA then
                    SetVehicleMod(vehicle, 27, props.modTrimA, false)
                end
                if props.modOrnaments then
                    SetVehicleMod(vehicle, 28, props.modOrnaments, false)
                end
                if props.modDashboard then
                    SetVehicleMod(vehicle, 29, props.modDashboard, false)
                end
                if props.modDial then
                    SetVehicleMod(vehicle, 30, props.modDial, false)
                end
                if props.modDoorSpeaker then
                    SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
                end
                if props.modSeats then
                    SetVehicleMod(vehicle, 32, props.modSeats, false)
                end
                if props.modSteeringWheel then
                    SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
                end
                if props.modShifterLeavers then
                    SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
                end
                if props.modAPlate then
                    SetVehicleMod(vehicle, 35, props.modAPlate, false)
                end
                if props.modSpeakers then
                    SetVehicleMod(vehicle, 36, props.modSpeakers, false)
                end
                if props.modTrunk then
                    SetVehicleMod(vehicle, 37, props.modTrunk, false)
                end
                if props.modHydrolic then
                    SetVehicleMod(vehicle, 38, props.modHydrolic, false)
                end
                if props.modEngineBlock then
                    SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
                end
                if props.modAirFilter then
                    SetVehicleMod(vehicle, 40, props.modAirFilter, false)
                end
                if props.modStruts then
                    SetVehicleMod(vehicle, 41, props.modStruts, false)
                end
                if props.modArchCover then
                    SetVehicleMod(vehicle, 42, props.modArchCover, false)
                end
                if props.modAerials then
                    SetVehicleMod(vehicle, 43, props.modAerials, false)
                end
                if props.modTrimB then
                    SetVehicleMod(vehicle, 44, props.modTrimB, false)
                end
                if props.modTank then
                    SetVehicleMod(vehicle, 45, props.modTank, false)
                end
                if props.modWindows then
                    SetVehicleMod(vehicle, 46, props.modWindows, false)
                end

                if props.modLivery then
                    SetVehicleMod(vehicle, 48, props.modLivery, false)
                    SetVehicleLivery(vehicle, props.modLivery)
                end
            end
        end,
        GetDamage = function(self, vehicle)
            local damage, windows, tyres, doors = {}, {}, {}, {}

            if not AreAllVehicleWindowsIntact(vehicle) then
                for i = 0, 13, 1 do
                    if i ~= 10 then
                        if not IsVehicleWindowIntact(vehicle, i) then
                            table.insert(windows, i)
                        end
                    end
                end
            end
            damage.windows = windows

            for i = 0, 5, 1 do
                if IsVehicleTyreBurst(vehicle, i, true) then
                    table.insert(tyres, { ['wheel'] = i, ['burst'] = true, ['damage'] = 1000.0 })
                elseif IsVehicleTyreBurst(vehicle, i, false) then
                    table.insert(tyres, { ['wheel'] = i, ['burst'] = false, ['damage'] = GetVehicleWheelHealth(vehicle, i) })
                end
            end
            damage.tyres = tyres

            for i = 0, GetNumberOfVehicleDoors(vehicle), 1 do
                if IsVehicleDoorDamaged(vehicle, i) then
                    table.insert(doors, i)
                end
            end
            damage.doors = doors

            return damage
        end,
        SetDamage = function(self, vehicle, damage)
            SetEntityVisible(vehicle, false, 0)
            if damage.windows and damage.windows[1] ~= nil then
                for _,v in pairs(damage.windows) do
                    if v ~= 10 then
                        SmashVehicleWindow(vehicle, v)
                    end
                end
            end
    
            if damage.doors and damage.doors[1] ~= nil then
                for _,v in pairs(damage.doors) do
                    SetVehicleDoorBroken(vehicle, v, true)
                end
            end
    
            if damage.tyres and damage.tyres[1] ~= nil then
                for _,v in pairs(damage.tyres) do
                    SetVehicleTyreBurst(vehicle, v.wheel, v.burst, v.damage)
                end
            end
            SetEntityVisible(vehicle, true, 0)
        end
    }
}
