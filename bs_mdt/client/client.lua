local _open = false

function toggleUi() 
    if _open then
        _open = false
        SendNUIMessage({
            type = 'APP_HIDE'
        })
    else
        _open = true
        SendNUIMessage({
            type = 'APP_SHOW'
        })
    end

    SetNuiFocus(_open, _open)
end

RegisterNetEvent('MDT:Client:Open')
AddEventHandler('MDT:Client:Open', toggleUi)

RegisterNUICallback('Close', function(data, cb)
    cb('OK')
    toggleUi()
end)