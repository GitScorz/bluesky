SecondInventory = {}

local _open = false
local _disabled = false
local hotBarOpen = false
local trunkOpen = false

AddEventHandler('Inventory:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Inventory = exports['bs_base']:FetchComponent('Inventory')
    Utils = exports['bs_base']:FetchComponent('Utils')
    Notification = exports['bs_base']:FetchComponent('Notification')
    Action  = exports['bs_base']:FetchComponent('Action')
    -- Weapons = exports['bs_base']:FetchComponent('Weapons')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Inventory', {
        'Callbacks',
        'Inventory',
        'Utils',
        'Notification',
        'Action',
        -- 'Weapons',
    }, function(error)  
        if #error > 0 then return; end
        RetrieveComponents()
    end)
end)

INVENTORY = {
    _required = { 'Open', 'Close', 'Set', 'Enable', 'Disable', 'Toggle', 'Check' },
    Open = {
        Player = function(self)
            if not _open then
                _open = true
                Citizen.CreateThread(function()
                    TransitionToBlurred(50)
                    while _open do
                        Citizen.Wait(50)
                    end
                    TransitionFromBlurred(1000)
                end)
            end
            Callbacks:ServerCallback('Inventory:GetPlayerInventory', {}, function(inventory)
                Inventory.Set.Player:Inventory(inventory)
                Inventory.Set.Player.Data.Open = true
            end)
            SetNuiFocus(true, true)
            SendNUIMessage({
                type = 'APP_SHOW'
            })
        end,
        Secondary = function(self)
            SendNUIMessage({
                type = 'SHOW_SECONDARY_INVENTORY'
            })
        end
    },
    Close = {
        All = function(self)
            SendNUIMessage({
                type = 'APP_HIDE'
            })
            SendNUIMessage({
                type = 'HIDE_SECONDARY_INVENTORY'
            })
            SetNuiFocus(false, false)
            _open = false
            
            Inventory.Set.Player.Data.Open = false

            if trunkOpen and trunkOpen > 0 then
                SetVehicleDoorShut(trunkOpen, 5, false)
                trunkOpen = false
            end

            if Inventory.Set.Secondary.Data.Open then
                TriggerServerEvent('Inventory:server:closeSecondary')
                SecondInventory = {}
                Inventory.Set.Secondary.Data.Open = false
            end
        end,
        Secondary = function(self)
            SendNUIMessage({
                type = 'HIDE_SECONDARY_INVENTORY'
            })
            if trunkOpen and trunkOpen > 0 then
                SetVehicleDoorShut(trunkOpen, 5, false)
                trunkOpen = false
            end

            if Inventory.Set.Secondary.Data.Open then
                TriggerServerEvent('Inventory:server:closeSecondary')
                SecondInventory = {}
                Inventory.Set.Secondary.Data.Open = false
            end
        end
    },
    Set = {
        Player = {
            Data = {
                allowOpen = true,
                Open = false,
            },
            Inventory = function(self, data)
                SendNUIMessage({
                    type = 'SET_PLAYER_INVENTORY',
                    data = data
                })
            end,
            Equipment = function(self, data)
                SendNUIMessage({
                    type = 'SET_EQUIPMENT',
                    data = data
                })
            end,
            Refresh = function(self)
                Callbacks:ServerCallback('Inventory:GetPlayerInventory', {}, function(inventory)
                    Inventory.Set.Player:Inventory(inventory)
                end)
            end
        },
        Secondary = {
            Data = {
                Open = false,
            },
            Inventory = function(self, data)
                Inventory.Set.Secondary.Data.Open = true
                SendNUIMessage({
                    type = 'SET_SECONDARY_INVENTORY',
                    data = data
                })
            end,
            Refresh = function(self)
                Callbacks:ServerCallback('Inventory:GetSecondInventory', {}, function(inventory)
                    Inventory.Set.Secondary:Inventory(inventory)
                end)
            end
        }
    },
    Used = {
        HotKey = function(self, control)
            if not hotBarOpen then
                hotBarOpen = true
                Callbacks:ServerCallback('Inventory:GetPlayerInventory', {}, function(inventory)
                    Callbacks:ServerCallback('Inventory:UseSlot', {slot = control}, function(success)
                        if success then
                            Inventory.Set.Player:Inventory(inventory)
                            Citizen.Wait(100)
                            SendNUIMessage({
                                type = 'HOTBAR_SHOW',
                                data = {
                                    hotkey = control,
                                }
                            })
                        end
                        Citizen.Wait(200)
                        hotBarOpen = false
                    end)
                end)
            end
        end,
    },
    Check = {
        Player = {
            HasItem = function(self, item, cb)
                Callbacks:ServerCallback('Inventory:Server:HasItem', {item = item}, function(g)
                    cb(g)
                end)
            end,
        },
        Functions = {
             Vehicle = function(self)
                local player = PlayerPedId()
                local startPos = GetOffsetFromEntityInWorldCoords(player, 0, 0.5, 0)
                local endPos = GetOffsetFromEntityInWorldCoords(player, 0, 5.0, 0)
            
                local rayHandle = StartShapeTestRay(startPos['x'], startPos['y'], startPos['z'], endPos['x'], endPos['y'], endPos['z'], 10, player, 0)
                local a, b, c, d, veh = GetShapeTestResult(rayHandle)
            
                if veh ~= 2 then
                    local plyCoords = GetEntityCoords(player)
                    local offCoords = GetOffsetFromEntityInWorldCoords(veh, 0.0, -2.5, 1.0)
                    local dist = #(vector3(offCoords.x, offCoords.y, offCoords.z) - plyCoords)
            
                    if dist < 2.5 then
                        return veh
                    end
                else
                    return nil
                end
            end,
            TrunkDistance = function(self, veh)
                Citizen.CreateThread(function()
                    while trunkOpen do
                        Citizen.Wait(1)
                        local pos = GetEntityCoords(PlayerPedId())
                        local dist = #(vector3(pos.x, pos.y, pos.z) - GetOffsetFromEntityInWorldCoords(veh, 0.0, -2.5, 1.0))
                        if dist > 1 and trunkOpen then
                            Inventory.Close:Secondary()
                            trunkOpen = false
                        else
                            Citizen.Wait(500)
                        end
                    end
                end)
            end,
        },
    },
    Enable = function(self)
        _disabled = false
    end,
    Disable = function(self)
        _disabled = true
    end,
    Toggle = function(self)
        _disabled = not _disabled
    end
}

