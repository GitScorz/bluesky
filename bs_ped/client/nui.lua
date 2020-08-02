local Sounds = {
    ['SELECT'] = { id = -1, sound = 'SELECT', library = 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
    ['BACK'] = { id = -1, sound = 'CANCEL', library = 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
    ['UPDOWN'] = { id = -1, sound = 'NAV_UP_DOWN', library = 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
    ['DISABLED'] = { id = -1, sound = 'ERROR', library = 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
}
RegisterNUICallback('FrontEndSound', function(data, cb)
    cb('ok')
    if Sounds[data.sound] ~= nil then
        UISounds:Play(Sounds[data.sound].id, Sounds[data.sound].sound, Sounds[data.sound].library)
    end
end)

RegisterNUICallback('Save', function(data, cb)
    Callbacks:ServerCallback('Ped:SavePed', {
        ped = LocalPed
    }, function(saved)
        if data.state == 'CREATOR' then
            Creator:End()
        elseif data.state == 'SHOP' then
            Clotheshop:Hide()
        end
    end)
end)

RegisterNUICallback('RotateLeft', function(data, cb)
    local playerPed = PlayerPedId()
    Citizen.CreateThread(function()
        for i = 0, 20, 1 do
            local heading = GetEntityHeading(playerPed)
            SetEntityHeading(playerPed, heading - 1)
            Citizen.Wait(10)
        end
    end)
end)


RegisterNUICallback('RotateRight', function(data, cb)
    local playerPed = PlayerPedId()
    Citizen.CreateThread(function()
        for i = 0, 20, 1 do
            local heading = GetEntityHeading(playerPed)
            SetEntityHeading(playerPed, heading + 1)
            Citizen.Wait(10)
        end
    end)
end)

RegisterNUICallback('SetPedHeadBlendData', function(data, cb)
    cb('OK')
    LocalPed.customization.face[data.face][data.type] = data.value
    Ped:ApplyToPed(LocalPed)
end)

RegisterNUICallback('SetPedFaceFeature', function(data, cb)
    cb('OK')
    LocalPed.customization.face.features[data.index] = data.value
    Ped:ApplyToPed(LocalPed)
end)

RegisterNUICallback('SetPedHeadOverlay', function(data, cb)
    cb('OK')
    if data.extraType == "opacity" then
        LocalPed.customization.overlay[data.type].opacity = data.value
    else
        LocalPed.customization.overlay[data.type][data.extraType] = data.value
    end
    Ped:ApplyToPed(LocalPed)
end)

RegisterNUICallback('SetPedComponentVariation', function(data, cb)
    cb('OK')
    LocalPed.customization.components[data.name][data.type] = data.value
    Ped:ApplyToPed(LocalPed)
end)

RegisterNUICallback('SetPedPropIndex', function(data, cb)
    cb('OK')
    LocalPed.customization.props[data.name][data.type] = data.value
    Ped:ApplyToPed(LocalPed)
end)

RegisterNUICallback('SetPedHairColor', function(data, cb)
    cb('OK')
    LocalPed.customization.colors[data.name][data.type].index = data.value
    Ped:ApplyToPed(LocalPed)
end)

RegisterNUICallback('GetNumHairColors', function(data, cb)
    cb('OK')
    SendNUIMessage({
        type = "SET_HAIR_COLORS_MAX",
        data = {
            max = GetNumHairColors()
        }
    })
end)

RegisterNUICallback('GetPedHairRgbColor', function(data, cb)
    cb('OK')
    local red, green, blue = GetPedHairRgbColor(data.colorId)
    SendNUIMessage({
        type = "SET_HAIR_COLOR_RGB",
        data = {
            type = data.type,
            name = data.name,
            rgb = 'rgb(' .. red .. ', ' .. green .. ', ' .. blue .. ')'
        }
    })
end)

RegisterNUICallback('GetNumberOfPedDrawableVariations', function(data, cb)
    cb('OK')
    SendNUIMessage({
        type = "SET_MAX_DRAWABLE",
        data = {
            id = data.componentId,
            type = 'components',
            max = GetNumberOfPedDrawableVariations(PlayerPedId(), data.componentId)
        }
    })
end)

RegisterNUICallback('GetNumberOfPedTextureVariations', function(data, cb)
    cb('OK')
    SendNUIMessage({
        type = "SET_MAX_TEXTURE",
        data = {
            id = data.componentId,
            textureId = data.textureId,
            type = 'components',
            max = GetNumberOfPedTextureVariations(PlayerPedId(), data.componentId, data.drawableId)
        }
    })
end)

RegisterNUICallback('GetNumberOfPedPropDrawableVariations', function(data, cb)
    cb('OK')
    SendNUIMessage({
        type = "SET_MAX_DRAWABLE",
        data = {
            id = data.componentId,
            type = 'props',
            max = GetNumberOfPedPropDrawableVariations(PlayerPedId(), data.propId)
        }
    })
end)

RegisterNUICallback('GetNumberOfPedPropTextureVariations', function(data, cb)
    cb('OK')
    SendNUIMessage({
        type = "SET_MAX_TEXTURE",
        data = {
            id = data.componentId,
            textureId = data.textureId,
            type = 'props',
            max = GetNumberOfPedPropTextureVariations(PlayerPedId(), data.componentId, data.drawableId)
        }
    })
end)