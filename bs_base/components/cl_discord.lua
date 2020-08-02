COMPONENTS.Discord = {
    _name = 'base',
    RichPresence = function(self)
        SetDiscordAppId('')
        SetDiscordRichPresenceAsset('')
        SetDiscordRichPresenceAssetText('')
        SetDiscordRichPresenceAssetSmall('')
        Citizen.CreateThread(function()
            while true do
                if COMPONENTS.Player ~= nil and COMPONENTS.Player.LocalPlayer ~= nil and COMPONENTS.Player.LocalPlayer:GetData('Character') ~= nil then
                    local char = COMPONENTS.Player.LocalPlayer:GetData('Character')
                    SetRichPresence('Playing ' .. char:GetData('First') .. ' ' .. char:GetData('Last'))
                else
                    SetRichPresence('Selecting A Character')
                end
    
                local players = GetActivePlayers()
                SetDiscordRichPresenceAssetSmallText(#players .. '/' .. COMPONENTS.Convar.MAX_CLIENTS.value)
                Citizen.Wait(60000)
            end
        end)
    end
}

Citizen.CreateThread(function() COMPONENTS.Discord:RichPresence() end)