playerLoaded = false
showing = false
doors = {}

-- Event needed so we can be listening for any updates to components that may
-- occur as a result of overriding or extending
AddEventHandler('Doors:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Logger = exports['bs_base']:FetchComponent('Logger')
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Game = exports['bs_base']:FetchComponent('Game')
    Utils = exports['bs_base']:FetchComponent('Utils')
    Menu = exports['bs_base']:FetchComponent('Menu')
    Notification = exports['bs_base']:FetchComponent('Notification')
    Action = exports['bs_base']:FetchComponent('Action')
    Jobs = exports['bs_base']:FetchComponent('Jobs')
    Doors = exports['bs_base']:FetchComponent('Doors')
    Progress = exports['bs_base']:FetchComponent('Progress')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Doors', {
        'Logger',
        'Callbacks',
        'Game',
        'Utils',
        'Menu',
        'Notification',
        'Action',
        'Jobs',
        'Progress',
        'Doors'
    }, function(error)
        if #error > 0 then
            return
        end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
    end)
end)

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Doors', DOORS)
end)

DOORS = {
    GetCurrentDoor = function(self)
        return showing
    end,
    GetMultiID = function(self, door)
        if doors[door] then
            local multi = doors[door].Multi
            if multi > 0 then
                for k,v in pairs(doors) do
                    if v.id == multi then
                        return k
                    end
                end
            end
            
            return 0
        end
    end,
    ToggleLock = function(self, door)
        if doors[door] and doors[door].Multi > 0 then
            ManageDoubleDoors(door)
        else
            ManageDoor(door)
        end
    end,
    SetLock = function(self, door, lock, lockdown)
        if doors[door] then
            doors[door].Lock = lock
            doors[door].Lockdown = lockdown and lock or false
            Callbacks:ServerCallback('Doors:SetLock', {
                door = door,
                state = lock,
                lockdown = lockdown or false
            })
        end
    end,
    IsAuthorized = function(self, door)
        if doors[door] then
            if doors[door].Static then return false end
            if doors[door].Lockdown and _character and _character.Job.job == 'police' and _character.JobDuty then return true end
            
            local auths = doors[door].Auth
            if auths and Utils:GetTableLength(auths) > 0 then
                for k,v in pairs(auths) do
                    if _character and (_character.Job.job == v.job and _character.Job.grade.level >= v.grade and (v.workplace == 0 or (v.workplace > 0 and _character.Job.workplace.id == v.workplace)) and (not v.dutyNeeded or (v.dutyNeeded and _character.JobDuty))) then
                        return doors[door].Lockdown and 'yes' or true
                    end
                end
            else
                return true
            end
        end
        return false
    end
}

function StartShit()
    Callbacks:ServerCallback('Doors:Fetch', {}, function(d)
        if Utils:GetTableLength(d) > 0 then
            for k,v in pairs(d) do
                v.id = tonumber(v.id)
                doors[v.id] = v
            end
        end
        
        GLOBAL_PED = PlayerPedId()
        GLOBAL_COORDS = GetEntityCoords(GLOBAL_PED)
        _character = exports['bs_base']:FetchComponent('Player').LocalPlayer:GetData('Character'):GetData()
        playerLoaded = true
        Citizen.CreateThread(function()
            while playerLoaded do
                GLOBAL_PED = PlayerPedId()
                Citizen.Wait(5000)
            end
        end)
        
        Citizen.CreateThread(function()
            while playerLoaded do
                if GLOBAL_PED then
                    GLOBAL_COORDS = GetEntityCoords(GLOBAL_PED)
                end
                Citizen.Wait(200)
            end
        end)

        Wait(2000)
        for k,v in pairs(doors) do
            SetInitialState(k)
        end
    end)
end

RegisterNetEvent('Characters:Client:Spawn')
AddEventHandler('Characters:Client:Spawn', function()
    StartShit()
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    playerLoaded = false
end)

RegisterNetEvent('Characters:Client:Updated')
AddEventHandler('Characters:Client:Updated', function()
    _character = exports['bs_base']:FetchComponent('Player').LocalPlayer:GetData('Character'):GetData()
    showing = false
end)

