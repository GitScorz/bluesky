local _sCallbacks = {}
local _cCallbacks = {}

COMPONENTS.Callbacks = {
    _required = { 'RegisterServerCallback', 'DoServerCallback', 'ClientCallback' },
    _name = 'base',

    --- @param event string The event name of the callback.
    RegisterServerCallback = function(self, event, cb)
        _sCallbacks[event] = cb
    end,

    --- @param source number The source of the player.
    --- @param event string The event name of the callback.
    --- @param data any The arguments of the callback.
    --- @param extraId number The extra id of the callback.
    DoServerCallback = function(self, source, event, data, extraId)
        if _sCallbacks[event] ~= nil then
            Citizen.CreateThread(function()
                _sCallbacks[event](source, data, function(...)
                    TriggerClientEvent('Callbacks:Client:ReceiveCallback', source, event, extraId, ...)
                end)
            end)
        end
    end,
    
    --- @param source number The source of the player.
    --- @param event string The event name of the callback.
    --- @param data any The data to send.
    --- @param cb function The callback function.
    --- @param extraId number The extra id of the callback.
    ClientCallback = function(self, source, event, data, cb, extraId)
        if data == nil then data = {} end

        id = event
        if extraId ~= nil then
            id = event .. '-' .. extraId
        else
            extraId = ''
        end

        _cCallbacks[id] = cb
        TriggerClientEvent('Callbacks:Client:TriggerEvent', source, event, data, extraId)
    end
}

RegisterServerEvent('Callbacks:Server:TriggerEvent')
AddEventHandler('Callbacks:Server:TriggerEvent', function(token, event, data, extraId)
    if COMPONENTS.Pwnzor == nil or not COMPONENTS.Pwnzor.Tokenizer:Validate(token, source, GetCurrentResourceName()) then return end

    data = data or {}
    COMPONENTS.Callbacks:DoServerCallback(source, event, data, extraId)
end)

RegisterServerEvent('Callbacks:Server:ReceiveCallback')
AddEventHandler('Callbacks:Server:ReceiveCallback', function(token, event, extraId, ...)
    if COMPONENTS.Pwnzor == nil or not COMPONENTS.Pwnzor.Tokenizer:Validate(token, source, GetCurrentResourceName()) then return end
    local id = event
    if extraId ~= '' then
        id = event .. '-' .. extraId
    end

    if _cCallbacks[id] ~= nil then
        _cCallbacks[id](...)
        _cCallbacks[id] = nil
    end
end)