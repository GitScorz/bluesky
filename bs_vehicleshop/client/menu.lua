local prevChosen

function OpenDealerMenu()
    if displayedVeh and displayedVeh ~= 0 then
        NetworkRequestControlOfEntity(displayedVeh)
    end

    local menu = Menu:Create('dealerMenu', 'Dealership Menu', function() end, function()
        menu = {}
        collectgarbage()
    end)
    menu.Add:SubMenu('Display Vehicles', DisplayVehicles(menu))

    if chosenVehicle then
        menu.Add:SubMenu('Sell ' .. chosenVehicle.name, PreSale())
    end

    menu.Add:SubMenu('Manage Showroom', ManageShowroom())

    menu:Show()
end

function RemoveDisplay(showroom)
    if displayedVeh then 
        FreezeEntityPosition(displayedVeh, false)
        SetEntityAsMissionEntity(displayedVeh, true, true)
        DeleteEntity(displayedVeh)
    else
        local cV = GetClosestVehicle(Dealers[curShowroom].coords.display.x, Dealers[curShowroom].coords.display.y, Dealers[curShowroom].coords.display.z, 2.0, 0, 71)
        if cV ~= nil and cV ~= 0 then
            FreezeEntityPosition(cV, false)
            SetEntityAsMissionEntity(cV, true, true)
            DeleteEntity(cV)
        end
    end
    displayedVeh = 0
    chosenVehicle = false
end

function DisplayVehicles(mainMenu, showroom)
    local tempTable = {}
    local menu = Menu:Create('displayVehs', 'Select a category')
    menu.Add:SubMenuBack('None', {}, function()
        RemoveDisplay(showroom)
        Wait(50)
        if not showroom then
            if prevChosen ~= chosenVehicle then
                prevChosen = chosenVehicle
                mainMenu:Close()
            end
            OpenDealerMenu()
        else
            ManageShowroom():Show()
        end
    end)
    
    for k,v in pairs(Vehicles) do
        if (Dealers[curShowroom].type == 'cars' and v.label ~= 'Motorcycles' and v.label ~= 'Custom Import') or (Dealers[curShowroom].type == 'bikes' and v.label == 'Motorcycles') or (Dealers[curShowroom].type == 'imports' and v.label == 'Custom Import') then
            table.insert(tempTable, { label = v.label, id = k })
        end
    end

    table.sort(tempTable, function(a,b) return a.label < b.label end)
    for k,v in ipairs(tempTable) do
        menu.Add:Button(v.label, {}, function(data)
            LoadCategory(v.id, mainMenu, showroom)
        end)
    end

    tempTable = {}
    collectgarbage()

    menu.Add:SubMenuBack('Back', {}, function()
        Wait(50)
        if not showroom then
            if prevChosen ~= chosenVehicle then
                prevChosen = chosenVehicle
                mainMenu:Close()
            end
            OpenDealerMenu()
        else
            ManageShowroom():Show()
        end
    end)
    return menu
end

function LoadCategory(cat, mm, showroom)
    local tempTable = {}
    local menu = Menu:Create(Vehicles[cat].name, Vehicles[cat].label, function() end, function()
        if picked and picked.obj then DeleteEntity(picked.obj) end
    end)
    for k,v in pairs(Vehicles[cat].vehicles) do
        table.insert(tempTable, v)
    end
    table.sort(tempTable, function(a,b) return a.price < b.price end)
    for k,v in pairs(tempTable) do
        menu.Add:AdvButton(v.name, { secondaryLabel = "$" .. v.price }, function(data)
            SelectThis(v, showroom)
        end)
    end
    tempTable = {}
    collectgarbage()

    menu.Add:SubMenuBack('Back', {}, function(data)
        Wait(50)
        if showroom then
            if picked and picked.data then
                Callbacks:ServerCallback('VehicleShop:RegisterSpot', picked, function(success)
                    picked = nil
                    AddNewSpot(showroom.dealer, showroom.spot)
                end)
            else
                AddNewSpot(showroom.dealer, showroom.spot)
            end
        else
            DisplayVehicles(mm):Show()
        end

    end)
    menu:Show()
end

