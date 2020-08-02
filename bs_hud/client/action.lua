ACTION = {
    Show = function(self, message, duration)
        SendNUIMessage({
            type = 'SHOW_ACTION',
            data = {
                message = message
            }
        })
    end,
    Hide = function(self)
        SendNUIMessage({
            type = 'HIDE_ACTION'
        })
    end
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Action', ACTION)
end)