local DISCORD_NAME = 'Logger Bot'
local DISCORD_IMAGE = "https://imgur.com/oJAZQNt.png"
local logWebhook = GetConvar('discord_log_webhook', 'NOT SET')

local colors = {
    trace = 11908533,
    info = 3844857,
    success = 6750003,
    warning = 16776960,
    error = 16711680,
    critical = 16711782
}

local levelColors = {
    [1] = 'trace',
    [2] = 'info',
    [3] = 'warn',
    [4] = 'error',
    [5] = 'critical'
}

AddEventHandler('Logger:Log', function(component, log, flags, extra) COMPONENTS.Logger:Log(component, log, flags, extra) end)
AddEventHandler('Logger:Trace', function(component, log, flags, extra) COMPONENTS.Logger:Trace(component, log, flags, extra) end)
AddEventHandler('Logger:Info', function(component, log, flags, extra) COMPONENTS.Logger:Info(component, log, flags, extra) end)
AddEventHandler('Logger:Warn', function(component, log, flags, extra) COMPONENTS.Logger:Warn(component, log, flags, extra) end)
AddEventHandler('Logger:Error', function(component, log, flags, extra) COMPONENTS.Logger:Error(component, log, flags, extra) end)
AddEventHandler('Logger:Critical', function(component, log, flags, extra) COMPONENTS.Logger:Critical(component, log, flags, extra) end)
COMPONENTS.Logger = {
    _required = { 'Log' },
    _name = 'base',

    --- @param component string
    --- @param log string
    --- @param flags table
    Trace = function(self, component, log, flags, data)
        doLog(1, component, log, flags, data)
    end,

    --- @param component string
    --- @param log string
    --- @param flags table
    Info = function(self, component, log, flags, data)
        doLog(2, component, log, flags, data)
    end,

    --- @param component string
    --- @param log string
    --- @param flags table
    Warn = function(self, component, log, flags, data)
        doLog(3, component, log, flags, data)
    end,

    --- @param component string
    --- @param log string
    --- @param flags table
    Error = function(self, component, log, flags, data)
        doLog(4, component, log, flags, data)
    end,

    --- @param component string
    --- @param log string
    --- @param flags table
    Critical = function(self, component, log, flags, data)
        doLog(5, component, log, flags, data)
    end,

    --- @param component string
    --- @param log string
    --- @param flags table
    Log = function(self, component, log, flags, extra) -- Retained purely for legacy sake, stop using this
        doLog(0, component, log, flags, extra)
    end
}

function doLog(level, component, log, flags, data)
    Citizen.CreateThread(function()
        local prefix = '[LOG]'
        local mPrefix = '[LOG]'

        if level > 0 then
            if level == 1 then
                prefix = '[TRACE]'
                mPrefix = '[TRACE]'
            elseif level == 2 then
                prefix = '[^5INFO^7]'
                mPrefix = '[INFO]'
            elseif level == 3 then
                prefix = '[^3WARN^7]'
                mPrefix = '[WARN]'
            elseif level == 4 then
                prefix = '[^1ERROR^7]'
                mPrefix = '[ERROR]'
            elseif level == 5 then
                prefix = '[^9CRITICAL^7]'
                mPrefix = '[CRITICAL]'
            end
        end

        if flags == nil then flags = { console = true } end
        if flags.console and level >= COMPONENTS.Convar.LOGGING.value then
            local formattedLog = string.format('%s\t[^5%s^7] %s', prefix, component, log)
            print(formattedLog)
        end

        if flags.file then
            local currDate = os.date('%Y-%m-%d')
            local timestamp = os.date('%I:%M:%S %p')
            os.execute(('mkdir logs/Convar'):format(component))
            local logFile, errorReason = io.open(('logs/%s/%s.log'):format(component, currDate), 'a')
            if not logFile then
                return print(errorReason)
            end
            local formattedLog = string.format('%s  [%s]    %s', mPrefix, timestamp, log)
            logFile:write(formattedLog .. '\n')
            logFile:close()
        end

        if COMPONENTS.Proxy.DatabaseReady then
            if flags.database then
                COMPONENTS.Database.Auth:insertOne({
                    collection = "logs",
                    document = {
                        date = os.time(),
                        server = COMPONENTS.Config.Server.ID,
                        level = level,
                        component = component,
                        log = machineLog or log,
                        extra = extra
                    }
                })
            end
        end

        if flags.discord and level >= COMPONENTS.Convar.LOGGING.value then
            if logWebhook ~= 'NOT SET' then
                if type(flags.discord) == 'table' then
                    local hook = logWebhook
                    if flags.discord.webhook ~= nil then
                        hook = flags.discord.webhook
                    end

                    local data = {
                        embeds = {
                            {
                                ['color'] = colors[levelColors[level]] or colors[flags.discord.type],
                                ['description'] = log,
                                ['footer'] = {
                                    ['text'] = 'Component: ' .. component,
                                },
                            }
                        }
                    }

                    if flags.discord.content then
                        data.content = flags.discord.content
                    end
                    
                    PerformHttpRequest(hook, function(err, text, headers) end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
                else
                    PerformHttpRequest(logWebhook, function(err, text, headers) end, 'POST', json.encode({ content = ('%s [^5%s^7] %s'):format(mPrefix, component, log) }), { ['Content-Type'] = 'application/json' })
                end
            end
        end
    end)
end