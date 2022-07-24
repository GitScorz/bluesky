function RegisterChatCommands()
    Chat:RegisterCommand('testemail', function(source, args, rawCommand)
        local coords = GetEntityCoords(GetPlayerPed(source))
        Phone.Email:Send(source, 'fuckyoulol@pixel.onion', os.time() * 1000, 'Dumb Bitch LUL', 'This is some message that would be sent, fucking LUL', {
            location = {
                x = coords.x,
                y = coords.y,
                z = coords.z
            }
        })
    end, {
        help = 'Test Menu'
    })
end