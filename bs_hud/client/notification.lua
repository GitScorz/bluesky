Notification = {
    Clear = function(self)
        SendNUIMessage({
            type = 'CLEAR_ALERTS'
        })
    end,
    Success = function(self, message, duration)
        if duration == nil then
            duration = 2500
        end

        SendNUIMessage({
            type = 'SHOW_ALERT',
            data = {
                type = 'success',
                message = message,
                duration = duration
            }
        })
    end,
    Warn = function(self, message, duration)
        if duration == nil then
            duration = 2500
        end
        
        SendNUIMessage({
            type = 'SHOW_ALERT',
            data = {
                type = 'warn',
                message = message,
                duration = duration
            }
        })
    end,
    Error = function(self, message, duration)
        if duration == nil then
            duration = 2500
        end
        
        SendNUIMessage({
            type = 'SHOW_ALERT',
            data = {
                type = 'error',
                message = message,
                duration = duration
            }
        })
    end,
    Info = function(self, message, duration)
        if duration == nil then
            duration = 2500
        end
        
        SendNUIMessage({
            type = 'SHOW_ALERT',
            data = {
                type = 'info',
                message = message,
                duration = duration
            }
        })
    end,
    Standard = function(self, message, duration)
        if duration == nil then
            duration = 2500
        end
        
        SendNUIMessage({
            type = 'SHOW_ALERT',
            data = {
                type = 'standard',
                message = message,
                duration = duration
            }
        })
    end,
    Custom = function(self, message, duration, style)
        if duration == nil then
            duration = 2500
        end
        
        SendNUIMessage({
            type = 'SHOW_ALERT',
            data = {
                type = 'custom',
                message = message,
                duration = duration,
                style = style
            }
        })
    end,
    Persistent = {
        Success = function(self, id, message)
            SendNUIMessage({
                type = 'SHOW_PERSISTENT_ALERT',
                data = {
                    id = id,
                    type = 'success',
                    message = message
                }
            })
        end,
        Warn = function(self, id, message)
            SendNUIMessage({
                type = 'SHOW_PERSISTENT_ALERT',
                data = {
                    id = id,
                    type = 'warn',
                    message = message
                }
            })
        end,
        Error = function(self, id, message)
            SendNUIMessage({
                type = 'SHOW_PERSISTENT_ALERT',
                data = {
                    id = id,
                    type = 'error',
                    message = message
                }
            })
        end,
        Info = function(self, id, message)
            SendNUIMessage({
                type = 'SHOW_PERSISTENT_ALERT',
                data = {
                    id = id,
                    type = 'info',
                    message = message
                }
            })
        end,
        Standard = function(self, id, message)
            SendNUIMessage({
                type = 'SHOW_PERSISTENT_ALERT',
                data = {
                    id = id,
                    type = 'standard',
                    message = message
                }
            })
        end,
        Custom = function(self, id, message, style)
            SendNUIMessage({
                type = 'SHOW_PERSISTENT_ALERT',
                data = {
                    id = id,
                    type = 'custom',
                    message = message,
                    style = style
                }
            })
        end,
        Remove = function(self, id)
            SendNUIMessage({
                type = 'REMOVE_PERSISTENT_ALERT',
                data = {
                    id = id,
                }
            })
        end,
    }
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Notification', Notification)
end)