local inEmoteBindMenu = false
ANIMATIONS.EmoteBinds = {
    BindManagement = function(self, fromMainMenu)
        if not inEmoteBindMenu then
            local bindingManager = Menu:Create('bindManagement', 'Emote Bind Management', function(id, back)
                inEmoteBindMenu = true
            end, function()
                inEmoteBindMenu = false
            end)

            local tempBindData = {}
            for k,v in spairs(Config.KeybindKeys) do
                if emoteBinds[k] then
                    tempBindData[k] = emoteBinds[k]
                end
                bindingManager.Add:Input(v.keyName, {
                    disabled = false,
                    max = 30,
                    current = emoteBinds[k] or "", -- Blank if nil
                }, function(data)
                    tempBindData[k] = data.data.value
                end)
            end

            bindingManager.Add:Button('Save Keybind Settings', { success = true}, function(data)
                Animations.EmoteBinds:OverrideSavedBinds(tempBindData)
                bindingManager:Close()
            end)

            bindingManager.Add:SubMenuBack('Reset All Keybinds', {}, function(data)
                Animations.EmoteBinds:OverrideSavedBinds({})
                bindingManager:Close()
            end)

            if fromMainMenu then
                bindingManager.Add:SubMenuBack('Return To Main Menu', {}, function(data)
                    bindingManager:Close()
                    Citizen.Wait(100)
                    Animations:OpenMainEmoteMenu()
                end)
            end

            bindingManager:Show()
        end
    end,
    OverrideSavedBinds = function(self, data)
        local temp = {}
        for k,v in pairs(data) do
            if AnimData.Emotes[v] or AnimData.Dances[v] or AnimData.PropEmotes[v] or AnimData.PropEmotes[v] then
                temp[k] = v
            end
        end
        Utils:Print(temp)
        Callbacks:ServerCallback('Animations:UpdateEmoteBinds', temp, function(success)
            if success then
                emoteBinds = temp
                Notification:Success('Successfully Updated and Saved Keybinds', 5000)
            end
        end)
    end,
}

RegisterNetEvent('Animations:Client:OpenEmoteBinds')
AddEventHandler('Animations:Client:OpenEmoteBinds', function()
    if characterLoaded then
        Animations.EmoteBinds:BindManagement()
    end
end)

