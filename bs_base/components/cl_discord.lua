COMPONENTS.Discord = {
    _name = 'base',

    --- @param appId string A Discord application id.
    --- @param asset string The asset name for big image.
    --- @param assetText string The title text.
    --- @param assetSmall string The asset name for small image.
    RichPresence = function(self, appId, asset, assetText, assetSmall)
        SetDiscordAppId(appId)
        SetDiscordRichPresenceAsset(asset)
        SetDiscordRichPresenceAssetText(assetText)
        SetDiscordRichPresenceAssetSmall(assetSmall)
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

CreateThread(function() -- Discord Rich Presence
    COMPONENTS.Discord:RichPresence("", "", "", "") 
end)