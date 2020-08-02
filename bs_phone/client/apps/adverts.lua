RegisterNUICallback('CreateAdvert', function(data, cb)
    Callbacks:ServerCallback('Phone:Adverts:Create', data)
    cb('OK')
end)

RegisterNUICallback('UpdateAdvert', function(data, cb)
    Callbacks:ServerCallback('Phone:Adverts:Update', data)
    cb('OK')
end)

RegisterNUICallback('DeleteAdvert', function(data, cb)
    Callbacks:ServerCallback('Phone:Adverts:Delete')
    cb('OK')
end)