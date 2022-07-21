local menuOpen = false
local noClip = false
local showCoords = false
local loggedIn = false

local noClipIndex = 1 -- [[Used to determine the index of the speeds table.]]
local noclipEntity = nil

local config = {
	controls = {
		-- [[Controls, list can be found here : https://docs.fivem.net/game-references/controls/]]
		openKey = 288, -- [[F2]]
		goUp = 85, -- [[Q]]
		goDown = 48, -- [[Z]]
		turnLeft = 34, -- [[A]]
		turnRight = 35, -- [[D]]
		goForward = 32,  -- [[W]]
		goBackward = 33, -- [[S]]
		changeSpeed = 21, -- [[L-Shift]]
	},

    speeds = {
            -- [[If you wish to change the speeds or labels there are associated with then here is the place.]]
            { label = "Very Slow", speed = 0},
            { label = "Slow", speed = 0.5},
            { label = "Normal", speed = 2},
            { label = "Fast", speed = 4},
            { label = "Very Fast", speed = 6},
            { label = "Extremely Fast", speed = 10},
            { label = "Extremely Fast v2.0", speed = 20},
            { label = "Max Speed", speed = 25}
        },

    offsets = {
            y = 0.5, -- [[How much distance you move forward and backward while the respective button is pressed]]
            z = 0.2, -- [[How much distance you move upward and downward while the respective button is pressed]]
            h = 3, -- [[How much you rotate. ]]
        },

        -- [[Background colour of the buttons. (It may be the standard black on first opening, just re-opening.)]]
    bgR = 0, -- [[Red]]
    bgG = 0, -- [[Green]]
    bgB = 0, -- [[Blue]]
    bgA = 80, -- [[Alpha]]
}

local FormatCoord = function(coord)
	if coord == nil then
		return "unknown"
	end 

	return tonumber(string.format("%.2f", coord))
end

function DrawGenericText(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(7)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.40, 0.00)
end

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Admin', ADMIN)
end)

AddEventHandler('Admin:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Utils = exports['bs_base']:FetchComponent('Utils')
    Logger = exports['bs_base']:FetchComponent('Logger')
    Menu = exports['bs_base']:FetchComponent('Menu')
    Notification = exports['bs_base']:FetchComponent('Notification')
    Status = exports['bs_base']:FetchComponent('Status')
    Admin = exports['bs_base']:FetchComponent('Admin')
    Jobs = exports['bs_base']:FetchComponent('Jobs')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Admin', {
        'Callbacks',
        'Utils',
        'Logger',
        'Menu',
        'Notification',
        'Status',
        'Admin',
        'Jobs',
    }, function(error)  
        if #error > 0 then return; end
        RetrieveComponents()
    end)
end)

ADMIN = {
    openMenu = function(self) 
        doAdminMenuToggle()
    end,
    getSettings = function(self)
        return { ['needs'] = enableNeeds, ['noclip'] = noClip, ['coords'] = showCoords, ['menuOpen'] = menuOpen }
    end
}

AddEventHandler('Characters:Client:Spawn', function()
    noClip = false
    showCoords = false
    loggedIn = true
    startAdminTick()
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    loggedIn = false
    noClip = false
    showCoords = false
end)

RegisterNetEvent('Admin:noclip:fromServer')
AddEventHandler('Admin:noclip:fromServer', function()
    Callbacks:ServerCallback('Commands:ValidateAdmin', {}, function(isAdmin)
        if isAdmin then
            noClip = not noClip
            TriggerEvent('Admin:noclip')
        end
    end)
end)

RegisterNetEvent('Admin:Revive:Client:WithinRange')
AddEventHandler('Admin:Revive:Client:WithinRange', function(coords)
    local myPed = PlayerPedId()
    if IsPedFatallyInjured(myPed) then
        local playerCoords = GetEntityCoords(myPed)
        local distance = #(vector3(coords.x, coords.y, coords.z) - vector3(playerCoords.x, playerCoords.y, playerCoords.z))
        if distance < 25.0 then
            TriggerServerEvent('Damage:Admin:HealSource')
        end
    end
end)

RegisterNetEvent('Admin:Revive:Client:All')
AddEventHandler('Admin:Revive:Client:All', function()
    local myPed = PlayerPedId()
    if IsPedFatallyInjured(myPed) then
        TriggerServerEvent('Damage:Admin:HealSource')
    end
end)

