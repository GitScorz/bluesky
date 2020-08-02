RegisterNetEvent('VehicleShop:Client:UpdateShowroom')
AddEventHandler('VehicleShop:Client:UpdateShowroom', function(tbl, dealer, spot, type)
    Dealers = tbl
    if curShowroom == dealer then
        if type == 'new' then
            SpawnShowroom(dealer, spot)        
        elseif type == 'remove' then
            RemoveShowroom(dealer, spot)
        elseif type == 'pos' then
            SpawnShowroom(dealer)
        else
            local vehSpot = GetVehInSpot(dealer, spot)
            if vehSpot then
                if spawned[spot].obj ~= 0 and DoesEntityExist(spawned[spot].obj) then
                    if type == 'color' then
                        Game.Vehicles:SetProperties(spawned[spot].obj, { ['dirtLevel'] = 0.0, ['color1'] = Dealers[curShowroom].showroom[vehSpot].props.color1, ['color2'] = Dealers[curShowroom].showroom[vehSpot].props.color2, ['pearlescentColor'] = 0 })
                    elseif type == 'price' then
                        spawned[spot].price = Dealers[curShowroom].showroom[vehSpot].price
                    elseif type == 'heading' then
                        SetEntityHeading(spawned[spot].obj, Dealers[dealer].showroom[vehSpot].h)
                    end
                end
            end
        end
    end
end)