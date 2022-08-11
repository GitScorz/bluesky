AvailableWeatherTypes = {
    'EXTRASUNNY',
    'CLEAR',
    'NEUTRAL',
    'SMOG',
    'FOGGY',
    'OVERCAST',
    'CLOUDS',
    'CLEARING',
    'RAIN',
    'THUNDER',
    'SNOW',
    'BLIZZARD',
    'SNOWLIGHT',
    'XMAS',
    'HALLOWEEN',
}

AvailableTimeTypes = {
    'MORNING',
    'NOON',
    'EVENING',
    'NIGHT',
}

local _weather = "EXTRASUNNY"
local _isDynamic = true
local _time = 0
local _timeOffset = 0
local _freezeState = false
local _blackoutState = false

AddEventHandler('Sync:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Logger = exports['bs_base']:FetchComponent('Logger')
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Chat = exports['bs_base']:FetchComponent('Chat')
    Sync = exports['bs_base']:FetchComponent('Sync')
    RegisterChatCommands()
    StartThreads()
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Sync', {
        'Callbacks',
        'Fetch',
        'Utils',
        'Chat',
        'Status',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        RegisterCallbacks()
    end)
end)

function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Sync:GetState', function(source, data, cb)
        cb(_weather, _blackoutState, _time, _timeOffset, _freezeState)
    end)
end

local started = false
function StartThreads()
    if started then return end
    Logger:Trace("Sync", "Started Time and Weather Sync Threads", { console = true })
    started = true

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            TriggerClientEvent('Sync:Client:Time', -1, _time, _timeOffset)
        end
    end)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(8000)
            TriggerClientEvent('Sync:Client:Weather', -1, _weather)
        end
    end)

    Citizen.CreateThread(function()
        while Sync == nil do
            Citizen.Wait(10)
        end

        Sync:NextWeatherStage()

        while true do
            Citizen.Wait(1800000)
            if _isDynamic then
                Sync:NextWeatherStage()
            end
        end
    end)
end

SYNC = {
    Set = {
        Freeze = function(self, element)
            if element == 'weather' then
                _isDynamic = not _isDynamic
                if not _isDynamic then
                    Chat.Send.System:All('Dynamic weather changes are now disabled')
                else
                    Chat.Send.System:All('Dynamic weather changes are now enabled')
                end
            else
                _freezeState = not _freezeState
                if _freezeState then
                    Chat.Send.System:All('Time is now frozen')
                else
                    Chat.Send.System:All('Time is no longer frozen')
                end
            end
        end,
        Blackout = function(self)
            _blackoutState = not _blackoutState
            if _blackoutState then
                Chat.Send.System:All('Blackout Is Now Enabled')
            else
                Chat.Send.System:All('Blackout Is Now Disabled')
            end
            TriggerClientEvent('Sync:Client:Blackout', -1, _blackoutState)
        end,
        Weather = function(self, type)
            _weather = string.upper(type)
            Chat.Send.System:All('Weather set to ' .. type)
            TriggerClientEvent('Sync:Client:Weather', -1, _weather)
        end,
        Time = function(self, type)
            if type:upper() == AvailableTimeTypes[1] then
                ShiftToMinute(0)
                ShiftToHour(9)
                Chat.Send.System:All('Time is now morning')
            elseif type:upper() == AvailableTimeTypes[2] then
                ShiftToMinute(0)
                ShiftToHour(12)
                Chat.Send.System:All('Time is now noon')
            elseif type:upper() == AvailableTimeTypes[3] then
                ShiftToMinute(0)
                ShiftToHour(18)
                Chat.Send.System:All('Time is now evening')
            else
                ShiftToMinute(0)
                ShiftToHour(23)
                Chat.Send.System:All('Time is now night')
            end

            TriggerClientEvent('Sync:Client:Time', -1, _time, _timeOffset)
        end,
        ExactTime = function(self, hour, minute)
            local argh = tonumber(hour)
            local argm = tonumber(minute)
            if argh < 24 then
                ShiftToHour(argh)
            else
                ShiftToHour(0)
            end
            if argm < 60 then
                ShiftToMinute(argm)
            else
                ShiftToMinute(0)
            end
            local newtime = math.floor(((_time + _timeOffset) / 60) % 24) .. ":"
            local minute = math.floor((_time + _timeOffset) % 60)
            if minute < 10 then
                newtime = newtime .. "0" .. minute
            else
                newtime = newtime .. minute
            end

            Chat.Send.System:All('Time was changed to: ' .. newtime)
            TriggerClientEvent('Sync:Client:Time', -1, _time, _timeOffset)
        end,
    },
    NextWeatherStage = function(self)
        if _weather == "CLEAR" or _weather == "CLOUDS" or _weather == "EXTRASUNNY" then
            local newWeather = math.random(1, 2)
            if newWeather == 1 then
                _weather = "CLEARING"
            else
                _weather = "OVERCAST"
            end
        elseif _weather == "CLEARING" or _weather == "OVERCAST" then
            local newWeather = math.random(1, 6)
            if newWeather == 1 then
                if _weather == "CLEARING" then _weather = "FOGGY" else _weather = "RAIN" end
            elseif newWeather == 2 then
                _weather = "CLOUDS"
            elseif newWeather == 3 then
                _weather = "CLEAR"
            elseif newWeather == 4 then
                _weather = "EXTRASUNNY"
            elseif newWeather == 5 then
                _weather = "SMOG"
            else
                _weather = "FOGGY"
            end
        elseif _weather == "THUNDER" or _weather == "RAIN" then
            _weather = "CLEARING"
        elseif _weather == "SMOG" or _weather == "FOGGY" then
            _weather = "CLEAR"
        end

        Logger:Info('Sync', 'Weather Updated: ^5' .. _weather .. '^7', { console = true })
        TriggerClientEvent('Sync:Client:Weather', -1, _weather, false)
    end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function(component)
    exports['bs_base']:RegisterComponent('Sync', SYNC)
end)

function ShiftToMinute(minute)
    _timeOffset = _timeOffset - (((_time + _timeOffset) % 60) - minute)
end

function ShiftToHour(hour)
    _timeOffset = _timeOffset - ((((_time + _timeOffset) / 60) % 24) - hour) * 60
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local newBaseTime = os.time(os.date("!*t")) / 2 + 360
        if _freezeState then
            _timeOffset = _timeOffset + _time - newBaseTime
        end
        _time = newBaseTime
    end
end)
