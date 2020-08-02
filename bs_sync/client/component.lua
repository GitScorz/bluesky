_current = 'EXTRASUNNY'
local _weatherState = _current
local _timeState = 0
local _timeOffset = 0
local _timer = 0
local _freezeState = false
local _blackoutState = false
local isTransionHappening = false

local _running = false

AddEventHandler('Sync:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Logger = exports['bs_base']:FetchComponent('Logger')
    Sync = exports['bs_base']:FetchComponent('Sync')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Sync', {
        'Callbacks',
        'Logger',
        'Sync',
    }, function(error)  
        if #error > 0 then return; end
        RetrieveComponents()
    end)
end)

AddEventHandler('Characters:Client:Spawn', function()
    Sync:Start()
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    Sync:Stop()
end)

SYNC = {
    Start = function(self)
        if _running then return end
        Callbacks:ServerCallback('Sync:GetState', {}, function(weather, blackout, base, offset, freeze)
            _running = true
            _current = weather
            _blackoutState = blackout
            _timeState = base
            _timeOffset = offset
            _freezeState = freeze
            SetRainFxIntensity(-1.0)

            Logger:Trace('Sync', 'Starting Sync')
            StartSyncThreads()
        end)
    end,
    Stop = function(self)
        if not _running then return end
        Logger:Trace('Sync', 'Stopping Sync')
        _running = false
        Citizen.CreateThread(function() 
            while not _running do
                SetRainFxIntensity(0.0)
                SetWeatherTypePersist('EXTRASUNNY')
                SetWeatherTypeNow('EXTRASUNNY')
                SetWeatherTypeNowPersist('EXTRASUNNY')
                NetworkOverrideClockTime(23, 0, 0)
                Citizen.Wait(5000)
            end
        end)
    end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Sync', SYNC)
end)

RegisterNetEvent('Sync:Client:Weather')
AddEventHandler('Sync:Client:Weather', function(weather, override)
    _current = weather
end)

RegisterNetEvent('Sync:Client:Time')
AddEventHandler('Sync:Client:Time', function(base, offset)
    _timeState = base
    _timeOffset = offset

    if _running then
        hour = math.floor(((_timeState+_timeOffset)/60)%24)
        minute = math.floor((_timeState+_timeOffset)%60)
        NetworkOverrideClockTime(hour, minute, 0)
    end
end)

RegisterNetEvent('Sync:Client:Freeze')
AddEventHandler('Sync:Client:Freeze', function(freeze)
    _freezeState = freeze
end)

RegisterNetEvent('Sync:Client:Blackout')
AddEventHandler('Sync:Client:Blackout', function(blackout)
    _blackoutState = blackout
    
    if _running then
        SetBlackout(_blackoutState)
    end
end)

function StartSyncThreads()


    Citizen.CreateThread(function()
        local hour = 0
        local minute = 0
        while _running do
            local newBaseTime = _timeState
            if GetGameTimer() - 500  > _timer then
                newBaseTime = newBaseTime + 0.25
                _timer = GetGameTimer()
            end
            if _freezeState then
                _timeOffset = _timeOffset + _timeState - newBaseTime			
            end
            _timeState = newBaseTime
            hour = math.floor(((_timeState+_timeOffset)/60)%24)
            minute = math.floor((_timeState+_timeOffset)%60)
            NetworkOverrideClockTime(hour, minute, 0)
            Citizen.Wait(2000)
        end
    end)
    
    Citizen.CreateThread(function()
        while _running do
            if _weatherState ~= _current then
                if not isTransionHappening then
                    isTransionHappening = true
                    _weatherState = _current
                    ClearOverrideWeather()
                    ClearWeatherTypePersist()
                    SetWeatherTypeOvertimePersist(_weatherState, 12.0)
                    Citizen.Wait(12000)
                    isTransionHappening = false
                end
            end
            Citizen.Wait(100) -- Wait 0 seconds to prevent crashing.
            SetBlackout(_blackoutState)
            SetWeatherTypePersist(_weatherState)
            SetWeatherTypeNow(_weatherState)
            SetWeatherTypeNowPersist(_weatherState)
            if _weatherState == 'XMAS' then
                SetForceVehicleTrails(true)
                SetForcePedFootstepsTracks(true)
            else
                SetForceVehicleTrails(false)
                SetForcePedFootstepsTracks(false)
            end
        end
    end)
end
