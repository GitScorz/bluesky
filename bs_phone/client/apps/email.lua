RegisterNetEvent('Phone:Client:Email:Receive')
AddEventHandler('Phone:Client:Email:Receive', function(email, noBanner)
    SendNUIMessage({
        type = 'ADD_DATA',
        data = { type = 'emails', data = email }
    })
    Citizen.Wait(1000)

    if _settings.notifications and not _settings.appNotifications['email'] then
        Phone.Notification:Add('email', 'view/' .. email._id, 'New Email', 'envelope', PHONE_APPS.email.color, email.time, noBanner, {
            sound = _settings.texttone,
            volume = (0.1 * (_settings.volume / 100))
        })
        
        Notification:Info('You Received A New Email', 2000)
    end
end)

RegisterNUICallback('ReadEmail', function(data, cb)
    Callbacks:ServerCallback('Phone:Email:Read', data, cb)
end)

RegisterNUICallback('DeleteEmail', function(data, cb)
    cb('OK')
    Callbacks:ServerCallback('Phone:Email:Delete', data)
end)

RegisterNUICallback('GPSRoute', function(data, cb)
    cb('OK')
    SetNewWaypoint(data.location.x, data.location.y)
end)


local _loggedIn = false
RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    _loggedIn = false
end)

AddEventHandler('Characters:Client:Spawn', function()
    _loggedIn = true
    Citizen.CreateThread(function()
        while _loggedIn do
            Callbacks:ServerCallback('Phone:Email:DeleteExpired', {}, function(ids)
                for k, v in ipairs(ids) do
                    print(('^2Removing %s From NUI'):format(v))
                    Phone.Data:Remove('emails', v)
                end
            end)
            Citizen.Wait(10000)
        end
    end)
end)