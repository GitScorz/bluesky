AddEventHandler('Hud:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Chat = exports['bs_base']:FetchComponent('Chat')
    RegisterChatCommands()
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Hud', {
        'Chat',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
    end)
end)

function RegisterChatCommands()
    Chat:RegisterCommand('notif', function(source, args, rawCommand)
        exports['bs_base']:FetchComponent('Execute'):Client(source, 'Notification', 'Success', 'This is a test, lul')
    end, {
        help = 'Test Notification'
    })
end