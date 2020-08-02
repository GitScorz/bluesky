_voice = {}
_radio = {}
_call = {}
resourceName = GetCurrentResourceName()

VOIP = {
    GetPlayersInRadioChannel = function(self, channel)
        local channel = tonumber(channel)
        local players = false
    
        if channel ~= nil then
            if _radio[channel] ~= nil then
                players = _radio[channel]
            end
        end
    
        return players
    end,
    GetPlayersInRadioChannels = function(self, ...)
        local channels = { ... }
        local players = {}

        for i = 1, #channels do
            local channel = tonumber(channels[i])

            if channel ~= nil then
                if _radio[channel] ~= nil then
                    players[#players + 1] = _radio[channel]
                end
            end
        end

        return players
    end,
    GetPlayersInAllRadioChannels = function(self)
        return _radio
    end,
    GetPlayersInPlayerRadioChannel = function(self, serverId)
        local players = false
    
        if serverId ~= nil then
            if _voice[serverId] ~= nil then
                local channel = _voice[serverId].radio
                if channel > 0 then
                    if _radio[channel] ~= nil then
                        players = _radio[channel]
                    end
                end
            end
        end
    
        return players
    end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Voip', VOIP)
end)