function RegisterChatCommands()
    Chat:RegisterAdminCommand('heal', function(source, args, rawCommand)
        local admin = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(tonumber(args[1]))
        if player ~= nil then
            local char = player:GetData('Character')
            if char ~= nil then
                Damage:Heal(char)
                Logger:Warn('Damage', admin:GetData('Name') .. ' Used Admin Revive', { console = true })
                exports['bs_base']:FetchComponent('Execute'):Client(source, 'Notification', 'Success', 'Player Healed')
            else
                Chat.Send.System:Single(source, 'Player Not Logged In')
            end
        else
            Chat.Send.System:Single(source, 'Invalid Server ID')
        end
    end, {
        help = 'Heals Player',
        params = {{
                name = 'Target',
                help = 'Server ID of Who You Want To Heal'
            }
        }
    }, 1)

    Chat:RegisterAdminCommand('debugdamage', function(source, args, rawCommand)
        TriggerClientEvent('Damage:Client:Debug', source)
    end, {
        help = 'Enable Damage Debug'
    })
end

RegisterServerEvent('Damage:Admin:HealSource')
AddEventHandler('Damage:Admin:HealSource', function()
    local src = source
    local player = exports['bs_base']:FetchComponent('Fetch'):Source(src)
    if player ~= nil then
        local char = player:GetData('Character')
        if char ~= nil then
            Damage:Heal(char)
        end
    end
end)