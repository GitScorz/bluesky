local _vehicles = {}
local _delay = false
local _keys = {}

local _actionShowing = false

local canAttemptHotwire = true
local canSearchForKey = true

AddEventHandler('Vehicle:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Notification = exports['bs_base']:FetchComponent('Notification')
    UI = exports['bs_base']:FetchComponent('UI')
    Progress = exports['bs_base']:FetchComponent('Progress')
    Vehicle = exports['bs_base']:FetchComponent('Vehicle')
    Repair = exports['bs_base']:FetchComponent('Repair')
    Markers = exports['bs_base']:FetchComponent('Markers')
    Blips = exports['bs_base']:FetchComponent('Blips')
    Menu = exports['bs_base']:FetchComponent('Menu')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Vehicle', {
        'Callbacks',
        'Notification',
        'UI',
        'Progress',
        'Vehicle',
        'Repair',
        'Blips',
        'Menu',
        'Markers',
    }, function(error)  
        if #error > 0 then return; end
        RetrieveComponents()
    end)
end)


Citizen.CreateThread(function()
    DecorRegister('VEH_IGNITION', 2)
    DecorRegister('VEH_LOCKS', 2)
    DecorRegister('VEH_HOTWIRED', 2)
    DecorRegister('VEH_SEARCHED', 2)
    while true do
        GLOBAL_PED = PlayerPedId()

        if IsPedInAnyVehicle(GLOBAL_PED, true) or GetVehiclePedIsTryingToEnter(GLOBAL_PED) ~= 0 then
            GLOBAL_VEH = GetVehiclePedIsIn(GLOBAL_PED) or GetVehiclePedIsTryingToEnter(GLOBAL_PED)
        else
            if _actionShowing then
                UI.Action:Hide()
                _actionShowing = false
            end
            GLOBAL_VEH = nil
        end
        Citizen.Wait(100)
    end
end)

RegisterNetEvent('Vehicle:Client:SyncKeys')
AddEventHandler('Vehicle:Client:SyncKeys', function(keys)
    _keys = keys
end)

