AddEventHandler('Animations:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Database = exports['bs_base']:FetchComponent('Database')
    Utils = exports['bs_base']:FetchComponent('Utils')
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Chat = exports['bs_base']:FetchComponent('Chat')
    Animations = exports['bs_base']:FetchComponent('Animations')
    RegisterChatCommands()
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Animations', {
        'Database',
        'Utils',
        'Callbacks',
        'Chat',
        'Animations',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        RegisterCallbacks()
    end)
end)

function RegisterChatCommands()
    Chat:RegisterCommand('e', function(source, args, rawCommand)
        local _src = source
        local emote = args[1]
        if emote == "c" or emote == "cancel" then
            TriggerClientEvent('Animations:Client:CharacterCancelEmote', _src)
        else
            TriggerClientEvent('Animations:Client:CharacterDoAnEmote', _src, emote)
        end
    end, {
        help = 'Do An Emote or Dance',
        params = {{
            name = 'Emote',
            help = 'Name of The Emote/Dance to Do'
        }},
    })
    Chat:RegisterCommand('features', function(source, args, rawCommand)
        local _src = source
        TriggerClientEvent('Execute:Client:Component', _src, 'Animations', 'OpenFeaturesMenu')
    end, {
        help = 'Change Features Such As Walkstyle or Facial Expression',
    })
    Chat:RegisterCommand('emotebinds', function(source, args, rawCommand)
        local _src = source
        TriggerClientEvent('Animations:Client:OpenEmoteBinds', _src)
    end, {
        help = 'Edit Binded Emotes',
    })
end

function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Animations:UpdatePedFeatures', function(source, data, cb)
        local _src = source
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(_src)
        local char = player:GetData('Character')
        Animations.PedFeatures:UpdateFeatureInfo(char, data.type, data.data, function(success)
            cb(success)
        end) 
    end)
    Callbacks:RegisterServerCallback('Animations:UpdateEmoteBinds', function(source, data, cb)
        local _src = source
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(_src)
        local char = player:GetData('Character')
        Animations.EmoteBinds:Update(char, data, function(success)
            cb(success)
        end) 
    end)
end

ANIMATIONS = {
    PedFeatures = {
        UpdateFeatureInfo = function(self, char, type, data, cb)
            if type == "walk" then
                local currentData = char:GetData('Animations')
                char:SetData('Animations', { walk = data, expression = currentData.expression, emoteBinds = currentData.emoteBinds})
                cb(true)
            elseif type == "expression" then
                local currentData = char:GetData('Animations')
                char:SetData('Animations', { walk = currentData.walk, expression = data, emoteBinds = currentData.emoteBinds})
                cb(true)
            else
                cb(false)
            end
        end,
    },
    EmoteBinds = {
        Update = function(self, char, data, cb)
            local currentData = char:GetData('Animations')
            char:SetData('Animations', { walk = currentData.walk, expression = currentData.expression, emoteBinds = data})
            cb(true)
        end,
    },
    GetData = function(self, char, cb)
        local char = exports['bs_base']:FetchComponent('Fetch'):Source(source):GetData('Character')
    
        if char:GetData('Animations') == nil then
            char:SetData('Animations', { walk = 'default', expression = 'default', emoteBinds = {}})
        end
        cb(char:GetData('Animations'))
    end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Animations', ANIMATIONS)
end)

RegisterServerEvent('Characters:Server:Spawn')
AddEventHandler('Characters:Server:Spawn', function()
    local _src = source
    local player = exports['bs_base']:FetchComponent('Fetch'):Source(_src)
    local char = player:GetData('Character')
    Animations:GetData(char, function(data)
        TriggerClientEvent('Animations:Client:RecieveStoredAnimSettings', _src, data)
    end)
end)