function PreSale()
    local menu = Menu:Create('preSale', 'Sell Vehicle')
    local ccolors = {}
    local curColor

    for k,v in pairs(Config.AvailableColors) do
        table.insert(ccolors, { label = v.label, rgb = { r = v.index[1], g = v.index[2], b = v.index[3] }})
        if v.index[1] == chosenVehicle.color[1] and v.index[2] == chosenVehicle.color[2] and v.index[3] == chosenVehicle.color[3] then
            curColor = #ccolors
        end
    end

    menu.Add:ColorList({ disabled = false, current = curColor - 1, colors = ccolors}, function(data)
        chosenVehicle.color[1] = data.data.color.rgb.r
        chosenVehicle.color[2] = data.data.color.rgb.g
        chosenVehicle.color[3] = data.data.color.rgb.b
        Game.Vehicles:SetProperties(displayedVeh, { ['dirtLevel'] = 0.0, ['color1'] = chosenVehicle.color, ['color2'] = chosenVehicle.color, ['pearlescentColor'] = 0 })
    end)

    menu.Add:Slider('Price: $'..chosenVehicle.price, {
        disabled = false,
        min = math.floor(chosenVehicle.defaultPrice * ((100 - Dealers[curShowroom].bossSettings.Margin) / 100)),
        max = math.floor(chosenVehicle.defaultPrice * ((100 + Dealers[curShowroom].bossSettings.Margin) / 100)),
        current = chosenVehicle.price,
        step = 1
    }, function(data)
        menu.Update:Item(data.id, 'Price: $'..data.data.value, {})
        chosenVehicle.price = data.data.value
    end)

    local myId = GetPlayerServerId(PlayerId())
    local nearbyPlayers = {}
    table.insert(nearbyPlayers, { label = "Self", value = myId, data = { props = Game.Vehicles:GetProperties(displayedVeh), veh = chosenVehicle, target = myId, dealer = myId } })
    table.insert(nearbyPlayers, { label = "Self", value = 2, data = { props = Game.Vehicles:GetProperties(displayedVeh), veh = chosenVehicle, target = myId, dealer = myId } })

    --[[ local closestPlayer, closestDistance = GetClosestPlayer()
    if closestDistance <= 3.0 and closestPlayer ~= -1 then
        local targetId = GetPlayerServerId(closestPlayer.id)
        Callbacks.ServerCallback('VehicleShop:GetNearbyName', {
            sid = targetId
        }, function(name)
            table.insert(nearbyPlayers, { label = name, value = targetId, data = { props = Game.Vehicles:GetProperties(displayedVeh), veh = chosenVehicle, target = targetId, dealer = myId } })
        end)
    end ]]

    menu.Add:Select('Buyer', {
        disabled = false,
        current = 1,
        list = nearbyPlayers
    }, function(data)
        Utils:Print(data)
    end)

    menu.Add:SubMenuBack('Back')
    return menu
end

function SelectThis(data, showroom)
    local useCoords = (showroom and Dealers[showroom.dealer].showroomSpots[showroom.spot] or Dealers[curShowroom].coords.display)
    if displayedVeh and not showroom then 
        FreezeEntityPosition(displayedVeh, false)
        SetEntityAsMissionEntity(displayedVeh, true, true)
        DeleteEntity(displayedVeh)
    else
        local cV = GetClosestVehicle(useCoords.x, useCoords.y, useCoords.z, 3.0, 0, 71)
        if cV ~= nil and cV ~= 0 then
            FreezeEntityPosition(cV, false)
            SetEntityAsMissionEntity(cV, true, true)
            DeleteEntity(cV)
        end
    end
    if showroom then
        Game.Vehicles:SpawnLocal(useCoords, data.model, useCoords.h, function(cbVeh)
            SetVehicleOnGroundProperly(cbVeh)
            FreezeEntityPosition(cbVeh, true)
            SetEntityAsMissionEntity(cbVeh, true, true)
            SetVehicleDoorsLocked(cbVeh, 2)
            local color = Config.AvailableColors[math.random(1, #Config.AvailableColors)].index
            Game.Vehicles:SetProperties(cbVeh, { ['dirtLevel'] = 0.0, ['color1'] = color, ['color2'] = color })
            local vehProps = Game.Vehicles:GetProperties(cbVeh)
            picked = { data = data, showroom = showroom, props = vehProps, obj = cbVeh }
        end)
    else
        Game.Vehicles:Spawn(useCoords, data.model, useCoords.h, function(veh)
            displayedVeh = veh
            local displayedNet = VehToNet(displayedVeh)
            SetNetworkIdExistsOnAllMachines(displayedNet, true)
            SetNetworkIdCanMigrate(displayedNet, true)
            FreezeEntityPosition(displayedVeh, true)
            SetEntityAsMissionEntity(displayedVeh, true, true)
            SetVehicleDoorsLocked(displayedVeh, 2)
            SetVehicleDoorsLockedForAllPlayers(displayedVeh, true)
            chosenVehicle = data
            chosenVehicle.defaultPrice = data.price
            chosenVehicle.color = Config.AvailableColors[math.random(1, #Config.AvailableColors)].index
            Game.Vehicles:SetProperties(displayedVeh, { ['dirtLevel'] = 0.0, ['color1'] = chosenVehicle.color, ['color2'] = chosenVehicle.color, ['pearlescentColor'] = 0 })
        end)
    end
end