VEHICLE = {
    _required = { 'Engine', 'Keys', 'Locks', 'Hotwire', 'Search' },
    Engine = {
        Force = function(self, veh, state)
            if not DecorExistOn(veh, 'VEH_IGNITION') then
                DecorSetBool(veh, 'VEH_IGNITION', state)
            end

            if state then
                TriggerEvent('Vehicle:Client:Ignition', true)
                DecorSetBool(veh, 'VEH_IGNITION', true)
                SetVehicleEngineOn(veh, true, false, true)
                SetVehicleUndriveable(veh, false)
            else
                TriggerEvent('Vehicle:Client:Ignition', false)
                DecorSetBool(veh, 'VEH_IGNITION', false)
                SetVehicleEngineOn(veh, false, true, true)
                SetVehicleUndriveable(veh, true)
                if _keys[GetVehicleNumberPlateText(veh)] then
                    UI.Action:Show('{key}F9{/key} To Turn Engine On')
                    _actionShowing = true
                end
            end
        end,
        Off = function(self, veh)
            local plate = GetVehicleNumberPlateText(veh)
            if (DecorExistOn(veh, 'VEH_HOTWIRED') and DecorGetBool(veh, 'VEH_HOTWIRED')) then
                Notification:SendError('This Vehicle\'s Ignition Is Damaged')
                return
            elseif not _keys[plate] then 
                Notification:SendError('You Don\'t Have Keys For This Vehicle')
                return
            end

            DecorSetBool(veh, 'VEH_IGNITION', false)

            SetVehicleEngineOn(veh, false, true, true)
            SetVehicleUndriveable(veh, true)
            Notification:SendAlert('Engine Turned Off', 1500)

            TriggerEvent('Vehicle:Client:Ignition', false)

            if not _actionShowing then
                UI.Action:Show('{key}F9{/key} To Turn Engine On')
                _actionShowing = true
            end
        end,
        On = function(self, veh)
            local plate = GetVehicleNumberPlateText(veh)
            if not _keys[plate] and not (DecorExistOn(veh, 'VEH_HOTWIRED') and DecorGetBool(veh, 'VEH_HOTWIRED')) then 
                Notification:SendError('You Don\'t Have Keys For This Vehicle')
                return
            end

            DecorSetBool(veh, 'VEH_IGNITION', true)

            SetVehicleEngineOn(veh, true, false, true)
            SetVehicleUndriveable(veh, false)
            Notification:SendAlert('Engine Turned On', 1500)
            TriggerEvent('Vehicle:Client:Ignition', true)
            if _actionShowing then
                UI.Action:Hide()
                _actionShowing = false
            end
        end,
        Toggle = function(self, veh)
            local plate = GetVehicleNumberPlateText(veh)
            if not _keys[plate] and not (DecorExistOn(veh, 'VEH_HOTWIRED') and DecorGetBool(veh, 'VEH_HOTWIRED')) then 
                Notification:SendError('You Don\'t Have Keys For This Vehicle')
                return
            end

            if DecorGetBool(veh, 'VEH_IGNITION') then
                Vehicle.Engine:Off(veh)
            else
                Vehicle.Engine:On(veh)
            end
        end,
    },
    Keys = {
        GetKeys = function(self, plate, hideNotif)
            Callbacks:ServerCallback('Vehicle:AddKey', plate, function()
                if not hideNotif then
                    Notification:SendAlert('You Recieved Keys To A Vehicle')
                end

                _keys[plate] = true
            end)
        end,
        TakeKeys = function(self, plate, hideNotif)
            Callbacks:ServerCallback('Vehicle:RemoveKey', plate, function()
                if not hideNotif then
                    Notification:SendAlert('Keys To A Vehicle Were Taken')
                end

                _keys[plate] = nil
            end)
        end,
    },
    Locks = {
        Lock = function(self, veh)
            local plate = GetVehicleNumberPlateText(veh)
            if not _keys[plate] then return end
            DecorSetBool(veh, 'VEH_LOCKS', true)

            Notification:SendAlert('Vehicle Locked', 1500)
            if not IsPedInAnyVehicle(GLOBAL_PED, true) or GetVehiclePedIsTryingToEnter(GLOBAL_PED) ~= veh then
                Citizen.CreateThread(function()
                    TaskPlayAnim(GLOBAL_PED, 'anim@mp_player_intmenu@key_fob@', 'fob_click', 2.0, 2.5, -1, 48, 0, 0, 0, 0 )
                    Citizen.Wait(500)

                    StartVehicleHorn(veh, 100, `HELDDOWN`, false)
                    SetVehicleLights(veh, 2)
                    Citizen.Wait(500)
                    SetVehicleLights(veh, 0)
                end)
            end
        end,
        Unlock = function(self, veh)
            local plate = GetVehicleNumberPlateText(veh)
            if not _keys[plate] then return end
            DecorSetBool(veh, 'VEH_LOCKS', false)

            SetVehicleDoorsLocked(veh, 1)
            Notification:SendAlert('Vehicle Unlocked', 1500)

            if not IsPedInAnyVehicle(GLOBAL_PED, true) or GetVehiclePedIsTryingToEnter(GLOBAL_PED) ~= veh then
                Citizen.CreateThread(function()
                    TaskPlayAnim(GLOBAL_PED, 'anim@mp_player_intmenu@key_fob@', 'fob_click', 2.0, 2.5, -1, 48, 0, 0, 0, 0 )
                    Citizen.Wait(500)

                    Citizen.CreateThread(function()
                        StartVehicleHorn(veh, 100, `HELDDOWN`, false)
                        Citizen.Wait(500)
                        StartVehicleHorn(veh, 100, `HELDDOWN`, false)
                    end)

                    SetVehicleLights(veh, 2)
                    Citizen.Wait(250)
                    SetVehicleLights(veh, 0)
                    Citizen.Wait(250)
                    SetVehicleLights(veh, 2)
                    Citizen.Wait(250)
                    SetVehicleLights(veh, 0)
                end)
            end
        end,
        Toggle = function(self, veh)
            local plate = GetVehicleNumberPlateText(veh)
            if not _keys[plate] then return end
            if DecorGetBool(veh, 'VEH_LOCKS') then
                Vehicle.Locks:Unlock(veh)
            else
                Vehicle.Locks:Lock(veh)
            end
        end,
    },
    Hotwire = function(self, veh, success, stages, alarm)
        local val = GetVehicleHandlingInt(veh, 'CHandlingData', 'nMonetaryValue')

        if _actionShowing then
            UI.Action:Hide()
            _actionShowing = false
        end
    
        if val ~= nil and val > 5000 then
            local wasCancelled = false
            for i = 1, stages, 1 do
    
                local alarmRoll = math.random(100)
                if alarmRoll <= alarm then
                    SetVehicleAlarm(veh, true)
                    SetVehicleAlarmTimeLeft(veh, val)
                    StartVehicleAlarm(veh)
                end
    
                local stageComplete = false
                if wasCancelled then
                    canAttemptHotwire = true
                    Notification:SendError('Hotwire Cancelled')
                    return
                end
            
                Progress:Progress({
                    name = "lockpick_action",
                    duration = (val / ((stages + 1) - i)),
                    label = "Hot Wiring - Stage " .. i,
                    useWhileDead = false,
                    canCancel = true,
                    vehicle = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                    animation = {
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        anim = "machinic_loop_mechandplayer",
                        flags = 49,
                    },
                }, function(status)
                    wasCancelled = status
                    stageComplete = true
                end)
    
                while not stageComplete do
                    Citizen.Wait(1)
                end
            end
            
            if not wasCancelled then
                local successRoll = math.random(100)
                DecorSetBool(veh, 'VEH_HOTWIRED', successRoll <= success)
                if successRoll <= success then
                    --Vehicle.Keys:GetKeys(GetVehicleNumberPlateText(veh), true)
                    Vehicle.Engine:Force(veh, true)
                    canAttemptHotwire = false
                    canSearchForKey = false
                    SetVehicleAlarm(veh, false)
                    Notification:SendAlert('Vehicle Hotwired')
                else
                    canAttemptHotwire = false
                    Vehicle.Engine:Force(veh, false)
                    Notification:SendError('Hotwire Failed')
                end
            end
        else
            Notification:SendError('Cannot Hotwire This Vehicle')
        end
    end,
    Search = function(self, veh, success, alarm)
        local val = GetVehicleHandlingInt(veh, 'CHandlingData', 'nMonetaryValue')
    
        if _actionShowing then
            UI.Action:Hide()
            _actionShowing = false
        end
    
        if val ~= nil then
            local wasCancelled = false
            for i = 1, 2, 1 do
                local alarmRoll = math.random(100)
                if alarmRoll <= alarm then
                    SetVehicleAlarm(veh, true)
                    SetVehicleAlarmTimeLeft(veh, val)
                    StartVehicleAlarm(veh)
                end
    
                local stageComplete = false
                if wasCancelled then
                    canSearchForKey = true
                    Notification:SendError('Search Cancelled')
                    return
                end
            
                Progress:Progress({
                    name = "search_action",
                    duration = (val / 2),
                    label = 'Searching For Key',
                    useWhileDead = false,
                    canCancel = true,
                    vehicle = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = true,
                        disableCombat = true,
                    },
                    animation = {
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        anim = "machinic_loop_mechandplayer",
                        flags = 49,
                    },
                }, function(status)
                    wasCancelled = status
                    stageComplete = true
                end)
    
                while not stageComplete do
                    Citizen.Wait(1)
                end
            end
            
            if not wasCancelled then
                local successRoll = math.random(100)
                DecorSetBool(veh, 'VEH_SEARCHED', successRoll <= success)
                if successRoll <= success then
                    Vehicle.Keys:GetKeys(GetVehicleNumberPlateText(veh), true)
                    Vehicle.Engine:Force(veh, true)
                    canAttemptHotwire = false
                    canSearchForKey = false
                    SetVehicleAlarm(veh, false)
                    Notification:SendAlert('You Found A Key!')
                else
                    canSearchForKey = false
                    Vehicle.Engine:Force(veh, false)
                    Notification:SendError('You Found Nothing')
                end
            end
        else
            Notification:SendError('Nothing To Search')
        end
    end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Vehicle', VEHICLE)
