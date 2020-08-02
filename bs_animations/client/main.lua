Callbacks, Notification, Damage, Animations = nil, nil, nil, nil
characterLoaded = false
GLOBAL_PED = nil

walkStyle = 'default'
facialExpression = 'default'
emoteBinds = {}

AddEventHandler('Animations:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Utils = exports['bs_base']:FetchComponent('Utils')
    Notification = exports['bs_base']:FetchComponent('Notification')
    Menu = exports['bs_base']:FetchComponent('Menu')
    Damage = exports['bs_base']:FetchComponent('Damage')
    Animations = exports['bs_base']:FetchComponent('Animations')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Animations', {
        'Callbacks',
        'Utils',
        'Notification',
        'Menu',
        'Damage',
        'Animations',
    }, function(error)  
        if #error > 0 then return; end
        RetrieveComponents()
    end)
end)

AddEventHandler('Characters:Client:Spawn', function()
    characterLoaded = true
    Citizen.CreateThread(function()
        GLOBAL_PED = PlayerPedId()
        while characterLoaded do 
            Citizen.Wait(10000)
            GLOBAL_PED = PlayerPedId()
        end
    end)
    Citizen.CreateThread(function() -- Deal With KeyPresses
        while characterLoaded do
            if IsInAnimation and IsPedShooting(GLOBAL_PED) then
                Animations.Emotes:ForceCancel()
            end
            if IsControlJustPressed(0, Config.CancelKeybind) then 
                Animations.Emotes:Cancel()
            elseif IsControlJustPressed(0, Config.MenuKeybind) then 
                Animations:OpenMainEmoteMenu()
            end

            for k, v in pairs(Config.KeybindKeys) do
                if emoteBinds[k] ~= nil then
                    if IsControlJustReleased(0, v.id) then
                        local targetEmote = emoteBinds[k]
                        if targetEmote ~= "" then 
                            Animations.Emotes:Play(targetEmote)
                        end
                    end
                end
            end
            Citizen.Wait(5)
        end
    end)
end)


RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    characterLoaded = false
end)

RegisterNetEvent('Animations:Client:RecieveStoredAnimSettings')
AddEventHandler('Animations:Client:RecieveStoredAnimSettings', function(data)
    if data then
        walkStyle, facialExpression, emoteBinds = data.walk, data.expression, data.emoteBinds
        Animations.PedFeatures:RequestFeaturesUpdate()
    else -- There is non stored and reset back to default
        walkStyle, facialExpression, emoteBinds =  Config.DefaultSettings.walk, Config.DefaultSettings.expression, Config.DefaultSettings.emoteBinds
        Animations.PedFeatures:RequestFeaturesUpdate()
    end
end)
