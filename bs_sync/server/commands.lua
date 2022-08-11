function RegisterChatCommands()
    Chat:RegisterAdminCommand('freeze', function(source, args, rawCommand)
        if args[1]:lower() == 'weather' or args[1]:lower() == 'time' then
            Sync.Set:Freeze(args[1])
        else
            Chat.Send.Server:Single(source, 'Invalid Argument')
        end
    end, {
        help = 'Freeze Weather or Time',
        params = { {
            name = 'Type',
            help = 'Weather or Time'
        }
        }
    }, 1)

    Chat:RegisterAdminCommand('weather', function(source, args, rawCommand)
        for _, v in pairs(AvailableWeatherTypes) do
            if args[1]:upper() == v then
                Sync.Set:Weather(args[1])
                return
            end
        end
        Chat.Send.Server:Single(source, 'Invalid Argument')
    end, {
        help = 'Set Weather',
        params = { {
            name = 'Type',
            help = 'EXTRASUNNY, CLEAR, NEUTRAL, SMOG, FOGGY, OVERCAST, CLOUDS, CLEARING, RAIN, THUNDER, SNOW, BLIZZARD, SNOWLIGHT, XMAS, HALLOWEEN'
        }
        }
    }, 1)

    Chat:RegisterAdminCommand('time', function(source, args, rawCommand)
        for _, v in pairs(AvailableTimeTypes) do
            if args[1]:upper() == v then
                Sync.Set:Time(args[1])
                return
            end
        end
        Chat.Send.Server:Single(source, 'Invalid Argument')
    end, {
        help = 'Set Time',
        params = { {
            name = 'Type',
            help = 'MORNING, NOON, EVENING, NIGHT'
        }
        }
    }, 1)

    Chat:RegisterAdminCommand('clock', function(source, args, rawCommand)
        if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
            Sync.Set:ExactTime(args[1], args[2])
        else
            Chat.Send.Server:Single(source, 'Invalid Argument')
        end
    end, {
        help = 'Set Time To An Exact Hour & Minute',
        params = { {
            name = 'Hour',
            help = 'Number Between 0 - 23'
        },
            {
                name = 'Minute',
                help = 'Number Between 0 - 59'
            }
        }
    }, 2)

    Chat:RegisterAdminCommand('blackout', function(source, args, rawCommand)
        Sync:ToggleBlackout()
    end, {
        help = 'Toggle Blackout'
    }, 0)
end