function doAdminMenuToggle()
    Callbacks:ServerCallback('Commands:ValidateAdmin', {}, function(isAdmin)
        if isAdmin and not menuOpen then
            Callbacks:ServerCallback('Admin:receiveRecentDisconnects', {}, function(recentDisconnectsData)
                Callbacks:ServerCallback('Admin:receiveActivePlayers', {}, function(activePlayersData)
                    Callbacks:ServerCallback('Admin:receiveSpawnLocations', {}, function(spawnLocations)
                        if noClip then
                            noClip = false
                            TriggerEvent('Admin:noclip')
                        end

                        local x, y, z = nil, nil, nil
                        local spawnVeh, spawnProp = "nismo20", nil

                        local root = Menu:Create('adminMenu', 'Admin Menu', function(id, back)
                            menuOpen = true
                        end, function()
                            menuOpen = false
                        end)

                        local recentDisconnects = Menu:Create('recentDisconnects', 'Recent Disconnects')
                        local activePlayers = Menu:Create('activePlayers', 'Active Players')
                        local teleportTo = Menu:Create('teleportTo', 'Teleport Management')
                        local tpToCoords = Menu:Create('tpToCoords', 'Manual Teleport')
                        local spawnLoc = Menu:Create('spawnLoc', 'Spawn Location')
                        local spawnMenu = Menu:Create('spawnMenu', 'Entity Management')
                        local vehicleManagement = Menu:Create('vehicleManagement', 'Vehicle Management')
                        teleportTo.Add:SubMenu('Manual Teleport', tpToCoords)
                        teleportTo.Add:SubMenu('Spawn Location', spawnLoc)
                        spawnMenu.Add:SubMenu('Vehicle Management', vehicleManagement)

                        -- Primary Submenus
                        local reviveSettings = Menu:Create('reviveManagement', 'Revive Management')
                        local playerIdenter = nil

                        reviveSettings.Add:Number('Player ID', {
                            disabled = false,
                            current = nil,
                        }, function(data)
                            playerIdenter = tonumber(data.data.value)
                        end)

                        reviveSettings.Add:Button('Revive by ServerID', {}, function(data)
                            if tonumber(playerIdenter) and tonumber(playerIdenter) > 0 then
                                TriggerServerEvent('Admin:Revive:Player', tonumber(playerIdenter))
                                playerIdenter = nil
                                root.Close()
                            end
                        end)
                        
                        reviveSettings.Add:Button('Revive All In Range', {}, function(data)
                            TriggerServerEvent('Admin:Revive:WithinRange', GetEntityCoords(PlayerPedId()))
                            root.Close()
                        end)

                        reviveSettings.Add:Button('Revive All On Server', {}, function(data)
                            TriggerServerEvent('Admin:Revive:All')
                            root.Close()
                        end)

                        reviveSettings.Add:SubMenuBack('Back')

                        local playerManagement = Menu:Create('playerManagement', 'Player Management')
                        playerManagement.Add:SubMenu('Active Players', activePlayers)
                        playerManagement.Add:SubMenu('Recent Disconnects', recentDisconnects)
                        playerManagement.Add:SubMenuBack('Back')

                        local adminUtilities = Menu:Create('adminUtilities', 'Developer Utilities')

                        adminUtilities.Add:Button("Toggle Job Duty", { }, function(data)
                            TriggerServerEvent('Admin:server:toggleDuty')
                            root:Close()
                        end)

                        adminUtilities.Add:Button((noClip and "Disable NoClip" or "Enable NoClip"), { disabled = false, success = noClip }, function(data)
                            noClip = not noClip
                            TriggerEvent('Admin:noclip')
                            Notification:Info('NoClip has been: '..(noClip and "Enabled" or "Disabled"), 2500)
                            adminUtilities.Update:Item(data.id, (noClip and "Disable NoClip" or "Enable NoClip"), { success = noClip })
                            root.Close()
                        end)

                        adminUtilities.Add:Button((showCoords and "Disable Coords" or "Enable Coords"), { disabled = false, success = showCoords }, function(data)
                            showCoords = not showCoords
                            Notification:Info('Coordinates have been '..(showCoords and "Enabled" or "Disabled"), 3500)
                            Citizen.CreateThread(function()
                                while showCoords do
                                    local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId()))
                                    local playerH = GetEntityHeading(GLOBAL_PED)
                                    DrawGenericText(("~g~X~w~: %s ~g~Y~w~: %s ~g~Z~w~: %s ~g~H~w~: %s"):format(FormatCoord(playerX), FormatCoord(playerY), FormatCoord(playerZ), FormatCoord(playerH)))                
                                    Citizen.Wait(1)
                                end
                            end)
                            adminUtilities.Update:Item(data.id, (showCoords and "Disable Coords" or "Enable Coords"), { success = showCoords })
                        end)

                        adminUtilities.Add:Button((Status:Check() and "Needs Enabled" or "Needs Disabled"), { disabled = false, success = Status:Check() }, function(data)
                            Status:Toggle()
                            Notification:Info('Needs have been '..(Status:Check() and "Enabled" or "Disabled"), 3500) 
                            adminUtilities.Update:Item(data.id, (Status:Check() and "Needs Enabled" or "Needs Disabled"), { success = Status:Check() })
                        end)
                        adminUtilities.Add:Button("Reset Needs", { disabled = false, success = true }, function(data)
                            TriggerEvent('Status:Client:Reset')
                            Notification:Info('Needs have been Reset', 3500)
                        end)
                        
                        if recentDisconnectsData ~= nil then
                            local found = false
                            for k, v in pairs(recentDisconnectsData) do
                                found = true
                                v.menu = Menu:Create('player'..v.source, 'Player: '..v.source..' | '..v.name)
                                recentDisconnects.Add:SubMenu('['..v.source..'] '..v.name, v.menu)
                                
                                v.menu.Add:Button('Name: '..v.name, { disabled = true }, function(data)
                                    
                                end)

                                v.menu.Add:Button('Source: '..v.source, { disabled = true }, function(data)
                                    
                                end)

                                if v.cid then
                                    v.menu.Add:Button('CID: '..v.cid, { disabled = true }, function(data)
                                    
                                    end)
                                end 

                                v.menu.Add:Button('SID: '..v.sid, { disabled = true }, function(data)
                                    
                                end)

                                v.menu.Add:Text('Disconnect Reason<br>'..v.reason, { 'pad', 'textLarge', 'center' })
                                
                                
                                v.menu.Add:SubMenuBack('Back')
                            end

                            if not found then
                                recentDisconnects.Add:Button("No Recent Disconnects", { disabled = true }, function(data)
                                
                                end)
                            end
                        end
                        
                        if activePlayersData ~= nil then
                            local found = false
                            for t, q in pairs(activePlayersData) do
                                found = true
                                q.menu = Menu:Create('player'..q.source, 'Player: '..q.source..' | '..q.name)
                                q.subMenu = Menu:Create('player'..q.source..'subMenu', 'More Info - ['..q.source..'] '..q.name)
                                q.banMenu = Menu:Create('player'..q.source..'banMenu', 'Ban Menu - ['..q.source..'] '..q.name)
                                q.kickMenu = Menu:Create('player'..q.source..'kickMenu', 'Kick Menu - ['..q.source..'] '..q.name)
                                activePlayers.Add:SubMenu('['..q.source..'] '..q.name, q.menu)
                                q.menu.Add:SubMenu('Player Information', q.subMenu)
                                
                                -- Player SubMenu
                                
                                q.subMenu.Add:Button('Name: '..q.name, { disabled = true }, function(data)
                                    
                                end)

                                q.subMenu.Add:Button('Source: '..q.source, { disabled = true }, function(data)
                                    
                                end)

                                if q.cid then
                                    q.subMenu.Add:Button('CID: '..q.cid, { disabled = true }, function(data)
                                    
                                    end)
                                end 

                                q.subMenu.Add:Button('SID: '..q.sid, { disabled = true }, function(data)
                                    
                                end)

                                q.menu.Add:Button("Goto Player", { disabled = false }, function(data)
                                    local sourcePed = GetPlayerPed(GetPlayerFromServerId(q.source))
                                    local sourceCoords = GetEntityCoords(sourcePed)
                                    SetEntityCoords(PlayerPedId(), sourceCoords.x, sourceCoords.y, sourceCoords.z)
                                    root.Close()
                                end)
                                
                                q.menu.Add:Button("Bring Player", { disabled = false }, function(data)
                                    local myCoords = GetEntityCoords(PlayerPedId())
                                    SetEntityCoords(GetPlayerPed(GetPlayerFromServerId(q.source)), myCoords.x, myCoords.y, myCoords.z)
                                    root.Close()
                                end)
                                
                                q.menu.Add:SubMenu('Kick Player', q.kickMenu)
                                
                                -- Kick Menu
                                local kickReason = nil
                                q.kickMenu.Add:Input('Kick Reason', {
                                    disabled = false,
                                    max = 255,
                                    current = nil,
                                }, function(data)
                                    kickReason = data.data.value
                                end)
                                
                                q.kickMenu.Add:Button("Kick Player", { disabled = false, success = true }, function(data)
                                    if kickReason then
                                        TriggerServerEvent('Admin:server:kickPlayer', q.source, kickReason)
                                        kickReason = nil
                                        root.Close()
                                    else
                                        Notification:Error('Please state a reason for kicking '..q.name, 3500)
                                    end
                                end)

                                -- Ban Menu
                                local banReason, banTime = nil, -2
                                q.banMenu.Add:Input('Ban Reason', {
                                    disabled = false,
                                    max = 255,
                                    current = nil,
                                }, function(data)
                                    banReason = data.data.value
                                end)
                                
                                

                                q.banMenu.Add:Select('Ban Length', {
                                    disabled = false,
                                    current = -2,
                                    list = {
                                        { label = 'Select Length', value = -2, disabled = true },
                                        { label = 'Permanent Ban', value = -1 },
                                        { label = '1 Day', value = 1 },
                                        { label = '2 Days', value = 2 },
                                        { label = '1 Week', value = 7 },
                                        { label = '2 Weeks', value = 14 },
                                        { label = '1 Month', value = 30 },
                                    }
                                }, function(data)
                                    banTime = data.data.value
                                end)

                                q.banMenu.Add:Button("Ban Player", { disabled = false, success = true }, function(data)
                                    if banReason and banTime and banTime > -2 then
                                        local lengthName
                                        if banTime == 1 or banTime == 2 then
                                            lengthName = (banTime == 1 and "1 day" or "2 days")
                                        elseif banTime == 7 or banTime == 14 then
                                            lengthName = (banTime == 7 and "1 week" or "2 weeks")
                                        else
                                            lengthName = "1 month"
                                        end
                                        TriggerServerEvent('Admin:server:banPlayer', q.source, banTime, banReason)
                                        banTime, banReason = nil, nil
                                        Notification:Success(q.name..' has been banned from the server '..(banTime == -1 and "permanently" or "for "..lengthName), 3500)
                                        root.Close()
                                    else
                                        Notification:Error('You need to complete all the required information', 3500)
                                    end
                                end)
                                
                                q.menu.Add:SubMenu('Ban Player', q.banMenu)
                                q.banMenu.Add:SubMenuBack('Back')
                                q.kickMenu.Add:SubMenuBack('Back')
                                q.subMenu.Add:SubMenuBack('Back')
                                q.menu.Add:SubMenuBack('Back')
                            end

                            if not found then
                                activePlayers.Add:Button("No Active Players", { disabled = true }, function(data)
                                    
                                end)
                            end
                        end

                        tpToCoords.Add:Number('X Coordinate', {
                            disabled = false,
                            current = nil,
                        }, function(data)
                            x = data.data.value
                        end)
                        
                        tpToCoords.Add:Number('Y Coordinate', {
                            disabled = false,
                            current = nil,
                        }, function(data)
                            y = data.data.value
                        end)
                        
                        tpToCoords.Add:Number('Z Coordinate', {
                            disabled = false,
                            current = nil,
                        }, function(data)
                            z = data.data.value
                        end)

                        
                        
                        recentDisconnects.Add:SubMenuBack('Back')
                        activePlayers.Add:SubMenuBack('Back')

                        tpToCoords.Add:Button("Teleport", { disabled = false, success = true }, function(data)
                            if x and y and z then
                                SetEntityCoords(PlayerPedId(), tonumber(x), tonumber(y), tonumber(z))
                                x, y, z = nil, nil, nil
                                root.Close()
                            else
                                Notification:Error("You have not specified a location to teleport to.", 3500)
                            end
                        end)

                        

                        tpToCoords.Add:SubMenuBack('Back')

                        teleportTo.Add:Button("Teleport to Waypoint", { disabled = false, success = true }, function(data)
                            local success = false
                            local entity = PlayerPedId()
                            if IsPedInAnyVehicle(entity, false) then
                                entity = GetVehiclePedIsUsing(entity)
                            end

                            local blipFound = false
                            local blipIterator = GetBlipInfoIdIterator()
                            local blip = GetFirstBlipInfoId(8)
                            
                            while DoesBlipExist(blip) do
                                if GetBlipInfoIdType(blip) == 4 then
                                    cx, cy, cz = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ReturnResultAnyway(), Citizen.ResultAsVector())) --GetBlipInfoIdCoord(blip)
                                    blipFound = true
                                    success = true
                                    break
                                end
                                blip = GetNextBlipInfoId(blipIterator)
                            end

                            if blipFound then
                                local groundFound = false
                                local yaw = GetEntityHeading(entity)
                                
                                for i = 0, 1000, 1 do
                                    SetEntityCoordsNoOffset(entity, cx, cy, ToFloat(i), false, false, false)
                                    SetEntityRotation(entity, 0, 0, 0, 0 ,0)
                                    SetEntityHeading(entity, yaw)
                                    SetGameplayCamRelativeHeading(0)
                                    Citizen.Wait(0)
                                    --groundFound = true
                                    if GetGroundZFor_3dCoord(cx, cy, ToFloat(i), cz, false) then
                                        cz = ToFloat(i)
                                        groundFound = true
                                        break
                                    end
                                end
                                if not groundFound then
                                    cz = -300.0
                                end
                                success = true
                            else
                                Notification:Error('No Waypoint has been marked.', 3500)
                            end

                            if success then
                                SetEntityCoordsNoOffset(entity, cx, cy, cz, false, false, true)
                                SetGameplayCamRelativeHeading(0)
                                if IsPedSittingInAnyVehicle(PlayerPedId()) then
                                    if GetPedInVehicleSeat(GetVehiclePedIsUsing(PlayerPedId()), -1) == PlayerPedId() then
                                        SetVehicleOnGroundProperly(GetVehiclePedIsUsing(PlayerPedId()))
                                    end
                                end
                                blipFound = false
                                Notification:Success('Moved successfully', 3500)
                                root.Close()
                            end
                        end)

                        

                        vehicleManagement.Add:Input('Vehicle Spawn', {
                            disabled = false,
                            max = 30,
                            current = "nismo20",
                        }, function(data)
                            spawnVeh = data.data.value
                        end)

                        vehicleManagement.Add:Button("Spawn Vehicle", { disabled = false, success = true }, function(data)
                            if spawnVeh then
                                TriggerEvent('Commands:Client:SpawnVehicle', spawnVeh)
                                root.Close()
                            else
                                Notification:Error("You have not specified a vehicle modal spawn.", 3500)
                            end
                        end)

                        vehicleManagement.Add:Button("Delete Vehicle", { disabled = false }, function(data)
                            TriggerEvent('Commands:Client:RemoveVehicle')
                            root.Close()
                        end)

                        vehicleManagement.Add:SubMenuBack('Back')
                        spawnMenu.Add:SubMenuBack('Back')
                        root.Add:Button("Logout Character", { disabled = false }, function(data)
                            exports['bs_base']:FetchComponent('Characters'):Logout()
                            root.Close()
                        end)
                                                
                        root.Add:SubMenu('Player Management', playerManagement)
                        root.Add:SubMenu('Revive Management', reviveSettings)
                        root.Add:SubMenu('Developer Utilities', adminUtilities)
                        
                        if spawnLocations ~= nil then
                            for k, v in pairs(spawnLocations) do
                                spawnLoc.Add:Button(v.Name, { disabled = false }, function(data)
                                    SetEntityCoords(PlayerPedId(), tonumber(v.Coords.x), tonumber(v.Coords.y), tonumber(v.Coords.z))
                                    root.Close()
                                end)
                            end
                        else
                            spawnLoc.Add:Button("No Locations Found", { disabled = true }, function(data)
                            end)
                        end

                        
                        adminUtilities.Add:SubMenu('Teleport To', teleportTo)
                        adminUtilities.Add:SubMenuBack('Back')
                        teleportTo.Add:SubMenuBack('Back')
                        spawnLoc.Add:SubMenuBack('Back')
                        root.Add:SubMenu('Entity Management', spawnMenu)

                        root:Show()
                    end)
                end)
            end)
        end
    end)