function GetControlOfDoubleDoors(door)
    local multiIndex = Doors:GetMultiID(door)
    local doorCoords = doors[door].Coords
    local doorCoords2 = doors[multiIndex].Coords
    local radius = ((doors[door].DoorType == 'gate' or doors[door].DoorType == 'garage') and 12.0 or 1.0)
    local doorObj = GetClosestObjectOfType(doorCoords.x, doorCoords.y, doorCoords.z, radius, doors[door].Model, false, false, false)
    local doorObj2 = GetClosestObjectOfType(doorCoords2.x, doorCoords2.y, doorCoords2.z, radius, doors[multiIndex].Model, false, false, false)

    return doorObj, doorObj2
end

function GetControlOfDoor(door)
    local doorCoords = doors[door].Coords
    local radius = ((doors[door].DoorType == 'gate' or doors[door].DoorType == 'garage') and 12.0 or 1.0)
    local doorObj = GetClosestObjectOfType(doorCoords.x, doorCoords.y, doorCoords.z, radius, doors[door].Model, false, false, false)
    
    return (DoesEntityExist(doorObj) and doorObj or false)
end

function SetInitialState(door)
    local doorObj = GetControlOfDoor(door)

    if doorObj then
        FreezeEntityPosition(doorObj, doors[door].Lock)

        if doors[door].Lock then
            if doors[door].DoorType == 'gate' then
                SetEntityCoords(doorObj, doors[door].Coords.x, doors[door].Coords.y, doors[door].Coords.z)
            elseif  doors[door].DoorType == 'garage' then
                SetEntityRotation(doorObj, doors[door].Pitch + 0.0, 0.0, doors[door].Yaw + 0.0, 2, true)
            else
                SetEntityRotation(doorObj, 0.0, 0.0, doors[door].Yaw + 0.0, 2, true)
            end
        end
    end
end

function DrawInfo(door, locking)
    if not doors[door].Static then
        local multiIndex = Doors:GetMultiID(door)
        if showing == door or showing == multiIndex then
            local isAuthed = Doors:IsAuthorized(door)
            local actionMsg = ""
            local title = (doors[showing].DoorType == 'gate' and 'Gate' or (doors[showing].DoorType == 'garage' and 'Garage Gate' or 'Door')) .. " "
            
            if (doors[door].Locking or (doors[door].Multi > 0 and multiIndex > 0 and doors[multiIndex].Locking)) and (doors[door].Public or (not doors[door].Public and isAuthed)) then
                actionMsg = "Locking.."
            else
                SetInitialState(door)  
                if showing == multiIndex then SetInitialState(multiIndex); end
                if doors[door].Public or (not doors[door].Public and isAuthed) then
                    local locked = doors[door].Lock
                    local actionAuthed = (isAuthed == true and "Press {key}E{/key} to " .. (doors[door].Lockdown and "remove police lock" or (locked and "unlock" or "lock")) or "")
                    actionMsg = "<center><strong>" .. title .. (not locked and "<span style='color:#00ff00'>Unlocked</span>" or "<span style='color:#ff0000'>" .. (doors[door].Lockdown and "On Lockdown" or "Locked") .. "</span>") .. "</strong><br>" .. "</center>"
                    actionMsg = actionMsg .. actionAuthed
                end
            end

            if actionMsg ~= "" then  Action:Show(actionMsg) end
        end
    else
        SetInitialState(door)
    end
end

