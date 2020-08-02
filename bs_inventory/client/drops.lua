DropZones = {}

RegisterNUICallback('DropItem', function(data, cb)
    Callbacks:ServerCallback('Inventory:Server:DropItem', data, function(meh)
        if meh then
            Callbacks:ServerCallback('Inventory:GetPlayerInventory', {}, function(inventory)
                Inventory.Set.Secondary:Refresh()
                Inventory.Set.Player:Inventory(inventory)
            end)
        end
    end)
end)

RegisterNetEvent('Inventory:Client:ProcessDropzone')
AddEventHandler('Inventory:Client:ProcessDropzone', function(action, id, data)
    if action == "add" then
        DropZones[id] = data
    else
        DropZones[id] = nil
    end
end)

function startDropsTick()

    Citizen.CreateThread(function()
        while _isLoggedIn do
            if GLOBAL_COORDS ~= nil then
                for k, v in pairs(DropZones) do
                    local distance = #(GLOBAL_COORDS - vector3(v.x, v.y, v.z))
                    if distance < 20.0 then
                        DrawMarker(25, v.x, v.y, v.z - 0.98, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 1.0, 139, 16, 20, 250, false, false, 2, false, false, false, false)
                    end
                end
            end
            Citizen.Wait(5)
        end
    end)
    
end