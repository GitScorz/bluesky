local _adverts = {
    ['0'] = {} -- Lua, Suck My Dick
}

PHONE.Adverts = {
    Create = function(self, source, advert)
        _adverts[source] = advert
        TriggerClientEvent('Phone:Client:AddData', -1, 'adverts', advert, source)
    end,
    Update = function(self, source, advert)
        _adverts[source] = advert
        TriggerClientEvent('Phone:Client:UpdateData', -1, 'adverts', source, advert)
    end,
    Delete = function(self, source)
        if _adverts[source] ~= nil then
            _adverts[source] = nil
            TriggerClientEvent('Phone:Client:RemoveData', -1, 'adverts', source)
        end
    end,
}

RegisterServerEvent('Characters:Server:Spawn')
AddEventHandler('Characters:Server:Spawn', function()
    local src = source
    TriggerClientEvent('Phone:Client:SetData', src, 'adverts', _adverts)
end)

AddEventHandler('Phone:Server:RegisterCallbacks', function()
    Callbacks:RegisterServerCallback('Phone:Adverts:Create', function(source, data, cb)
        Phone.Adverts:Create(source, data)
    end)

    Callbacks:RegisterServerCallback('Phone:Adverts:Update', function(source, data, cb)
        Phone.Adverts:Update(source, data)
    end)

    Callbacks:RegisterServerCallback('Phone:Adverts:Delete', function(source, data, cb)
        Phone.Adverts:Delete(source)
    end)
end)

RegisterServerEvent('Phone:Server:RegisterMiddleware')
AddEventHandler('Phone:Server:RegisterMiddleware', function()
    Middleware:Add('Characters:Logout', function(source)
        Phone.Adverts:Delete(source)
    end)

    Middleware:Add('playerDropped', function(source, message)
        Phone.Adverts:Delete(source)
    end)
end)