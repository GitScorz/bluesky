AddEventHandler('Commands:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Chat = exports['bs_base']:FetchComponent('Chat')
    WebAPI = exports['bs_base']:FetchComponent('WebAPI')
    Config = exports['bs_base']:FetchComponent('Config')
    RegisterChatCommands()
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Commands', {
        'Chat',
        'Callbacks',
        'WebAPI',
        'Config',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        RegisterCallbacks()
    end)
end)

function RegisterChatCommands()
    Chat:RegisterAdminCommand('panic', function(source, args, rawCommand)
        local char = exports['bs_base']:FetchComponent('Fetch'):Source(source):GetData('Character'):GetData()
        char._id = char.ID
        char.Server = Config.Server.ID
        WebAPI.MDT:Request('POST', 'alerts/panic', {}, {
            character = char
        })
        TriggerEvent('Sounds:Server:Play:Distance', source, 15, 'panic', 1.0);
        TriggerEvent('Sounds:Server:Play:Job', source, 'panic', {
            police = true,
            ems = true,
        }, 100);
    end, {
        help = 'Test Panic'
    })

    Chat:RegisterAdminCommand('clearpanic', function(source, args, rawCommand)
        local char = exports['bs_base']:FetchComponent('Fetch'):Source(source):GetData('Character'):GetData()
        char._id = char.ID
        char.Server = Config.Server.ID
        WebAPI.MDT:Request('POST', 'alerts/clearPanic', {}, {
            character = char
        })
    end, {
        help = 'Test Panic'
    })

    Chat:RegisterCommand('clear', function(source, args, rawCommand)
        TriggerClientEvent('chat:clearChat', source)
    end, {
        help = 'Clear The Chat'
    })
    
    Chat:RegisterCommand('ooc', function(source, args, rawCommand)
        if #rawCommand:sub(4) > 0 then
            Chat.Send:OOC(source, rawCommand:sub(4))
        end
    end, {
        help = 'Out of Character Chat, THIS IS NOT A SUPPORT CHAT',
        params = {{
                name = 'Message',
                help = 'The Message You Want To Send To The OOC Channel'
            }
        }
    }, -1)
    
    --[[ ADMIN-RESTRICTED COMMANDS ]]--
    Chat:RegisterAdminCommand('server', function(source, args, rawCommand)
        Chat.Send.Server:All(rawCommand:sub(8))
    end, {
        help = 'Send Server Message To All Players',
        params = {{
                name = 'Message',
                help = 'The Message You Want To Send To Server Channel'
            }
        }
    }, -1)
    
    Chat:RegisterAdminCommand('system', function(source, args, rawCommand)
        Chat.Send.System:All(rawCommand:sub(8))
    end, {
        help = 'Send System Message To All Players',
        params = {{
                name = 'Message',
                help = 'The Message You Want To Send To System Channel'
            }
        }
    }, -1)
    
    Chat:RegisterAdminCommand('kick', function(source, args, rawCommand)
        exports['bs_base']:FetchComponent('Punishment'):Kick(tonumber(args[1]), args[2], source)
    end, {
        help = 'Kick Player From Server',
        params = {{
                name = 'Target',
                help = 'Server ID of Who You Want To Kick'
            }, {
                name = 'Reason',
                help = 'Reason For The Kick'
            }
        }
    }, 2)
    
    Chat:RegisterAdminCommand('unban', function(source, args, rawCommand)
        exports['bs_base']:FetchComponent('Punishment').Unban:BanID(args[1], source)
    end, {
        help = 'Unban Player',
        params = {{
                name = 'Ban ID',
                help = 'Unique Ban ID You\'re Disabling'
            }
        }
    }, 1)
    
    Chat:RegisterAdminCommand('unbanid', function(source, args, rawCommand)
        local type = args[1]

        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        if type == 'sid' then
            exports['bs_base']:FetchComponent('Punishment').Unban:SID(tonumber(args[2]), source)
        elseif type == 'identifier' then
            exports['bs_base']:FetchComponent('Punishment').Unban:Identifier(args[2], source)
        elseif type == 'account' then
            exports['bs_base']:FetchComponent('Punishment').Unban:Account(args[2], source)
        end
    end, {
        help = 'Unban Site ID',
        params = {
            {
                name = 'ID Type',
                help = 'Valid Types: sid, identifier, account'
            }, {
                name = 'Target',
                help = 'ID of Who You Want To Unban'
            }
        }
    }, 2)
    
    Chat:RegisterAdminCommand('ban', function(source, args, rawCommand)
        if source == tonumber(args[1]) then
            Chat.Send.System:Single(source, 'Cannot Ban Yourself')
        else
            exports['bs_base']:FetchComponent('Punishment').Ban:Source(tonumber(args[1]), tonumber(args[2]), args[3], source)
        end
    end, {
        help = 'Ban Player From Server',
        params = {{
                name = 'Target',
                help = 'Server ID of Who You Want To Ban'
            }, {
                name = 'Days',
                help = '# of Days To Ban, -1 For Permanent Ban'
            },
            {
                name = 'Reason',
                help = 'Reason For The Ban'
            }
        }
    }, 3)
    
    Chat:RegisterAdminCommand('banid', function(source, args, rawCommand)
        local type = args[1]

        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        if type == 'sid' then
            if player:GetData('SID') == tonumber(args[2]) then
                Chat.Send.System:Single(source, 'Cannot Ban Yourself')
            else
                exports['bs_base']:FetchComponent('Punishment').Ban:SID(tonumber(args[2]), tonumber(args[3]), args[4], source)
            end
        elseif type == 'identifier' then
            if player:GetData('Identifier') == args[2] then
                Chat.Send.System:Single(source, 'Cannot Ban Yourself')
            else
                exports['bs_base']:FetchComponent('Punishment').Ban:Identifier(args[2], tonumber(args[3]), args[4], source)
            end
        elseif type == 'account' then
            if player:GetData('ID') == args[2] then
                Chat.Send.System:Single(source, 'Cannot Ban Yourself')
            else
                exports['bs_base']:FetchComponent('Punishment').Ban:User(args[2], tonumber(args[3]), args[4], source)
            end
        end
    end, {
        help = 'Ban Player From Server',
        params = {{
                name = 'ID Type',
                help = 'Valid Types: sid, identifier, account'
            }, {
                name = 'Target',
                help = 'Server ID of Who You Want To Ban'
            }, {
                name = 'Days',
                help = '# of Days To Ban, -1 For Permanent Ban'
            },
            {
                name = 'Reason',
                help = 'Reason For The Ban'
            }
        }
    }, 4)

    Chat:RegisterAdminCommand('sv', function(source, args, rawCommand)
        TriggerClientEvent('Commands:Client:SpawnVehicle', source, args[1])
    end, {
        help = 'Spawn Vehicle With Given Model',
        params = {{
                name = 'Model Name',
                help = 'Name of the model you want to spawn'
            }
        }
    }, 1)


    Chat:RegisterAdminCommand('dv', function(source, args, rawCommand)
        TriggerClientEvent('Commands:Client:RemoveVehicle', source)
    end, {
        help = 'Deletes a Vehicle',
    }, 0)

end