--[[
    All Credit To Frazzle for the basics of this script
    Source: https://github.com/FrazzIe/mumble-voip
]]--

AddEventHandler('Voip:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Logger = exports['bs_base']:FetchComponent('Logger')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Voip', {
        'Callbacks',
        'Logger',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        RegisterCallbacks()
    end)
end)

function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Voip:Init', function(source, data, cb)
        Logger:Trace('Voip', 'Initialised Player: ' .. source)
    
        if not _voice[source] then
            _voice[source] = {
                mode = 2,
                radio = 0,
                radioActive = false,
                call = 0,
                callSpeaker = false,
            }
        end
    
        TriggerClientEvent('Voip:Client:Sync', -1, _voice, _radio, _call)
    end)

    Callbacks:RegisterServerCallback('Voip:SetData', function(source, data, cb)
        if not _voice[source] then
            _voice[source] = {
                mode = 2,
                radio = 0,
                radioActive = false,
                call = 0,
                callSpeaker = false,
            }
        end
    
        local radioChannel = _voice[source]['radio']
        local callChannel = _voice[source]['call']
        local radioActive = _voice[source]['radioActive']
    
        if data.key == 'radio' and radioChannel ~= data.value then -- Check if channel has changed
            if radioChannel > 0 then -- Check if player was in a radio channel
                if _radio[radioChannel] then  -- Remove player from radio channel
                    if _radio[radioChannel][source] then
                        Logger:Trace('Voip', ('Player %s Was Removed From Radio Channel %s'):format(source, radioChannel))
                        _radio[radioChannel][source] = nil
                    end
                end
            end
    
            if data.value > 0 then
                if not _radio[data.value] then -- Create channel if it does not exist
                    Logger:Trace('Voip', ('Player %s Is Creating Channel %s'):format(source, data.value))
                    _radio[data.value] = {}
                end
                
                Logger:Trace('Voip', ('Player %s Was Added To Channel %s'):format(source, data.value))
                _radio[data.value][source] = true -- Add player to channel
            end
        elseif data.key == 'call' and callChannel ~= data.value then
            if callChannel > 0 then -- Check if player was in a call channel
                if _call[callChannel] then  -- Remove player from call channel
                    if _call[callChannel][source] then
                        Logger:Trace('Voip', ('Player %s Was Removed From Channel %s'):format(source, callChannel))
                        _call[callChannel][source] = nil
                    end
                end
            end
    
            if data.value > 0 then
                if not _call[data.value] then -- Create call if it does not exist
                    Logger:Trace('Voip', ('Player %s Is Creating Call %s'):format(source, data.value))
                    _call[data.value] = {}
                end
                
                Logger:Trace('Voip', ('Player %s Was Added To  Call %s'):format(source, data.value))
                _call[data.value][source] = true -- Add player to call
            end
        end
    
        _voice[source][data.key] = data.value
    
        Logger:Trace('Voip', ('Player %s Changed %s To %s'):format(source, data.key, tostring(data.value)))
    
        TriggerClientEvent('Voip:Client:SetData', -1, source, data.key, data.value)
    end)
end

RegisterCommand('mumbleRadioChannels', function(src, args, raw)
    for id, players in pairs(_radio) do
        for player, _ in pairs(players) do
            RconPrint('\x1b[32m[' .. resourceName .. ']\x1b[0m Channel ' .. id .. '-> id: ' .. player .. ', name: ' .. GetPlayerName(player) .. '\n')
        end
    end
end, true)

RegisterCommand('mumbleCallChannels', function(src, args, raw)
    for id, players in pairs(_call) do
        for player, _ in pairs(players) do
            RconPrint('\x1b[32m[' .. resourceName .. ']\x1b[0m Call ' .. id .. '-> id: ' .. player .. ', name: ' .. GetPlayerName(player) .. '\n')
        end
    end
end, true)

AddEventHandler('playerDropped', function()
    if _voice[source] then
        local radioChanged = false
        local callChanged = false

        if _voice[source].radio > 0 then
            if _radio[_voice[source].radio] ~= nil then
                _radio[_voice[source].radio][source] = nil
                radioChanged = true
            end
        end

        if _voice[source].call > 0 then
            if _call[_voice[source].call] ~= nil then
                _call[_voice[source].call][source] = nil
                callChanged = true
            end
        end

        _voice[source] = nil
        
        TriggerClientEvent('Voip:Client:RemoveData', -1, source)
    end
end)