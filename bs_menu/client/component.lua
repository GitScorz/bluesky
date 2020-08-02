cbs = {}
menuItems = {}
submenus = {}

--RetrieveComponents
AddEventHandler('Menu:Shared:DependencyUpdate', SomeBullshitNameThatIsntFuckingUsedFUCKYOUBITCH)
function SomeBullshitNameThatIsntFuckingUsedFUCKYOUBITCH()
    print('^3I literally wanna die^7')
    UISounds = exports['bs_base']:FetchComponent('UISounds')
end

AddEventHandler('Core:Shared:Ready', function(component)
    exports['bs_base']:RequestDependencies('Menu', {
        'UISounds',
    }, function(error)  
        SomeBullshitNameThatIsntFuckingUsedFUCKYOUBITCH()
        if #error > 0 then return end
    end)
end)

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Menu', MENU)
end)

MENU = {
    Create = function(self, mId, mLabel, openCb, closeCb)
        local menuId = mId
        local menuLabel = mLabel

        menuItems[menuId] = {}

        local _data = {
            data = {
                id = menuId,
                label = menuLabel
            },
            Show = function(self, back)
                if not back and openCb ~= nil then
                    openCb()
                end

                self.data.items = menuItems[menuId]
                SendNUIMessage({
                    type = 'SETUP_MENU',
                    data = {
                        data = self.data
                    }
                })
                SendNUIMessage({
                    type = 'APP_SHOW'
                })
                SetNuiFocus(true, true)
            end,
            SubMenu = function(self, id, back)
                local data = submenus[id]
                data.items = menuItems[id]
                SendNUIMessage({
                    type = 'SUBMENU_OPEN',
                    data = {
                        data = data,
                        addHistroy = not back
                    }
                })
            end,
            Toggle = function(self, status)
                if status then
                    SendNUIMessage({
                        type = 'APP_SHOW'
                    })
                    SetNuiFocus(true, true)
                else
                    SendNUIMessage({
                        type = 'APP_HIDE'
                    })
                    SetNuiFocus(false, false)
                end
            end,
            Close = function(self)
                SendNUIMessage({
                    type = 'APP_HIDE'
                })
                SetNuiFocus(false, false)
                SendNUIMessage({
                    type = 'CLEAR_MENU'
                })
                if closeCb ~= nil then
                    closeCb()
                end
                menuItems = {}
                cbs = {}
            end,
            ValidateOptions = function(self, type, options)
                local reqAtts = {
                    ['BUTTON'] = {},
                    ['ADVANCED'] = { 'secondaryLabel' },
                    ['CHECKBOX'] = { 'checked' },
                    ['SLIDER'] = { 'min', 'max', 'current' },
                    ['TICKER'] = { 'min', 'max', 'current' },
                    ['COLORPICKER'] = { 'current' },
                    ['COLORLIST'] = { 'current', 'colors' },
                    ['INPUT'] = { 'max' },
                    ['NUMBER'] = {},
                    ['SELECT'] = { 'current', 'list' },
                    ['TEXT'] = {},
                    ['SUBMENU'] = {},
                    ['GOBACK'] = {},
                    ['SUCCESSBUTTON'] = {}
                }

                if reqAtts[type] ~= nil then
                    for k, v in ipairs(reqAtts[type]) do
                        if options[v] == nil then
                            return false
                        end
                    end

                    return true
                else
                    return false
                end
            end
        }

        _data.Add = {
            Button = function(self, label, options, selectCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('BUTTON', options) then
                    return
                end
                local id = menuId .. '-item' .. #menuItems[menuId]
                cbs[id] = selectCb
                table.insert(menuItems[menuId], {
                    type = 'BUTTON',
                    id = id,
                    label = label,
                    options = options
                })
            end,
            AdvButton = function(self, label, options, selectCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('ADVANCED', options) then
                    return
                end
                local id = menuId .. '-item' .. #menuItems[menuId]
                cbs[id] = selectCb
                table.insert(menuItems[menuId], {
                    type = 'ADVANCED',
                    id = id,
                    label = label,
                    options = options
                })
            end,
            Slider = function(self, label, options, selectCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('SLIDER', options) then
                    return
                end
                local id = menuId .. '-item' .. #menuItems[menuId]
                cbs[id] = selectCb
                table.insert(menuItems[menuId], {
                    type = 'SLIDER',
                    id = id,
                    label = label,
                    options = options
                })
            end,
            Ticker = function(self, label, options, selectCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('TICKER', options) then
                    return
                end
                local id = menuId .. '-item' .. #menuItems[menuId]
                cbs[id] = selectCb
                table.insert(menuItems[menuId], {
                    type = 'TICKER',
                    id = id,
                    label = label,
                    options = options
                })
            end,
            CheckBox = function(self, label, options, selectCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('CHECKBOX', options) then
                    return
                end
                local id = menuId .. '-item' .. #menuItems[menuId]
                cbs[id] = selectCb
                table.insert(menuItems[menuId], {
                    type = 'CHECKBOX',
                    id = id,
                    label = label,
                    options = options
                })
            end,
            ColorPicker = function(self, options, selectCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('COLORPICKER', options) then
                    return
                end
                local id = menuId .. '-item' .. #menuItems[menuId]
                cbs[id] = selectCb
                table.insert(menuItems[menuId], {
                    type = 'COLORPICKER',
                    id = id,
                    options = options
                })
            end,
            ColorList = function(self, options, selectCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('COLORLIST', options) then
                    return
                end
                local id = menuId .. '-item' .. #menuItems[menuId]
                cbs[id] = selectCb
                table.insert(menuItems[menuId], {
                    type = 'COLORLIST',
                    id = id,
                    options = options
                })
            end,
            Input = function(self, label, options, selectCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('INPUT', options) then
                    return
                end
                local id = menuId .. '-item' .. #menuItems[menuId]
                cbs[id] = selectCb
                table.insert(menuItems[menuId], {
                    type = 'INPUT',
                    id = id,
                    label = label,
                    options = options
                })
            end,
            Number = function(self, label, options, selectCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('NUMBER', options) then
                    return
                end
                local id = menuId .. '-item' .. #menuItems[menuId]
                cbs[id] = selectCb
                table.insert(menuItems[menuId], {
                    type = 'NUMBER',
                    id = id,
                    label = label,
                    options = options
                })
            end,
            Select = function(self, label, options, selectCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('SELECT', options) then
                    return
                end
                local id = menuId .. '-item' .. #menuItems[menuId]
                cbs[id] = selectCb
                table.insert(menuItems[menuId], {
                    type = 'SELECT',
                    id = id,
                    label = label,
                    options = options
                })
            end,
            Text = function(self, text, classes)
                if not _data:ValidateOptions('TEXT', options) then
                    return
                end

                local id = menuId .. '-item' .. #menuItems[menuId]
                table.insert(menuItems[menuId], {
                    type = 'TEXT',
                    id = id,
                    label = text,
                    options = {
                        classes = classes
                    }
                })
            end,
            SubMenu = function(self, label, menu, options, openCb, closeCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('SUBMENU', options) then
                    return
                end
                if openCb == nil then
                    openCb = function(id, back)
                        _data:SubMenu(id, back)
                    end
                end
                cbs[menu.data.id .. '-open'] = openCb
                if closeCb ~= nil then
                    cbs[menu.data.id .. '-close'] = closeCb
                end

                table.insert(menuItems[menuId], {
                    type = 'SUBMENU',
                    id = menu.data.id,
                    label = label,
                    menu = menu.data.id,
                    options = options
                })
                submenus[menu.data.id] = menu.data
            end,
            SubMenuBack = function(self, label, options, selectCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('GOBACK', options) then
                    return
                end
                local id = menuId .. '-item' .. #menuItems[menuId]
                cbs[id] = selectCb
                table.insert(menuItems[menuId], {
                    type = 'GOBACK',
                    id = id,
                    label = label,
                    options = options
                })
            end,
            SuccessButton = function(self, label, options, selectCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('SUCCESSBUTTON', options) then
                    return
                end
                local id = menuId .. '-item' .. #menuItems[menuId]
                cbs[id] = selectCb
                table.insert(menuItems[menuId], {
                    type = 'SUCCESSBUTTON',
                    id = id,
                    label = label,
                    options = options
                })
            end
        }
        
        _data.Remove = function(self, id)
            for k, v in ipairs(self.data.items) do
                if v.id == id then
                    table.remove(self.data.items, k)
                    cbs[id] = nil
                    return
                end
            end
        end

        _data.Update = {
            Item = function(self, id, label, data)
                for k, v in ipairs(menuItems[menuId]) do
                    if v.id == id then
                        for k2, v2 in pairs(data) do
                            v.options[k2] = v2
                        end
                        v.label = label
                        _data.data.items = menuItems[menuId]
                        SendNUIMessage({
                            type = "UPDATE_MENU",
                            data = {
                                data = _data.data
                            }
                        })
                        return
                    end
                end
            end,
            Submenu = function(self, id, data)
                submenus[id] = data
            end
        }

        cbs[menuId .. '-open'] = function(id, back)
            _data:Show(back)
        end
        if closeCb ~= nil then
            cbs[menuId .. '-close'] = closeCb
        end

        return _data
    end
}