end

function startAdminTick()
    Citizen.CreateThread(function()
        while loggedIn do
            if IsControlJustPressed(0, 213) or IsDisabledControlJustPressed(0, 213) then
                Admin:openMenu()
            end
            Citizen.Wait(3)
        end
    end)
end

RegisterNetEvent("Admin:noclip")
AddEventHandler("Admin:noclip", function(t)
	msg = "Disabled"
	if noClip then
		msg = "Enabled"
	end
	
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		noclipEntity = GetVehiclePedIsIn(PlayerPedId(), false)
	else
		noclipEntity = PlayerPedId()
	end

	SetEntityCollision(noclipEntity, not noClip, not noClip)
	FreezeEntityPosition(noclipEntity, noClip)
	SetEntityInvincible(noclipEntity, noClip)
	SetVehicleRadioEnabled(noclipEntity, not noClip) -- [[Stop radio from appearing when going upwards.]]

    buttons = setupScaleform("instructional_buttons")
    currentSpeed = config.speeds[noClipIndex].speed
    TriggerEvent('Admin:startNoClipping')
end)

function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function Button(ControlButton)
    ScaleformMovieMethodAddParamPlayerNameString(ControlButton)
end

function setupScaleform(scaleform)

    local scaleform = RequestScaleformMovie(scaleform)

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(1)
    end

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(4)
    Button(GetControlInstructionalButton(2, config.controls.goUp, true))
    ButtonMessage("Go Up")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(3)
    Button(GetControlInstructionalButton(2, config.controls.goDown, true))
    ButtonMessage("Go Down")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(1, config.controls.turnRight, true))
    Button(GetControlInstructionalButton(1, config.controls.turnLeft, true))
    ButtonMessage("Turn Left/Right")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(1, config.controls.goBackward, true))
    Button(GetControlInstructionalButton(1, config.controls.goForward, true))
    ButtonMessage("Go Forwards/Backwards")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, config.controls.changeSpeed, true))
    ButtonMessage("Change Speed ("..config.speeds[noClipIndex].label..")")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(config.bgR)
    PushScaleformMovieFunctionParameterInt(config.bgG)
    PushScaleformMovieFunctionParameterInt(config.bgB)
    PushScaleformMovieFunctionParameterInt(config.bgA)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