RegisterNetEvent('Inventory:RemoveWeapon')
AddEventHandler('Inventory:RemoveWeapon', function(id)
    -- Weapons.UnEquip:UnequipFromInventory(id)
end)

RegisterNetEvent('Inventory:client:loadSecondary')
AddEventHandler('Inventory:client:loadSecondary', function(data)
    Inventory.Set.Secondary:Inventory(data)
    Inventory.Open:Player()
    Inventory.Open:Secondary()
end)

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Inventory', INVENTORY)
end)

RegisterNUICallback('Close', function(data, cb)
    Inventory.Close:All()
    Inventory:Enable()
end)

RegisterNetEvent('Inventory:Client:RefreshPlayer')
AddEventHandler('Inventory:Client:RefreshPlayer', function()
    Inventory.Set.Player:Refresh()
end)

RegisterNetEvent('Inventory:Client:RefreshSecondary')
AddEventHandler('Inventory:Client:RefreshSecondary', function()
    if Inventory.Set.Secondary.Data.Open then
        Inventory.Set.Secondary:Refresh()
    end
end)

RegisterNetEvent('Characters:Client:Spawn')
AddEventHandler('Characters:Client:Spawn', function()
    Callbacks:ServerCallback('Inventory:Server:ReceiveAllDrops', {}, function(drops)
        Callbacks:ServerCallback('Inventory:Server:retreiveStores', {}, function(shopsData)
            DropZones = drops
            Shops = shopsData
            GLOBAL_PED = PlayerPedId()
            GLOBAL_COORDS = GetEntityCoords(GLOBAL_PED)
            _isLoggedIn = true
            startThreads()
        end)
    end)
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    _isLoggedIn = false
    DropZones = {}
    Shops = {}
end)

