progress_action = {
    name = '',
    duration = 0,
    label = '',
    useWhileDead = false,
    canCancel = true,
    controlDisables = {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = false,
    },
    animation = {
        animDict = nil,
        anim = nil,
        flags = 0,
        task = nil,
    },
    prop = {
        model = nil,
        bone = nil,
        coords = { x = 0.0, y = 0.0, z = 0.0 },
        rotation = { x = 0.0, y = 0.0, z = 0.0 },
    },
    propTwo = {
        model = nil,
        bone = nil,
        coords = { x = 0.0, y = 0.0, z = 0.0 },
        rotation = { x = 0.0, y = 0.0, z = 0.0 },
    },
}

local isDoingAction = false
local disableMouse = false
local wasCancelled = false
local isAnim = false
local isProp = false
local isPropTwo = false
local prop_net = nil
local propTwo_net = nil
local runProgThread = false

PROGRESS = {
    CurrentAction = function(self)
        return progress_action.name
    end,
    Progress = function(self, action, finish)
        Process(action, nil, nil, finish)
    end,
    ProgressWithStartEvent = function(self, action, start, finish)
        Process(action, start, nil, finish)
    end,
    ProgressWithTickEvent = function(self, action, tick, finish)
        Process(action, nil, tick, finish)
    end,
    ProgressWithStartAndTick = function(self, action, start, tick, finish)
        Process(action, start, tick, finish)
    end,
    Cancel = function(self)
        isDoingAction = false
        wasCancelled = true

        Finish()

        SendNUIMessage({
            action = 'cancel'
        })
    end,
    Fail = function(self)
        isDoingAction = false
        wasCancelled = true

        Finish()

        SendNUIMessage({
            action = 'fail'
        })
    end,
}

AddEventHandler('Progress:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Notification = exports['bs_base']:FetchComponent('Notification')
    Progress = exports['bs_base']:FetchComponent('Progress')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Progress', {
        'Progress',
        'Notification',
    }, function(error)
        if #error > 0 then return; end
        RetrieveComponents()
    end)
end)

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Progress', PROGRESS)
end)

function Process(action, start, tick, finish)
    local player = PlayerPedId()
    ActionStart(player, action)
    progress_action = action

    if not IsEntityDead(player) or action.useWhileDead then
        if not isDoingAction then
            isDoingAction = true
            wasCancelled = false
            isAnim = false
            isProp = false

            SendNUIMessage({
                action = 'start',
                duration = action.duration,
                label = action.label,
                cancellable = action.canCancel
            })

            Citizen.CreateThread(function()
                if start ~= nil then
                    start()
                end

                if tick ~= nil then
                    Citizen.CreateThread(function()
                        while isDoingAction do
                            if action.tickrate ~= nil then
                                Citizen.Wait(action.tickrate)
                            else
                                Citizen.Wait(0)
                            end

                            tick()
                        end
                    end)
                end

                while isDoingAction do
                    Citizen.Wait(0)
                    if IsControlJustPressed(0, 178) and action.canCancel then
                        Progress:Cancel()
                    end

                    if IsEntityDead(player) and not action.useWhileDead then
                        Progress:Cancel()
                    end
                end

                if finish ~= nil then
                    finish(wasCancelled)
                end
            end)
        else
            Notification:SendError('You\'re already doing something..')
        end
    else
        Notification:SendError('You\'re already doing something..')
    end
end