function DoorAnim()
    Citizen.CreateThread(function()
        while not HasAnimDictLoaded("anim@heists@keycard@") do
            RequestAnimDict("anim@heists@keycard@")
            Wait(10)
        end
        ClearPedSecondaryTask(GLOBAL_PED)
        TaskPlayAnim(GLOBAL_PED, "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
        Citizen.Wait(850)
        ClearPedTasks(GLOBAL_PED)
    end)
end

function ManageDoubleDoors(door)
    local doorObj, doorObj2 = GetControlOfDoubleDoors(door)

    local lock = not doors[door].Lock
    if lock then
        TriggerServerEvent('Doors:server:updateLockingState', door, true)
        if doors[door].DoorType ~= 'gate' and doors[door].DoorType ~= 'garage' then
            DoorAnim()
        end
        local done, done2, showNotif = false, false, false
        Citizen.CreateThread(function()
            local timeout = Config.SwingTimeout
            local continue = true
            while continue do
                Citizen.Wait(50)
                if timeout > 0 then
                    timeout = timeout - 50
                    local rX, rY, rZ = table.unpack(GetEntityRotationVelocity(doorObj))
                    if doors[door].DoorType == 'gate' then
                        if math.abs(rX) < 0.0000003 and math.abs(rY) < 0.0000003 then
                            local curCoords = GetEntityCoords(doorObj)
                            local dist = #(curCoords - vector3(doors[door].Coords.x, doors[door].Coords.y, doors[door].Coords.z))
                            if dist < 0.1 then
                                continue = false
                            end
                        end
                    else
                        local _,_,yaw = table.unpack(GetEntityRotation(doorObj, 2))
                        if (math.abs(yaw - doors[door].Yaw) < 1.0 or math.abs(yaw - (doors[door].Yaw * -1)) < 1.0) and math.abs(rX) < 0.0000003 and math.abs(rY) < 0.0000003 then
                            continue = false
                        end
                    end
                else
                    showNotif = true
                    lock = false
                    continue = false
                end
            end
            done = true
        end)
        
        local multiIndex = Doors:GetMultiID(door)
        Citizen.CreateThread(function()
            local timeout2 = Config.SwingTimeout
            local continue2 = true
            while continue2 do
                Citizen.Wait(50)
                if timeout2 > 0 then
                    timeout2 = timeout2 - 50
                    local rX2, rY2, rZ2 = table.unpack(GetEntityRotationVelocity(doorObj2))
                    if doors[multiIndex].DoorType == 'gate' then
                        if math.abs(rX2) < 0.0000002 and math.abs(rY2) < 0.0000002 then
                            local curCoords2 = GetEntityCoords(doorObj2)
                            local dist2 = #(curCoords2 - vector3(doors[multiIndex].Coords.x, doors[multiIndex].Coords.y, doors[multiIndex].Coords.z))
                            if dist2 < 0.1 then
                                continue2 = false
                            end
                        end
                    else
                        local _,_,yaw2 = table.unpack(GetEntityRotation(doorObj2, 2))
                        if (math.abs(yaw2 - doors[multiIndex].Yaw) < 1.0 or math.abs(yaw2 - (doors[multiIndex].Yaw * -1)) < 1.0) and math.abs(rX2) < 0.0000002 and math.abs(rY2) < 0.0000002 then
                            continue2 = false
                        end
                    end
                else
                    showNotif = true
                    lock = false
                    continue2 = false
                end
            end
            done2 = true
        end)

        while (not done or not done2) do
            Wait(0)
        end

        TriggerServerEvent('Doors:server:updateLockingState', door, false)

        if lock then
            if doors[door].DoorType == 'gate' then
                SetEntityCoords(doorObj, doors[door].Coords.x, doors[door].Coords.y, doors[door].Coords.z, 0, 0, 0, 0)
                FreezeEntityPosition(doorObj, true)
                SetEntityCoords(doorObj2, doors[multiIndex].Coords.x, doors[multiIndex].Coords.y, doors[multiIndex].Coords.z, 0, 0, 0, 0)
                FreezeEntityPosition(doorObj2, true)
            else
                SetEntityRotation(doorObj, 0.0, 0.0, doors[door].Yaw + 0.0, 2, true)
                FreezeEntityPosition(doorObj, true)
                SetEntityRotation(doorObj2, 0.0, 0.0, doors[multiIndex].Yaw + 0.0, 2, true)
                FreezeEntityPosition(doorObj2, true)
            end
        end

        if showNotif then
            Notification:SendError('There was something preventing one of the doors from closing', 5000)
        end
    else
        TriggerServerEvent('Doors:server:updateLockingState', door, false)
        if doors[door].DoorType ~= 'gate' and doors[door].DoorType ~= 'garage' then
            DoorAnim()
        end
        FreezeEntityPosition(doorObj, false)
        FreezeEntityPosition(doorObj2, false)
    end
    Doors:SetLock(door, lock)
end

function ManageDoor(door)
    local doorObj = GetControlOfDoor(door)

    local lock = not doors[door].Lock
    if lock then
        TriggerServerEvent('Doors:server:updateLockingState', door, true)
        if doors[door].DoorType ~= 'gate' and doors[door].DoorType ~= 'garage' then
            DoorAnim()
        end
        local showNotif = false
        Citizen.CreateThread(function()
            local timeout = Config.SwingTimeout
            local continue = true
            while continue do
                Citizen.Wait(50)
                if timeout > 0 then
                    timeout = timeout - 50
                    local rX, rY, rZ = table.unpack(GetEntityRotationVelocity(doorObj))
                    if doors[door].DoorType == 'garage' then
                        local pitch,_,_ = table.unpack(GetEntityRotation(doorObj, 2))
                        if (math.abs(pitch - doors[door].Pitch) < 2.0 or math.abs(pitch - (doors[door].Pitch * -1)) < 2.0) and math.abs(rX) < 0.00002 and math.abs(rY) < 0.00002 then
                            SetEntityRotation(doorObj, doors[door].Pitch + 0.0, 0.0, doors[door].Yaw + 0.0, 2, true)
                            FreezeEntityPosition(doorObj, true)
                            continue = false
                        end
                    elseif doors[door].DoorType == 'gate' then
                        if math.abs(rX) < 0.0000002 and math.abs(rY) < 0.0000002 then
                            local curCoords = GetEntityCoords(doorObj)
                            local dist = #(curCoords - vector3(doors[door].Coords.x, doors[door].Coords.y, doors[door].Coords.z))
                            if dist < 0.1 then
                                SetEntityCoords(doorObj, doors[door].Coords.x, doors[door].Coords.y, doors[door].Coords.z, 0, 0, 0, 0)
                                FreezeEntityPosition(doorObj, true)
                                continue = false
                            end
                        end
                    else
                        local _,_,yaw = table.unpack(GetEntityRotation(doorObj, 2))
                        
                        if (math.abs(yaw - doors[door].Yaw) < 1.0 or math.abs(yaw - (doors[door].Yaw * -1)) < 1.0) and math.abs(rX) < 0.0000002 and math.abs(rY) < 0.0000002 then
                            SetEntityRotation(doorObj, 0.0, 0.0, doors[door].Yaw + 0.0, 2, true)
                            FreezeEntityPosition(doorObj, true)
                            continue = false
                        end
                    end
                else
                    showNotif = true
                    lock = false
                    continue = false
                end
            end

            if showNotif then
                Notification:SendError('There was something preventing the door from closing', 5000)
            end

            TriggerServerEvent('Doors:server:updateLockingState', door, false)
            Doors:SetLock(door, lock)
        end)
    else
        if doors[door].DoorType ~= 'gate' and doors[door].DoorType ~= 'garage' then
            DoorAnim()
        end
        FreezeEntityPosition(doorObj, false)
        TriggerServerEvent('Doors:server:updateLockingState', door, false)
        Doors:SetLock(door, lock)
    end

    if doors[door].DoorType ~= 'gate' and doors[door].DoorType ~= 'garage' then
        DoorAnim()
    end
end

function ShowInfo(door)
    SetInitialState(door)
    if not doors[door].Static then
        local authed = Doors:IsAuthorized(door)
        local public = doors[door].Public
        local multiIndex = Doors:GetMultiID(door)
        if multiIndex > 0 then SetInitialState(multiIndex); end
        if authed or public then
            DrawInfo(door)

            if authed then
                local multiIndex = Doors:GetMultiID(door)
                local showedNotif = false
                Citizen.CreateThread(function()
                    while (showing == door or showing == multiIndex) do
                        if playerLoaded then
                            if IsControlJustPressed(0, 38) then
                                if doors[door].Lockdown and authed == true then
                                    local dist = #(GLOBAL_COORDS - vector3(doors[door].Coords.x, doors[door].Coords.y, doors[door].Coords.z))
                                    if dist < 1.5 then
                                        Progress:Progress({
                                            name = 'unlockdown',
                                            duration = 5000,
                                            label = 'Removing police locks...',
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
                                                Doors:SetLock(showing, false, true)
                                            end
                                        end)
                                    else
                                        if not showedNotif then
                                            showedNotif = true
                                            Notification:SendError('You need to be closer the door')
                                            Citizen.SetTimeout(3000, function() showedNotif = false end)
                                        end
                                    end
                                elseif not doors[door].Lockdown then
                                    Doors:ToggleLock(door)
                                end
                            end
                        end
                        Citizen.Wait(1)
                    end
                end)
            end
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if playerLoaded then
            for k,v in pairs(doors) do
                local doorCoords = v.Coords
                local dist = #(GLOBAL_COORDS - vector3(doorCoords.x, doorCoords.y, doorCoords.z))
                if dist < v.DrawDistance then
                    if not showing then
                        showing = k
                        ShowInfo(k)
                    end
                elseif showing == k then
                    showing = false
                    Action:Hide()
                end
            end
        end
    end
end)

function GetLastTableElement(table)
    if table and type(table) == 'table' then
        local lastIndex = 0
        for k, v in pairs(table) do
            lastIndex = k
        end
        return lastIndex
    end
    return 0
end