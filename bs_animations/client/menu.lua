local inEmoteMenu, inEmoteSubMenu, inFeaturesMenu = false, false, false


ANIMATIONS = {
    OpenMainEmoteMenu = function(self)
        if not inEmoteMenu then
            local root = Menu:Create('animationMenu', 'Animation Menu', function(id, back)
                inEmoteMenu = true
            end, function()
                inEmoteMenu = false
            end)


            local emotes = Menu:Create('regEmoteList', 'Standard Emotes')

            for k,v in spairs(Config.EmoteNaming.regular) do

                emotes.Add:Button(v.name, {}, function(data)
                    root:Close()
                    self:OpenEmoteSubMenu(k, true)
                end)
            end

            root.Add:SubMenu('Emotes', emotes)
            emotes.Add:SubMenuBack('Go Back')

            root.Add:Button('Dance Emotes', {}, function(data)
                root:Close()
                self:OpenEmoteSubMenu('dance')
            end)

            root.Add:Button('Prop Emotes', {}, function(data)
                root:Close()
                self:OpenEmoteSubMenu('prop')
            end)
            
            root.Add:Button('Change Features', {}, function(data)
                root:Close()
                self:OpenFeaturesMenu(true)
            end)

            root.Add:Button('Edit Emote Binds', {}, function(data)
                root:Close()
                Animations.EmoteBinds:BindManagement(true)
            end)

            root.Add:SubMenuBack('Cancel Current Emote', {}, function(data)
                Animations.Emotes:Cancel()
            end)  
            
            root.Add:SubMenuBack('Close', {}, function(data)
                root:Close()
            end)        

            root:Show()
        end
    end,
    OpenEmoteSubMenu = function(self, cata, regular)
        local emoteCat, emoteSub
        if regular then
            emoteCat = Config.EmoteNaming.regular[cata]
            emoteSub = Menu:Create(cata, emoteCat.name, function(id, back)
                inEmoteSubMenu = true
            end, function()
                inEmoteSubMenu = false
            end)
        else
            emoteCat = Config.EmoteNaming[cata]
            emoteSub = Menu:Create(cata, emoteCat.name, function(id, back)
                inEmoteSubMenu = true
            end, function()
                inEmoteSubMenu = false
            end)
        end
        if emoteCat ~= nil then
            for k,v in spairs(emoteCat.emotes) do
                emoteSub.Add:AdvButton(v, { secondaryLabel = '/e ' .. k }, function(data)
                    Animations.Emotes:Cancel()
                    Animations.Emotes:Play(k, true)
                end)
            end

            emoteSub.Add:Button('Cancel Current Emote', { success = true }, function(data)
                Animations.Emotes:Cancel()
            end) 

            emoteSub.Add:SubMenuBack('Return To Main Menu', {}, function(data)
                emoteSub:Close()
                Citizen.Wait(100)
                self:OpenMainEmoteMenu()
            end) 

            emoteSub:Show() 
        end

    end,
    OpenFeaturesMenu = function(self, fromMainMenu)
        if not inFeaturesMenu then
            local root = Menu:Create('featuresMenu', 'Features Menu', function(id, back)
                inFeaturesMenu = true
            end, function()
                inFeaturesMenu = false
            end)

            local walkMenu = Menu:Create('walkMenu', 'Select Walking Style')
            local espressionMenu = Menu:Create('expressionMenu', 'Select Expression')

            walkMenu.Add:SubMenuBack('Reset Walk', {}, function(data)
                Animations.PedFeatures:SetWalk('reset', 'reset')
            end)
            espressionMenu.Add:SubMenuBack('Reset Expression', {}, function(data)
                Animations.PedFeatures:SetExpression('reset', 'reset')
            end)

            for k,v in spairs(Config.Walks) do
                walkMenu.Add:Button(k, { disabled = false }, function(data)
                    Animations.PedFeatures:SetWalk(v, k)
                end)
            end

            for k,v in spairs(Config.Expressions) do
                espressionMenu.Add:Button(k, { disabled = false }, function(data)
                    Animations.PedFeatures:SetExpression(v, k)
                end)
            end
            walkMenu.Add:SubMenuBack('Go Back')
            espressionMenu.Add:SubMenuBack('Go Back')

            root.Add:SubMenu('Change Walking Style', walkMenu)
            root.Add:SubMenu('Change Facial Expression', espressionMenu)
            root.Add:SubMenuBack('Reset Expressions and Walkstyles', {}, function(data)
                Animations.PedFeatures:SetWalk('reset', 'reset')
                Animations.PedFeatures:SetExpression('reset', 'reset')
            end)

            if fromMainMenu then
                root.Add:SubMenuBack('Return To Main Menu', {}, function(data)
                    root:Close()
                    Citizen.Wait(100)
                    self:OpenMainEmoteMenu()
                end)
            end

            root:Show()
        end
    end,
}

