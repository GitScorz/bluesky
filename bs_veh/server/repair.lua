RegisterServerEvent('Characters:Server:Spawn')
AddEventHandler('Characters:Server:Spawn', function()
    Repair.Locations:Refresh(source)
end)

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Repair', REPAIR)
end)

function RegisterChatCommands()

end

REPAIR = {
    Locations = {
        Refresh = function(self, source)
            Locations:GetAll('repair', function(locations)
                TriggerClientEvent('Vehicle:Client:SetRepairLocations', source, locations)
            end)
        end
    }
}