function startThreads()

    startShopsTick()
    startDropsTick()

    Citizen.CreateThread(function()
        while _isLoggedIn do
            DisableControlAction(0, 37, true)
            Citizen.Wait(1)
        end
    end)

    Citizen.CreateThread(function()
        while _isLoggedIn do
            Citizen.Wait(4)
            if IsDisabledControlJustReleased(0, 37) then
                if not hotBarOpen then
                    hotBarOpen = true
                    Callbacks:ServerCallback('Inventory:GetPlayerInventory', {}, function(inventory)
                        Inventory.Set.Secondary:Refresh()
                        Inventory.Set.Player:Inventory(inventory)
                        Citizen.Wait(100)
                        SendNUIMessage({
                            type = 'HOTBAR_SHOW'
                        })
                        Citizen.Wait(5000)
                        hotBarOpen = false
                    end)
                end            
            end

            if IsDisabledControlJustReleased(0, 157) then
                Inventory.Used:HotKey(1)
            elseif IsDisabledControlJustReleased(0, 158) then
                Inventory.Used:HotKey(2)
            elseif IsDisabledControlJustReleased(0, 160) then
                Inventory.Used:HotKey(3)
            elseif IsDisabledControlJustReleased(0, 164) then
                Inventory.Used:HotKey(4)
            elseif IsDisabledControlJustReleased(0, 165) then
                Inventory.Used:HotKey(5)
            end

            if IsControlJustReleased(0, 289) and not _disabled then
                if Inventory.Set.Player.Data.allowOpen then
                    Inventory:Disable()
                    Callbacks:ServerCallback('Inventory:CheckIfNearDropZone', {}, function(dropzone)
                        local playerPed = PlayerPedId()
                        local plate
                        local requestSecondary = false
                        local isPedInVehicle = IsPedInAnyVehicle(playerPed)
                        
                        if isPedInVehicle then
                            local vehicle =  GetVehiclePedIsIn(playerPed)
                            if vehicle ~= nil and vehicle > 0 then
                                plate = GetVehicleNumberPlateText(vehicle)
                                
                                -- do fake plate check

                                -- do player owned check

                                SecondInventory = { invType = 5, owner = plate }
                                requestSecondary = true
                            end
                        end
                    
                        -- do trunk check here aswell maybe?
                        local vehicle = Inventory.Check.Functions:Vehicle()
                        if vehicle and IsEntityAVehicle(vehicle) and not requestSecondary then
                            local plate = GetVehicleNumberPlateText(vehicle)

                            -- Check here for false plates

                            if GetVehicleDoorLockStatus(vehicle) == 1 then
                                trunkOpen = vehicle
                                -- check here for player owned vehs

                                SecondInventory = { invType = 4, owner = plate }
                                requestSecondary = true

                                SetVehicleDoorOpen(vehicle, 5, true, false)
                                Inventory.Check:TrunkDistance()
                            else
                                Notification:Error('Vehicle locked.', 3500)
                            end
                        end

                        -- Trash Container Checks here?
                        local container, entity = ScanContainer()
                        
                        if container and not isPedInVehicle and not requestSecondary then
                            if entity > 0 then
                                containerid = DecorGetInt(entity, 'TrashContainer-Inventory')
                                SecondInventory = { invType = 16, owner = containerid }
                                requestSecondary = true
                            end
                        end
                        
                        if dropzone ~= nil and not isPedInVehicle and not requestSecondary then
                            SecondInventory = { invType = 10, owner = dropzone }
                            requestSecondary = true
                        elseif dropzone == nil and not isPedInVehicle and not requestSecondary then
                            TriggerServerEvent('Inventory:Server:createNewDropzone')
                        end
                        
                        if requestSecondary then
                            TriggerServerEvent('Inventory:Server:requestSecondaryInventory', SecondInventory)
                        end
                        Inventory.Open:Player()
                    end)
                end
            end
        end
    end)
    
    Citizen.CreateThread(function()
        while _isLoggedIn do
            GLOBAL_PED = PlayerPedId()
            Citizen.Wait(1500)
        end
    end)
    
    Citizen.CreateThread(function()
        while _isLoggedIn do
            if GLOBAL_PED ~= nil then
                GLOBAL_COORDS = GetEntityCoords(GLOBAL_PED)
            end
            Citizen.Wait(100)
        end
    end)
end

RegisterNUICallback('MoveSlot', function(data, cb)
    cb('OK')
    Callbacks:ServerCallback('Inventory:MoveItem', data, function(success)
        if success and success.success then
            Callbacks:ServerCallback('Inventory:GetPlayerInventory', {}, function(inventory)
                Inventory.Set.Secondary:Refresh()
                Inventory.Set.Player:Inventory(inventory)
            end)
        else
            if success and success.reason then
                Notification:Error(success.reason, 3600)
            else
                Notification:Error("There was an error processing your inventory request.", 3600)
            end
        end
    end)
end)

RegisterNUICallback('NextSlotInSecondary', function(data, cb)
    cb('OK')
    Callbacks:ServerCallback('Inventory:Server:NextSlotInSecondary', data, function(meh)
        if meh then
            Callbacks:ServerCallback('Inventory:GetPlayerInventory', {}, function(inventory)
                Inventory.Set.Secondary:Refresh()
                Inventory.Set.Player:Inventory(inventory)
            end)
        end
    end)
end)

RegisterNUICallback('SendNotify', function(data, cb)
    cb('OK')
    if data then
        if data.alert == "success" then
            Notification:Success(data.message, data.time)
        elseif data.alert == "warning" then
            Notification:Warning(data.message, data.time)
        elseif data.alert == "error" then
            Notification:Error(data.message, data.time)
        end
    end
end)

RegisterNUICallback('UseItem', function(data, cb)
    cb('OK')
    Callbacks:ServerCallback('Inventory:UseItem', {
        slot = data.slot,
        owner = data.owner,
        invType = data.invType
    }, function(success)
        Callbacks:ServerCallback('Inventory:GetPlayerInventory', {}, function(inventory)
            Inventory.Set.Player:Inventory(inventory)
        end)
    end)
end)

RegisterNetEvent('Inventory:CloseUI')
AddEventHandler('Inventory:CloseUI', function()
    Inventory.Close:All()
    Inventory:Enable()
end)