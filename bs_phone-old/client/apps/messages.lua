RegisterNetEvent('Phone:Client:Messages:Notify')
AddEventHandler('Phone:Client:Messages:Notify', function(message, noBanner)
    SendNUIMessage({
        type = 'ADD_DATA',
        data = { type = 'messages', data = message }
    })
    Citizen.Wait(1000)

    if _settings.notifications and not _settings.appNotifications['messages'] then
        Phone.Notification:Add('messages', 'convo/' .. message.number, 'Unread Text Message', 'comment-alt', '#14A600', message.time, noBanner, {
            sound = _settings.texttone,
            volume = (0.1 * (_settings.volume / 100))
        })
        
        Notification:Info('You Received A Text Message', 2000)
    end
end)

RegisterNUICallback('SendMessage', function(data, cb)
    cb('OK')
    Callbacks:ServerCallback('Phone:Messages:SendMessage', data)
end)

RegisterNUICallback('ReadConvo', function(data, cb)
    cb('OK')
    Callbacks:ServerCallback('Phone:Messages:ReadConvo', data)
end)

RegisterNUICallback('DeleteConvo', function(data, cb)
    cb('OK')
    Callbacks:ServerCallback('Phone:Messages:DeleteConvo', data)
end)