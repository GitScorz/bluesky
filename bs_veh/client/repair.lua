AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Repair', REPAIR)
end)

RegisterNetEvent('Vehicle:Client:SetRepairLocations')
AddEventHandler('Vehicle:Client:SetRepairLocations', function(locations)
    for k, v in pairs(locations) do
        local coords = vector3(v.Coords.x, v.Coords.y, v.Coords.z)
        Markers.MarkerGroups:Add(k .. '_repair', coords, Config.DrawDistance)
        Markers.Markers:Add(k .. '_repair', k .. '_repair_place', coords, 1, vector3(3, 3, 1), { r = 0, b = 255, g = 255 }, function()
            return IsPedInAnyVehicle(PlayerPedId())
        end, '[E] Repair Shop', function()
            local playerPed = PlayerPedId()
            if IsPedInAnyVehicle(playerPed) then
                local vehicle = GetVehiclePedIsIn(playerPed)
                SetEntityCoords(vehicle, coords)
                Repair:Show(vehicle)
            end
        end)
        Blips:Add(k .. '_repair', 'Repair Shop', coords, 446, 17, 0.8)
    end
end)

REPAIR = {
    Show = function(self, vehicle)
        local menu = Menu:Create('repair_menu', 'Repair Shop')
        menu.Add:Button('Repair', {}, function()
            Callbacks:ServerCallback('Vehicle:ChargeRepair', {}, function()
                Repair:Full(vehicle)
                Notification:SendAlert('Payed $' .. Config.RepairPrice .. ' for Repair')
            end)
            menu:Close()
        end)
        local colorMenu = Menu:Create('repair_color', 'Vehicle Color')
        colorMenu.Add:ColorPicker({ disabled = false, current = { r = 0, g = 0, b = 0 } }, function(data)
            local color = data.data.color
            Callbacks:ServerCallback('Vehicle:ChargeColor', {}, function()
                SetVehicleCustomPrimaryColour(vehicle, color.r, color.g, color.b)
                Notification:SendAlert('Payed $' .. Config.ColourChangePrice .. ' for Respray')
            end)
        end)
        colorMenu.Add:ColorPicker({ disabled = false, current = { r = 0, g = 0, b = 0 } }, function(data)
            local color = data.data.color
            Callbacks:ServerCallback('Vehicle:ChargeColor', {}, function()
                SetVehicleCustomSecondaryColour(vehicle, color.r, color.g, color.b)
                Notification:SendAlert('Payed $' .. Config.ColourChangePrice .. ' for Respray')
            end)
        end)
        colorMenu.Add:Button('Save', {}, function()
            colorMenu:Close()
        end)
        menu.Add:SubMenu('Color', colorMenu)
        menu:Show()
    end,
    Full = function(self, vehicle)
        SetVehicleFixed(vehicle)
    end
}