function RemoveShowroom(dealer, spot)
    if dealer and spot then
        if curShowroom == dealer then
            if spawned[spot].obj ~= 0 and DoesEntityExist(spawned[spot].obj) then
                FreezeEntityPosition(spawned[spot].obj, false)
                SetEntityAsMissionEntity(spawned[spot].obj, true, true)
                DeleteEntity(spawned[spot].obj)
                spawned[spot] = { ['obj'] = 0, ['price'] = 0 }
            else
                local cV = GetClosestVehicle(Dealers[curShowroom].showroomSpots[spot].x, Dealers[curShowroom].showroomSpots[spot].y, Dealers[curShowroom].showroomSpots[spot].z, 2.0, 0, 71)
                if cV ~= nil and cV ~= 0 then
                    FreezeEntityPosition(cV, false)
                    SetEntityAsMissionEntity(cV, true, true)
                    DeleteEntity(cV)
                end
            end
        end
    else
        if #spawned > 0 then
            for k,v in pairs(spawned) do
                if v.obj ~= 0 and DoesEntityExist(v.obj) then
                    FreezeEntityPosition(v.obj, false)
                    SetEntityAsMissionEntity(v.obj, true, true)
                    DeleteEntity(v.obj)
                end
            end
            spawned = {}
        elseif curShowroom then
            for i = 1, #Dealers[curShowroom].showroomSpots do
                local cV = GetClosestVehicle(Dealers[curShowroom].showroomSpots[i].x, Dealers[curShowroom].showroomSpots[i].y, Dealers[curShowroom].showroomSpots[i].z, 2.0, 0, 71)
                if cV ~= nil and cV ~= 0 then
                    FreezeEntityPosition(cV, false)
                    SetEntityAsMissionEntity(cV, true, true)
                    DeleteEntity(cV)
                end
            end
        end
    end
    collectgarbage()
end

function SpawnShowroom(dealer, spot)
    if spot then
        RemoveShowroom(dealer, spot)
        local vehSpot = GetVehInSpot(dealer, spot)
        if vehSpot then
            local veh = Dealers[dealer].showroom[vehSpot]
            local vehProps = veh.props
            Game.Vehicles:SpawnLocal(Dealers[dealer].showroomSpots[spot], vehProps.model, veh.h, function(cbVeh)
                spawned[spot] = { ['obj'] = cbVeh, ['price'] = veh.price }
                SetVehicleOnGroundProperly(spawned[spot]["obj"])
                Wait(10)
                FreezeEntityPosition(spawned[spot]["obj"], true)
                SetEntityAsMissionEntity(spawned[spot]["obj"], true, true)
                Game.Vehicles:SetProperties(spawned[spot]["obj"], vehProps)
                SetVehicleDoorsLocked(spawned[spot]["obj"], 2)
            end)
        end
    else
        RemoveShowroom()
        curShowroom = dealer
        for i = 1, #Dealers[dealer].showroomSpots do
            local vehSpot = GetVehInSpot(dealer, i)
            if vehSpot then
                local veh = Dealers[dealer].showroom[vehSpot]
                local vehProps = veh.props
                Game.Vehicles:SpawnLocal(Dealers[dealer].showroomSpots[i], vehProps.model, veh.h, function(cbVeh)
                    spawned[i] = { ['obj'] = cbVeh, ['price'] = veh.price }
                    SetVehicleOnGroundProperly(spawned[i]["obj"])
                    Citizen.Wait(10)
                    FreezeEntityPosition(spawned[i]["obj"], true)
                    SetEntityAsMissionEntity(spawned[i]["obj"], true, true)
                    Game.Vehicles:SetProperties(spawned[i]["obj"], vehProps)
                    SetVehicleDoorsLocked(spawned[i]["obj"], 2)
                end)
            else
                spawned[i] = { ['obj'] = 0, ['price'] = 0 }
            end
        end
    end
end

function ManageShowroom()
    local menu = Menu:Create('manageShowroom', 'Manage Showroom')
    for i = 1, #Dealers[curShowroom].showroomSpots do
        local vehSpot = GetVehInSpot(curShowroom, i)
        if vehSpot then
            local veh = Dealers[curShowroom].showroom[vehSpot]
            menu.Add:AdvButton(veh.data.name, { secondaryLabel = "#"..i }, function(data)
                EditSpot(curShowroom, i)
            end)
        else
            menu.Add:Button('Empty', { success = true }, function(data)
                AddNewSpot(curShowroom, i)
            end)
        end
    end
    menu.Add:SubMenuBack('Back', {}, function()
        Wait(50)
        OpenDealerMenu()
    end)
    return menu
end

function AddNewSpot(dealer, spot)
    local tempTable = {}
    local menu = Menu:Create('addSpot'..spot, 'Add Vehicle to Showroom')
    for k,v in pairs(Vehicles) do
        if (Dealers[dealer].type == 'cars' and v.label ~= 'Motorcycles' and v.label ~= 'Custom Import') or (Dealers[dealer].type == 'bikes' and v.label == 'Motorcycles') or (Dealers[dealer].type == 'imports' and v.label == 'Custom Import') then
            table.insert(tempTable, { label = v.label, id = k })
        end
    end

    table.sort(tempTable, function(a,b) return a.label < b.label end)
    for k,v in ipairs(tempTable) do
        menu.Add:Button(v.label, {}, function(data)
            LoadCategory(v.id, menu, {dealer = dealer, spot = spot})
        end)
    end

    tempTable = {}
    collectgarbage()

    menu.Add:SubMenuBack('Back', {}, function()
        Wait(50)
        ManageShowroom():Show()
    end)

    menu:Show()