RegisterNetEvent('Admin:startNoClipping')
AddEventHandler('Admin:startNoClipping', function()
    while noClip do
        Citizen.Wait(1)
        DrawScaleformMovieFullscreen(buttons)

        local yoff = 0.0
        local zoff = 0.0

        if IsControlJustPressed(1, config.controls.changeSpeed) then
            if noClipIndex ~= 8 then
                noClipIndex = noClipIndex+1
                currentSpeed = config.speeds[noClipIndex].speed
            else
                currentSpeed = config.speeds[1].speed
                noClipIndex = 1
            end
            setupScaleform("instructional_buttons")
        end

        if IsControlPressed(0, config.controls.goForward) then
            yoff = config.offsets.y
        end
        
        if IsControlPressed(0, config.controls.goBackward) then
            yoff = -config.offsets.y
        end
        
        if IsControlPressed(0, config.controls.turnLeft) then
            SetEntityHeading(noclipEntity, GetEntityHeading(noclipEntity)+config.offsets.h)
        end
        
        if IsControlPressed(0, config.controls.turnRight) then
            SetEntityHeading(noclipEntity, GetEntityHeading(noclipEntity)-config.offsets.h)
        end
        
        if IsControlPressed(0, config.controls.goUp) then
            zoff = config.offsets.z
        end
        
        if IsControlPressed(0, config.controls.goDown) then
            zoff = -config.offsets.z
        end
        
        local newPos = GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, yoff * (currentSpeed + 0.3), zoff * (currentSpeed + 0.3))
        local heading = GetEntityHeading(noclipEntity)
        SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
        SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)
        SetEntityHeading(noclipEntity, heading)
        SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, noClip, noClip, noClip)
    end
end)