end)

RegisterNetEvent('Events:Client:EnteringVehicle')
AddEventHandler('Events:Client:EnteringVehicle', function(veh, seat)
    SetEntityAsMissionEntity(veh, true, true)
    if seat == -1 then
        while IsVehicleNeedsToBeHotwired(veh) do
            Citizen.Wait(0)
            local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
            SetVehicleNeedsToBeHotwired(veh, false)
        end

        if not DecorExistOn(veh, 'VEH_IGNITION') then
            Vehicle.Engine:Force(veh, GetIsVehicleEngineRunning(veh))
        end
    end
end)

RegisterNetEvent('Events:Client:EnteredVehicle')
AddEventHandler('Events:Client:EnteredVehicle', function(veh, seat)
    if seat == -1 then
        local ped =  GetPedInVehicleSeat(veh, -1)
        local plate = GetVehicleNumberPlateText(veh)
        local running = GetIsVehicleEngineRunning(veh)
        if ped ~= 0 then
            if IsEntityDead(ped) and running then
                Citizen.Wait(3500)
                Vehicle.Keys:GetKeys(plate, true)
                Vehicle.Engine:Force(veh, true)
            elseif running then -- Should make some dispatch alert as they're stealing the car from a not-dead person
                Citizen.Wait(3500)
                Vehicle.Keys:GetKeys(plate, true)
                Vehicle.Engine:Force(veh, true)
            else
                Vehicle.Engine:Force(veh, false)
                StartHotwireThread(veh)
            end
        else
            if _keys[plate] then
                if DecorExistOn(veh, 'VEH_IGNITION') then
                    Vehicle.Engine:Force(veh, DecorGetBool(veh, 'VEH_IGNITION'))
                else
                    Vehicle.Engine:Force(veh, true)
                end
            else
                if GetIsVehicleEngineRunning(veh) then
                    Vehicle.Keys:GetKeys(plate)
                    Vehicle.Engine:Force(veh, true)
                else
                    Vehicle.Engine:Force(veh, false)
                    StartHotwireThread(veh)
                end
            end
        end
    end
end)

