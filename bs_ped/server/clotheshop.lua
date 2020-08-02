AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Clotheshop', CLOTHESHOP)
end)

RegisterServerEvent('Characters:Server:Spawn')
AddEventHandler('Characters:Server:Spawn', function()
    Clotheshop.Locations:Refresh(source)
end)

CLOTHESHOP = {
    Locations = {
        Refresh = function(source)
            Locations:GetAll('clotheshop', function(locations)
                TriggerClientEvent('Ped:Client:SetClothesShopLocations', source, locations)
            end)
        end
    }
}