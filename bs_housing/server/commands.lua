function RegisterChatCommands()
    Chat:RegisterAdminCommand('offset', function(source, args, rawCommand)
        TriggerClientEvent('Housing:Client:CalcOffset', source)
    end, {
        help = 'Get Offset To Your Position From The Shell Object',
    }, 0)

    Chat:RegisterAdminCommand('addprop', function(source, args, rawCommand)
        local ped = GetPlayerPed(source)
        local coords = GetEntityCoords(ped)
        local pos = {
            x = coords.x,
            y = coords.y,
            z = coords.z + 0.5,
        }
        Housing.Manage:Add(source, tonumber(args[1]), tonumber(args[2]), args[3], pos)
    end, {
        help = 'Add New Property To Database (Enter Is Where You\'re At)',
        params = {{
            name = 'Interior ID',
            help = 'ID of Which Interior This Will Spawn'
        },
        {
            name = 'Property Price',
            help = 'Cost of the property'
        },
        {
            name = 'Property Label',
            help = 'Name for the property'
        }}
    }, 3)

    Chat:RegisterAdminCommand('delprop', function(source, args, rawCommand)
        Housing.Manage:Delete(source, args[1])
    end, {
        help = 'Add New Property To Database (Enter Is Where You\'re At',
        params = {{
            name = 'Property ID',
            help = 'Unique ID of the Property You Want To Delete'
        }}
    }, 1)

    Chat:RegisterAdminCommand('addbd', function(source, args, rawCommand)
        Housing.Manage:AddBackdoor(source, args[1])
    end, {
        help = 'Set The Backdoor Location Of A Property',
        params = {{
            name = 'Property ID',
            help = 'Unique ID of The Property'
        }}
    }, 1)
end