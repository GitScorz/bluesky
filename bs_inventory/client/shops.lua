Shops = {}
showingMarker = false
GLOBAL_PED, GLOBAL_COORDS = nil, nil
_isLoggedIn = false


function startShopsTick()
    
    local function showingKeys(k)
        Citizen.CreateThread(function()
            while showingMarker do
                if IsControlJustPressed(0, 38) then
                    TriggerServerEvent('Inventory:Server:openShop', k)
                end
                Citizen.Wait(1)
            end
        end)
    end

    Citizen.CreateThread(function()
        while _isLoggedIn do
            if GLOBAL_COORDS ~= nil then
                for k, v in pairs(Shops) do
                    local distance = #(GLOBAL_COORDS - vector3(v.shop_coords.x, v.shop_coords.y, v.shop_coords.z))
                    if distance < 5.0 then
                        if distance < 1.0 then
                            if not showingMarker then
                                showingMarker = k
                                Action:Show("Press {key}E{/key}")
                                showingKeys(k)
                            end
                        else
                            if showingMarker == k then
                                showingMarker = false
                                Action:Hide()
                            end
                        end
                        DrawMarker(25, v.shop_coords.x, v.shop_coords.y, v.shop_coords.z - 0.98, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 1.0, 139, 16, 20, 250, false, false, 2, false, false, false, false)
                    end
                end
            end
            Citizen.Wait(5)
        end
    end)
end