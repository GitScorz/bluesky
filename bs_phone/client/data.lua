RegisterNetEvent('Phone:Client:SetData')
AddEventHandler('Phone:Client:SetData', function(type, data, options)
    Phone.Data:Set(type, data)
end)

RegisterNetEvent('Phone:Client:AddData')
AddEventHandler('Phone:Client:AddData', function(type, data, id)
    Phone.Data:Add(type, data, id)
end)

RegisterNetEvent('Phone:Client:UpdateData')
AddEventHandler('Phone:Client:UpdateData', function(type, id, data)
    Phone.Data:Update(type, id, data)
end)

RegisterNetEvent('Phone:Client:RemoveData')
AddEventHandler('Phone:Client:RemoveData', function(type, id)
    Phone.Data:Remove(type, id)
end)

RegisterNetEvent('Phone:Client:ResetData')
AddEventHandler('Phone:Client:ResetData', function()
    Phone.Data:Reset()
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    SendNUIMessage({
        type = 'PHONE_NOT_VISIBLE'
    })
    Phone.Data:Reset()
    Phone.Notification:Reset()
    Phone:ResetRoute()
end)