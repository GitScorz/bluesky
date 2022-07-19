local _blacklistedClientEvents = {
    'esx:getSharedObject',
}

local _blacklistedCommands = {
    -- 'pk',
    'haha',
    'lol',
    'xddd',
    'chocolate',
    'panickey'
}

local _retrieved = {}

function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Pwnzor:GetEvents', function(source, data, cb)
        if not Pwnzor.Players:Get(source, 'GetEvents') then
            Pwnzor.Players:Set(source, 'GetEvents')
            cb(_blacklistedClientEvents)
        else
            if not Fetch:Source(source).Permissions:IsAdmin() then
                Punishment.Ban:Source(source, -1, 'Attempt To Recall GetEvents', 'Pwnzor')
            end
        end
    end)

    Callbacks:RegisterServerCallback('Pwnzor:GetCommands', function(source, data, cb)
        if not Pwnzor.Players:Get(source, 'GetCommands') then
            Pwnzor.Players:Set(source, 'GetCommands')
            cb(_blacklistedCommands)
        else
            if not Fetch:Source(source).Permissions:IsAdmin() then
                Punishment.Ban:Source(source, -1, 'Attempt To Recall GetCommands', 'Pwnzor')
            end
        end
    end)

    Callbacks:RegisterServerCallback('Pwnzor:AFK', function(source, data, cb)
        if Config.Components.AFK.Enabled then
            Punishment:Kick(source, 'You Were Kicked For Being AFK', 'Pwnzor')
        end
    end)

    Callbacks:RegisterServerCallback('Pwnzor:Trigger', function(source, data, cb)
        cb('💙 From Pwnzor 🙂')
        if not Fetch:Source(source).Permissions:IsAdmin() then
            Punishment.Ban:Source(source, -1, 'Pwnzor Trigger: ' .. data, 'Pwnzor')
        end
    end)
end