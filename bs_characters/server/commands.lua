function RegisterCommands()
    Chat:RegisterAdminCommand('logout', function(source, args, rawCommand)
        exports['bs_base']:FetchComponent('Execute'):Client(source, 'Characters', 'Logout')
    end, {
        help = 'Logout',
    }, 0)
end