RegisterNUICallback('MenuOpen', function(data, cb)
    cb('OK')
    if cbs[data.id .. '-open'] ~= nil then
        cbs[data.id .. '-open'](data.id, data.back)
    end
end)

RegisterNUICallback('MenuClose', function(data, cb)
    cb('OK')
    if cbs[data.id .. '-close'] ~= nil then
        cbs[data.id .. '-close']()
    end
end)

RegisterNUICallback('Close', function(data, cb)
    cb('OK')
    SendNUIMessage({
        type = 'APP_HIDE'
    })
    SetNuiFocus(false, false)

    for k, v in pairs(cbs) do
        if string.match(k, "-close") then
            v()
        end
    end

    cbs = {}
end)

RegisterNUICallback('Selected', function(data, cb)
    cb('OK')
    if cbs[data.id] ~= nil then
        cbs[data.id](data)
    end
end)

local Sounds = {
    ['SELECT'] = { id = -1, sound = 'SELECT', library = 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
    ['BACK'] = { id = -1, sound = 'CANCEL', library = 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
    ['UPDOWN'] = { id = -1, sound = 'NAV_UP_DOWN', library = 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
    ['DISABLED'] = { id = -1, sound = 'ERROR', library = 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
}

RegisterNUICallback('FrontEndSound', function(data, cb)
    cb('ok')

    if Sounds[data.sound] ~= nil then
        UISounds.Play:FrontEnd(Sounds[data.sound].id, Sounds[data.sound].sound, Sounds[data.sound].library)
    end
end)