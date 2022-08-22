function RegisterChatCommands()

    Chat:RegisterAdminCommand('setjob', function(source, args, rawCommand)
        local target = tonumber(args[1])
        if target ~= nil then
            Jobs.Player:SetJob(target, args[2], args[3], tonumber(args[4]), function(success, alreadyJob)
                if success then
                    if source ~= target then
                        Chat.Send.System:Single(source,
                            'Successfully Set Server ID: ' ..
                            target ..
                            'To ' ..
                            success.label ..
                            '. (' ..
                            (success.workplace.workplace ~= 0 and (' Workplace: ' .. success.workplace.label) or ' ') ..
                            ', Grade: ' .. success.grade.label .. ')')
                    end
                else
                    Chat.Send.System:Single(source, (alreadyJob and 'Player Already Has That Job' or 'Error Setting Job'
                        ))
                end
            end)
        end
    end, {
        help = 'Set Player Job',
        params = {
            { name = 'ID', help = 'Server ID' },
            { name = 'Job', help = 'Job (e.g. realestate)' },
            { name = 'Grade', help = 'Grade (e.g. employee)' },
            { name = 'Workplace', help = 'Workplace (e.g 1)' },
        }
    }, 4)

    Chat:RegisterAdminCommand('removejob', function(source, args, rawCommand)
        local target = tonumber(args[1])
        if target ~= nil then
            Jobs.Player:RevokeJob(target)
        end
    end, {
        help = 'Remove A Job From Someone',
        params = { {
            name = 'ID',
            help = 'Server ID'
        } }
    }, 1)

    Chat:RegisterAdminCommand('toggleduty', function(source, args, rawCommand)
        Jobs.Player:ToggleAutoDefineDuty(source)
    end, {
        help = 'Toggle Duty'
    })

    Chat:RegisterCommand('job', function(source, args, rawCommand)
        local char = Fetch:Source(source):GetData('Character')
        local jobData = char:GetData('Job')
        local onDuty = char:GetData('JobDuty')
        TriggerClientEvent('Jobs:Client:ViewJobInformation', source, jobData, onDuty)
    end, {
        help = 'Show Information Regarding Your Job'
    })

    Chat:RegisterCommand('callsign', function(source, args, rawCommand)
        local _src = source
        local char = Fetch:Source(_src):GetData('Character')
        local job = char:GetData('Job').job
        if (job == "police" or job == "fire" or job == "ems" or job == "corrections") and char:GetData('JobDuty') then
            Jobs.Player.Callsigns:SetCallSign(_src, tonumber(args[1]))
        end
    end, {
        help = 'Set your Job Callsign',
        params = {
            {
                name = 'Number',
                help = 'Call Sign Number'
            },
        }
    }, 1,
        { { name = "police", gradelevel = 0 }, { name = "ems", gradelevel = 0 }, { name = "corrections", gradelevel = 0 },
            { name = "fire", gradelevel = 0 } })
end