function StartHotwireThread(veh)
    if DecorExistOn(veh, 'VEH_HOTWIRED') then
        canAttemptHotwire = false
    else
        canAttemptHotwire = true
    end

    if DecorExistOn(veh, 'VEH_SEARCHED') then
        canSearchForKey = false
    else
        canSearchForKey = true
    end
    
    Citizen.CreateThread(function()
        local plate = GetVehicleNumberPlateText(veh)
        while (canAttemptHotwire or canSearchForKey) and (IsPedInAnyVehicle(GLOBAL_PED, true) or GetVehiclePedIsTryingToEnter(GLOBAL_PED) ~= 0) and not _keys[plate] do
            if not _keys[plate] then
                if not _actionShowing then
                    _actionShowing = true
                    if canAttemptHotwire and canSearchForKey then
                        UI.Action:Show('{key}Z{/key} Hotwire | {key}G{/key} Search For Key')
                    elseif canAttemptHotwire and not canSearchForKey then
                        UI.Action:Show('{key}Z{/key} Hotwire')
                    else
                        UI.Action:Show('{key}G{/key} Search For Key')
                    end
                end

                if IsControlJustReleased(0, 20) and canAttemptHotwire then
                    Vehicle:Hotwire(veh, 65, 4, 45)
                elseif IsControlJustReleased(0, 58) and canSearchForKey then
                    Vehicle:Search(veh, 100, 100)
                end
            end
            Citizen.Wait(5)
        end
    end)
end

function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(100)
	end
end

Citizen.CreateThread(function()
    loadAnimDict( "anim@mp_player_intmenu@key_fob@" )
    while true do
        if IsControlJustReleased(0, 56) and not _delay and GLOBAL_VEH ~= nil and (GetPedInVehicleSeat(GLOBAL_VEH, -1) == GLOBAL_PED) then
            _delay = true

            Citizen.CreateThread(function()
                Citizen.Wait(1500)
                _delay = false
            end)

            Vehicle.Engine:Toggle(GLOBAL_VEH)
        elseif IsControlJustReleased(1, 303) and not _lockdelay then
            local veh = GLOBAL_VEH or GetClosestVehicle(GetEntityCoords(GLOBAL_PED), 10.0, 0, 71)

            if veh ~= 0 then
                _lockdelay = true
    
                Citizen.CreateThread(function()
                    Citizen.Wait(1500)
                    _lockdelay = false
                end)
    
                Vehicle.Locks:Toggle(veh)
            end
        end

        Citizen.Wait(5)
    end
end)