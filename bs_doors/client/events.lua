RegisterNetEvent('Doors:client:updateSettings')
AddEventHandler('Doors:client:updateSettings', function(door, setting, value)
    doors[door][setting] = value
    if doors[door].Multi > 0 then
        local multiIndex = Doors:GetMultiID(door)
        doors[multiIndex][setting] = value
    end
    TriggerEvent('Doors:client:drawShit', door)
end)

RegisterNetEvent('Doors:client:deleteDoor')
AddEventHandler('Doors:client:deleteDoor', function(door)
    local doorObj = GetControlOfDoor(door)
    FreezeEntityPosition(doorObj, false)
    doors[door] = nil
    if showing == door then Action:Hide(); showing = false; Wait(100); end
end)

RegisterNetEvent('Doors:client:updateNewDoor')
AddEventHandler('Doors:client:updateNewDoor', function(id, door)
    local nId = tonumber(id)
    doors[nId] = door
    if doors[nId].Multi > 0 then
        local multiIndex = Doors:GetMultiID(nId)
        doors[multiIndex].Multi = doors[nId].id
        doors[nId].Lock = doors[multiIndex].Lock
        SetInitialState(multiIndex)
    end
    SetInitialState(nId)
end)

RegisterNetEvent('Doors:client:adminCancelDoor')
AddEventHandler('Doors:client:adminCancelDoor', function()
    addingDoor = false
    selectedObject = false
    TriggerEvent('Doors:client:AddDoor')
end)

RegisterNetEvent('Doors:client:updateLockingState')
AddEventHandler('Doors:client:updateLockingState', function(door, state)
    doors[door].Locking = state
    if doors[door].Multi > 0 then
        doors[Doors:GetMultiID(door)].Locking = state
    end
    
    TriggerServerEvent('Doors:server:drawShit', door, state)
end)

RegisterNetEvent('Doors:client:drawShit')
AddEventHandler('Doors:client:drawShit', function(door, locking)
    showing = false
    DrawInfo(door, (locking or false))
end)

RegisterNetEvent('Doors:client:updateDoor')
AddEventHandler('Doors:client:updateDoor', function(door, state)
    local multi = (doors[door].Multi > 0 and doors[door].Multi or false)
    doors[door].Lock = state
    local lock = doors[door].Lock

    if multi then 
        local multiIndex = Doors:GetMultiID(door)
        doors[multiIndex].Lock = state
        local doorObj2 = GetControlOfDoor(multiIndex)
        if lock then
            if doors[door].DoorType == 'door' then
                SetEntityRotation(doorObj2, 0.0, 0.0, doors[multiIndex].Yaw + 0.0, 2, true)
            else
                SetEntityRotation(doorObj2, doors[multiIndex].Pitch + 0.0, 0.0, doors[multiIndex].Yaw + 0.0, 2, true)
            end
        end
        FreezeEntityPosition(doorObj2, lock)
    end

    TriggerServerEvent('Doors:server:drawShit', door)

    local doorObj = GetControlOfDoor(door)

    if lock then
        if doors[door].DoorType == 'door' then
            SetEntityRotation(doorObj, 0.0, 0.0, doors[door].Yaw + 0.0, 2, true)
        else
            SetEntityRotation(doorObj, doors[door].Pitch + 0.0, 0.0, doors[door].Yaw + 0.0, 2, true)
        end
    end

    FreezeEntityPosition(doorObj, lock)
end)

RegisterNetEvent('Doors:client:usedLockpick')
AddEventHandler('Doors:client:usedLockpick', function(item)
    if showing then
        if doors[showing].Lock and doors[showing].Lockpickable and not Doors:IsAuthorized(showing) then
            local dist = #(GLOBAL_COORDS - vector3(doors[showing].Coords.x, doors[showing].Coords.y, doors[showing].Coords.z))
            if dist < 1.5 then
                local chance = math.random(100)
                if chance > Config.Lockpick.chance then
                    Citizen.SetTimeout((math.random(Config.Lockpick.animDuration) * 1000), function() 
                        Progress:Fail()
                        Callbacks:ServerCallback('Inventory:Server:RemoveItem', { item = item }, function(done)
                            Notification:SendError('Your lockpick broke')    
                        end)
                    end)
                end
                Progress:Progress({
                    name = 'lockpick',
                    duration = Config.Lockpick.animDuration * 1000,
                    label = 'Picking the lock',
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                    animation = {
                        animDict = 'mp_arresting',
                        anim = 'a_uncuff',
                        flags = 49,
                    }
                }, function(status)
                    if not status then
                        Doors:SetLock(showing, false)
                        Notification:SendAlert('The door is now open')
                    end
                end)
            end
        end
    end
end)

function CanLockdownDoor(door)
    local auths = doors[door].Auth
    if auths and Utils:GetTableLength(auths) > 0 then
        for k,v in pairs(auths) do
            for i = 1, #Config.EmergencyJobs do
                if v.job == Config.EmergencyJobs[i] then return false end
            end
        end
    end

    return true
end

RegisterNetEvent('Doors:Lockdown')
AddEventHandler('Doors:Lockdown', function()
    if showing then
        local dist = #(GLOBAL_COORDS - vector3(doors[showing].Coords.x, doors[showing].Coords.y, doors[showing].Coords.z))
        if dist < 1.5 then
            if not doors[showing].Lockdown then
                if CanLockdownDoor(showing) then
                    Progress:Progress({
                        name = 'lockdown',
                        duration = 5000,
                        label = 'Locking down door...',
                        canCancel = true,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        },
                        animation = {
                            animDict = 'mp_arresting',
                            anim = 'a_uncuff',
                            flags = 49,
                        }
                    }, function(status)
                        if not status then
                            Doors:SetLock(showing, true, true)
                        end
                    end)
                else
                    Notification:SendError('You can\'t lockdown emergency services doors')
                end
            else
                Notification:SendError('This door is already locked by the Police')
            end
        else
            Notification:SendError('Not near a door')
        end
    else
        Notification:SendError('Not near a door')
    end
end)