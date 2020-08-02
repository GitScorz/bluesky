Citizen.CreateThread(function()
    while GetIsLoadingScreenActive() do
        Citizen.Wait(0)
    end
    SendNUIMessage({
        type = 'APP_SHOW'
    })
end)

RegisterNUICallback('GetData', function(data, cb)
    cb("ok")
    Callbacks:ServerCallback('Characters:GetServerData', {}, function(serverData)
        SendNUIMessage({
            type = 'LOADING_SHOW',
            data = { message = 'Getting Character Data' }
        })

        Callbacks:ServerCallback('Characters:GetCharacters', {}, function(characters)
            SendNUIMessage({
                type = 'SET_DATA',
                data = { changelog = serverData.changelog, motd = serverData.motd, characters = characters }
            })
            SendNUIMessage({ type = 'LOADING_HIDE' })
            SendNUIMessage({
                type = 'SET_STATE',
                data = { state = 'STATE_CHARACTERS' }
            })
        end)
    end)
end)

RegisterNUICallback('CreateCharacter', function(data, cb)
    cb("ok")
    Callbacks:ServerCallback('Characters:CreateCharacter', data, function(character)
        if character ~= nil then
            SendNUIMessage({
                type = 'CREATE_CHARACTER',
                data = { character = character }
            })
        end

        SendNUIMessage({
            type = 'SET_STATE',
            data = { state = 'STATE_CHARACTERS' }
        })
        SendNUIMessage({ type = 'LOADING_HIDE' })
    end)
end)

RegisterNUICallback('DeleteCharacter', function(data, cb)
    cb("ok")
    Callbacks:ServerCallback('Characters:DeleteCharacter', data.id, function(status)
        if status then
            SendNUIMessage({
                type = 'DELETE_CHARACTER',
                data = { index = data.index }
            })
        end
        SendNUIMessage({ type = 'LOADING_HIDE' })
    end)
end)

RegisterNUICallback('SelectCharacter', function(data, cb)
    cb("ok")
    Callbacks:ServerCallback('Characters:GetSpawnPoints', data.id, function(spawns)
        if spawns then
            SendNUIMessage({
                type = 'SET_SPAWNS',
                data = { spawns = spawns }
            })
            SendNUIMessage({
                type = 'SET_STATE',
                data = { state = 'STATE_SPAWN' }
            })
        end

        SendNUIMessage({ type = 'LOADING_HIDE' })
    end)
end)

RegisterNUICallback('PlayCharacter', function(data, cb)
    cb("ok")
    Callbacks:ServerCallback('Characters:GetCharacterData', data.character.ID, function(cData)
        cData.spawn = data.spawn
        TriggerEvent('Characters:Client:SetData', cData, function()
            exports['bs_base']:FetchComponent('Spawn'):SpawnToWorld(cData, function()
                TriggerEvent('Characters:Client:Spawn')
                TriggerServerEvent('Characters:Server:Spawn')

                SendNUIMessage({ type = 'APP_HIDE' })
                SendNUIMessage({
                    type = 'SET_STATE',
                    data = { state = 'STATE_CHARACTERS' }
                })
                SendNUIMessage({ type = 'LOADING_HIDE' })
            end)
        end)
    end)
end)