end

function EditSpot(dealer, spot)
    local vehSpot = GetVehInSpot(dealer, spot)
    local menu = Menu:Create('editSpot'..spot, 'Edit Showroom Spot #'..spot)
    if vehSpot then
        local veh = Dealers[curShowroom].showroom[vehSpot]
        menu.Add:AdvButton(veh.data.name, { secondaryLabel = "Model" }, function(data)
            
        end)
        local ccolors = {}
        local curColor

        for k,v in pairs(Config.AvailableColors) do
            table.insert(ccolors, { label = v.label, rgb = { r = v.index[1], g = v.index[2], b = v.index[3] }})
            if v.index[1] == veh.props.color1[1] and v.index[2] == veh.props.color1[2] and v.index[3] == veh.props.color1[3] then
                curColor = #ccolors
            end
        end
        if not curColor then curColor = 0 end
        menu.Add:ColorList({ disabled = false, current = curColor - 1, colors = ccolors}, function(data)
            local newColor = {}
            newColor[1] = data.data.color.rgb.r
            newColor[2] = data.data.color.rgb.g
            newColor[3] = data.data.color.rgb.b
            Dealers[dealer].showroom[vehSpot].props.color1 = newColor
            Dealers[dealer].showroom[vehSpot].props.color2 = newColor
            Callbacks:ServerCallback('VehicleShop:UpdateShowroom', {
                dealer = dealer,
                spot = spot,
                showroom = Dealers[dealer].showroom,
                type = 'color'
            }, function(s)
                if s then
                    Notification:Success('Color updated')
                end
            end)
        end)
        menu.Add:AdvButton('$'..veh.data.price, { secondaryLabel = "RRP" })
        menu.Add:Slider('Displayed Price: $'..veh.price, {
            disabled = false,
            min = math.floor(veh.data.price * ((100 - Dealers[dealer].bossSettings.Margin) / 100)),
            max = math.floor(veh.data.price * ((100 + Dealers[dealer].bossSettings.Margin) / 100)),
            current = veh.price,
            step = 1
        }, function(data)
            menu.Update:Item(data.id, 'Displayed Price: $'..data.data.value, {})
            Dealers[dealer].showroom[vehSpot].price = data.data.value
            Callbacks:ServerCallback('VehicleShop:UpdateShowroom', {
                dealer = dealer,
                spot = spot,
                showroom = Dealers[dealer].showroom,
                type = 'price'
            }, function(s)
                if s then
                    Notification:Success('Price updated')
                end
            end)
        end)
        
        menu.Add:Ticker('Spot', {
            disabled = false,
            min = 1,
            max = #Dealers[dealer].showroomSpots,
            current = spot
        }, function(data)
            local target = data.data.value
            local targetSpot = GetVehInSpot(dealer, target)
            if targetSpot then
                Dealers[dealer].showroom[targetSpot].spot = spot
            end
            Dealers[dealer].showroom[vehSpot].spot = target
            spot = target
            Callbacks:ServerCallback('VehicleShop:UpdateShowroom', {
                dealer = dealer,
                spot = spot,
                showroom = Dealers[dealer].showroom,
                type = 'pos'
            })
        end)

        menu.Add:Ticker('Rotation', {
            disabled = false,
            min = 0,
            max = 360,
            current = veh.h
        }, function(data)
            Dealers[dealer].showroom[vehSpot].h = data.data.value + 0.0
            Callbacks:ServerCallback('VehicleShop:UpdateShowroom', {
                dealer = dealer,
                spot = spot,
                showroom = Dealers[dealer].showroom,
                type = 'heading'
            })
        end)

        menu.Add:Button('Reset Rotation', {}, function(data)
            Dealers[dealer].showroom[vehSpot].h = Dealers[dealer].showroomSpots[spot].h
            Callbacks:ServerCallback('VehicleShop:UpdateShowroom', {
                dealer = dealer,
                spot = spot,
                showroom = Dealers[dealer].showroom,
                type = 'heading'
            })
        end)

        menu.Add:SubMenuBack('Remove', {}, function(data)
            Dealers[dealer].showroom[vehSpot] = nil
            Callbacks:ServerCallback('VehicleShop:UpdateShowroom', {
                dealer = dealer,
                spot = spot,
                showroom = Dealers[dealer].showroom,
                type = 'remove'
            }, function(s)
                if s then
                    Notification:Success('Vehicle removed from showroom spot #'..spot)
                end
                Wait(50)
                ManageShowroom():Show()
            end)
        end)
    end

    menu.Add:SubMenuBack('Back', {}, function()
        Wait(50)
        ManageShowroom():Show()
    end)
    menu:Show()
end