function ActionStart(player, action)
    runProgThread = true
    Citizen.CreateThread(function()
        while runProgThread do
            if isDoingAction then
                if not isAnim then
                    if action.animation ~= nil then
                        if action.animation.task ~= nil then
                            TaskStartScenarioInPlace(player, action.animation.task, 0, true)
                        elseif action.animation.animDict ~= nil and action.animation.anim ~= nil then
                            if action.animation.flags == nil then
                                action.animation.flags = 1
                            end

                            if (DoesEntityExist(player) and not IsEntityDead(player)) then
                                loadAnimDict(action.animation.animDict)
                                TaskPlayAnim(player, action.animation.animDict, action.animation.anim, 3.0, 1.0, -1,
                                    action.animation.flags, 0, 0, 0, 0)
                            end
                        else
                            TaskStartScenarioInPlace(player, 'PROP_HUMAN_BUM_BIN', 0, true)
                        end
                    end

                    isAnim = true
                end
                if not isProp and action.prop ~= nil and action.prop.model ~= nil then
                    RequestModel(action.prop.model)

                    while not HasModelLoaded(GetHashKey(action.prop.model)) do
                        Citizen.Wait(0)
                    end

                    local pCoords = GetOffsetFromEntityInWorldCoords(player, 0.0, 0.0, 0.0)
                    local modelSpawn = CreateObject(GetHashKey(action.prop.model), pCoords.x, pCoords.y, pCoords.z, true
                        , true, true)

                    local netid = ObjToNet(modelSpawn)
                    SetNetworkIdExistsOnAllMachines(netid, true)
                    NetworkSetNetworkIdDynamic(netid, true)
                    SetNetworkIdCanMigrate(netid, false)
                    if action.prop.bone == nil then
                        action.prop.bone = 60309
                    end

                    if action.prop.coords == nil then
                        action.prop.coords = { x = 0.0, y = 0.0, z = 0.0 }
                    end

                    if action.prop.rotation == nil then
                        action.prop.rotation = { x = 0.0, y = 0.0, z = 0.0 }
                    end

                    AttachEntityToEntity(modelSpawn, player, GetPedBoneIndex(player, action.prop.bone),
                        action.prop.coords.x, action.prop.coords.y, action.prop.coords.z, action.prop.rotation.x,
                        action.prop.rotation.y, action.prop.rotation.z, 1, 1, 0, 1, 0, 1)
                    prop_net = netid

                    isProp = true

                    if not isPropTwo and action.propTwo ~= nil and action.propTwo.model ~= nil then
                        RequestModel(action.propTwo.model)

                        while not HasModelLoaded(GetHashKey(action.propTwo.model)) do
                            Citizen.Wait(0)
                        end

                        local pCoords = GetEntityCoords(player)
                        local modelSpawn = CreateObject(GetHashKey(action.propTwo.model), pCoords.x, pCoords.y, pCoords.z
                            , true, true, true)

                        local netid = ObjToNet(modelSpawn)
                        SetNetworkIdExistsOnAllMachines(netid, true)
                        NetworkSetNetworkIdDynamic(netid, true)
                        SetNetworkIdCanMigrate(netid, false)
                        if action.propTwo.bone == nil then
                            action.propTwo.bone = 60309
                        end

                        if action.propTwo.coords == nil then
                            action.propTwo.coords = { x = 0.0, y = 0.0, z = 0.0 }
                        end

                        if action.propTwo.rotation == nil then
                            action.propTwo.rotation = { x = 0.0, y = 0.0, z = 0.0 }
                        end

                        AttachEntityToEntity(modelSpawn, player, GetPedBoneIndex(player, action.propTwo.bone),
                            action.propTwo.coords.x, action.propTwo.coords.y, action.propTwo.coords.z,
                            action.propTwo.rotation.x, action.propTwo.rotation.y, action.propTwo.rotation.z, 1, 1, 0, 1,
                            0, 1)
                        propTwo_net = netid

                        isPropTwo = true
                    end
                end

                if action.vehicle and not IsPedInAnyVehicle(player) then
                    Progress:Fail()
                end

                DisableActions(player, action.controlDisables)
            end
            Citizen.Wait(0)
        end
    end)
end

function Finish()
    isDoingAction = false
    ActionCleanup()
end

function ActionCleanup()
    if progress_action.animation ~= nil then
        if progress_action.animation.task ~= nil or
            (progress_action.animation.animDict ~= nil and progress_action.animation.anim ~= nil) then
            ClearPedSecondaryTask(PlayerPedId())
            StopAnimTask(PlayerPedId(), progress_action.animDict, progress_action.anim, 1.0)
        else
            ClearPedTasks(PlayerPedId())
        end
    end

    DeleteEntity(prop_net)
    DeleteEntity(propTwo_net)
    DeleteEntity(NetToObj(prop_net))
    DeleteEntity(NetToObj(propTwo_net))
    prop_net = nil
    propTwo_net = nil
    runProgThread = false
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function DisableActions(ped, disables)
    if disables.disableMouse then
        DisableControlAction(0, 1, true) -- LookLeftRight
        DisableControlAction(0, 2, true) -- LookUpDown
        DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
    end

    if disables.disableMovement then
        DisableControlAction(0, 30, true) -- disable left/right
        DisableControlAction(0, 31, true) -- disable forward/back
        DisableControlAction(0, 36, true) -- INPUT_DUCK
        DisableControlAction(0, 21, true) -- disable sprint
    end

    if disables.disableCarMovement then
        DisableControlAction(0, 63, true) -- veh turn left
        DisableControlAction(0, 64, true) -- veh turn right
        DisableControlAction(0, 71, true) -- veh forward
        DisableControlAction(0, 72, true) -- veh backwards
        DisableControlAction(0, 75, true) -- disable exit vehicle
    end

    if disables.disableCombat then
        DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
        DisableControlAction(0, 24, true) -- disable attack
        DisableControlAction(0, 25, true) -- disable aim
        DisableControlAction(1, 37, true) -- disable weapon select
        DisableControlAction(0, 47, true) -- disable weapon
        DisableControlAction(0, 58, true) -- disable weapon
        DisableControlAction(0, 140, true) -- disable melee
        DisableControlAction(0, 141, true) -- disable melee
        DisableControlAction(0, 142, true) -- disable melee
        DisableControlAction(0, 143, true) -- disable melee
        DisableControlAction(0, 263, true) -- disable melee
        DisableControlAction(0, 264, true) -- disable melee
        DisableControlAction(0, 257, true) -- disable melee
    end
end
