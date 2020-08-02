PHONE = {
    Open = function(self)
        _phoneOpen = true
        DisplayRadar(true)
        Hud:ShiftLocation(true)
        PhonePlayIn()
        SendNUIMessage({
            type = 'PHONE_VISIBLE'
        })
        SetNuiFocus(true, true)
    end,
    Close = function(self)
        _phoneOpen = false
        _openCd = true

        Phone:ResetRoute()

        SendNUIMessage({
            type = 'ALERTS_RESET'
        })

        if not IsPedInAnyVehicle(PlayerPedId(), true) then
            DisplayRadar(false)
        end
        Hud:ShiftLocation(false)

        if not Phone.Call:Status() then
            PhonePlayOut()
        end

        SetNuiFocus(false, false)
    end,
    IsOpen = function(self)
        return _phoneOpen
    end,
    ResetRoute = function(self)
        SendNUIMessage({
            type = 'CLEAR_HISTORY'
        })
    end,
    Data = {
        Set = function(self, key, data)
            SendNUIMessage({
                type = 'SET_DATA',
                data = { type = key, data = data }
            })
        end,
        Add = function(self, type, data, key)
            SendNUIMessage({
                type = 'ADD_DATA',
                data = { type = type, data = data, key = key }
            })
        end,
        Update = function(self, type, id, data)
            SendNUIMessage({
                type = 'UPDATE_DATA',
                data = { type = type, id = id, data = data }
            })
        end,
        Remove = function(self, key, id)
            SendNUIMessage({
                type = 'REMOVE_DATA',
                data = { type = key, id = id }
            })
        end,
        Reset = function(self)
            SendNUIMessage({
                type = 'RESET_DATA',
            })
        end,
    },
    Notification = {
        Add = function(self, app, data, text, icon, color, time, noBanner, soundData)
            SendNUIMessage({
                type = 'NOTIF_ADD',
                data = { noBanner = noBanner, notification = { text = text, icon = icon, color = color, time = time, app = app, app_data = data } }
            })
        
            if soundData ~= nil then
                Sounds.Play:Distance(10, soundData.sound, soundData.volume)
            end
        end,
        Reset = function(self)
            SendNUIMessage({
                type = 'NOTIF_DISMISS_ALL'
            })
        end,
    }
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Phone', PHONE)
end)

RegisterNetEvent('Phone:Client:Close')
AddEventHandler('Phone:Client:Close', function()
    Phone:Close()
end)

RegisterNUICallback('ClosePhone', function(data, cb)
    Phone:Close()
end)

RegisterNetEvent('Phone:Client:Notifications:Add')
AddEventHandler('Phone:Client:Notifications:Add', function(app, data, text, icon, color, time, noBanner, soundData)
    Phone.Notification:Add(app, data, text, icon, color, time, noBanner, soundData)
end)