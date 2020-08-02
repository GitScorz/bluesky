RegisterNetEvent('Housing:Client:Add')
AddEventHandler('Housing:Client:Add', function(property)
    _properties[property.id] = property

    print(json.encode(_properties))
end)

RegisterNetEvent('Housing:Client:UpdateLock')
AddEventHandler('Housing:Client:UpdateLock', function(id, status)
    if _properties[id] ~= nil then
        _properties[id].locked = status
    end
end)

AddEventHandler('Characters:Client:Updated', function()
    _charData = exports['bs_base']:FetchComponent('Player').LocalPlayer:GetData('Character'):GetData()
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    if _houseObjects ~= nil then
        Interiors:Delete(_houseObjects)
        _houseObjects = nil
    end

    _loggedIn = false
    _charData = nil
end)

RegisterNetEvent('Housing:Client:CalcOffset')
AddEventHandler('Housing:Client:CalcOffset', function()
    if _houseObjects ~= nil then
        local shell = GetEntityCoords(_houseObjects[1]) -- Shell should always be the first object
        local ply = GetEntityCoords(PlayerPedId())
        local offset = { x = ( ply.x  - shell.x), y = ( ply.y - shell.y ), z = ( ply.z - shell.z ) }
        TriggerServerEvent('Housing:Server:LogOffset', offset)
    else
        Notification:Error('You Must Be In An Interior To Use This Command')
    end
end)