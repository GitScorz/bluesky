Banks = {}

RegisterNetEvent('Bank:SyncBanks')
AddEventHandler('Bank:SyncBanks', function(banks)
    Banks = banks
    for k, v in ipairs(Banks) do
        Markers.MarkerGroups:Remove(v.name .. k)
        Markers.MarkerGroups:Add(v.name .. k, v.coords, 50)
        Markers.Markers:Add(v.name .. k, v.name .. k, v.coords, -1, vector3(0.5, 0.5, 0.5), { r = 255, b = 0, g = 0 }, function()
            return v.bankOpen
        end, 'Press {key}E{/key} for ' .. v.name, 1, function()
            Bank:OpenUI('Bank')
        end)

        Markers.MarkerGroups:Remove(v.name .. k .. "-robbery")
        Markers.MarkerGroups:Add(v.name .. k .. "-robbery", v.coords, 50)
        if v.bankType == 'Big' or v.bankType == 'Paleto' then
            --Cashier Door
            Markers.Markers:ItemAdd(v.name .. k .. "-robbery", v.name .. k .. '-cashier-door', 'lockpick', v.cashiercoords.door.outside, "Pick the Lock", 1.0, function()
                return not v.cashiercoords.door.open
            end, function()
                Bank.Robbery:UnlockDoor(v._id, 'cashier')
            end)
        else
            Markers.Markers:ItemAdd(v.name .. k .. "-robbery", v.name .. k .. '-cashier-door', 'lockpick', v.cashiercoords.door.outside, "Pick the Lock", 1.0, function()
                return not v.cashiercoords.door.open
            end, function()
                Bank.Robbery:PickLockDoor(v._id, 'cashier', v.cashiercoords.door)
            end)
        end

        --Cashier Counters
        if v.cashiercoords.counters then
            for ck, cv in ipairs(v.cashiercoords.counters) do
                Markers.Markers:ItemAdd(v.name .. k .. "-robbery", 'cashier-counter-' .. ck, 'lockpick', cv, "Pick the Lock", 1.0, function()
                    return v.cashiercoords.door.open and not cv.open
                end, function()
                    Bank.Robbery:SearchCounter(v._id, ck)
                end)
            end
        end

        --Vault Door
        if v.bankType == 'Paleto' then
            Markers.Markers:ItemAdd(v.name .. k .. "-robbery", v.name .. k .. '-vault-door', 'lockpick', v.vaults.coords, "Pick the Lock", 1.0, function()
                return not v.vaults.door.open
            end, function()
                Bank.Robbery:UnlockDoor(v._id, 'vault')
                TriggerServerEvent('Bank:StartBankRobbery', v._id)
            end)
        else
            Markers.Markers:ItemAdd(v.name .. k .. "-robbery", v.name .. k .. '-vault-door-scan', 'vaultcard', v.vaults.coords, "Scan Access Card", 1.0, function()
                return not v.vaults.door.open and not v.vaults.door.scanned
            end, function(item)
                if item.MetaData.bank == v._id then
                    Bank.Robbery:ScanDoor(v._id, item)
                end
            end)

            Markers.Markers:ItemAdd(v.name .. k .. "-robbery", v.name .. k .. '-vault-door', 'computer', v.vaults.coords, "Hack the Door", 1.0, function()
                return not v.vaults.door.open and v.vaults.door.scanned
            end, function()
                Bank.Robbery:HackDoor(v._id, 'vault', v.vaults.door)
                TriggerServerEvent('Bank:StartBankRobbery', v._id)
            end)
        end

        if v.m_spots then
            for ck, cv in ipairs(v.m_spots) do
                Markers.Markers:ItemAdd(v.name .. k .. "-robbery", 'vault-m-spot-' .. ck, 'drill', cv, "Drill it Open", 1.0, function()
                    return v.vaults.door.open and not cv.open
                end, function()
                    Bank.Robbery:OpenMoneySpot(v._id, ck)
                end)
            end
        end
        if v.vg_spots then
            for ck, cv in ipairs(v.vg_spots) do
                Markers.Markers:ItemAdd(v.name .. k .. "-robbery", 'vault-vg-spot-' .. ck, 'drill', cv, "Drill it Open", 1.0, function()
                    return v.vaults.door.open and not cv.open
                end, function()
                    Bank.Robbery:OpenValuableGoods(v._id, ck)
                end)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local playerPed = PlayerPedId()
        local pedCoords = GetEntityCoords(playerPed)
        if Banks then
            for k, v in ipairs(Banks) do
                local dist = #(pedCoords - vector3(v.cashiercoords.door.outside.x, v.cashiercoords.door.outside.y, v.cashiercoords.door.outside.z))
                if dist < 20.0 then
                    if v.cashiercoords.obj == nil or v.cashiercoords.obj == 0 or not DoesEntityExist(v.cashiercoords.obj) then
                        local door = v.cashiercoords.door
                        Banks[k].cashiercoords.obj = GetClosestObjectOfType(door.coords.x, door.coords.y, door.coords.z, 5.0, door.hash)
                    end
                    if Banks[k].cashiercoords.obj then
                        if not v.cashiercoords.door.opening then
                            if v.cashiercoords.door.open then
                                SetEntityHeading(Banks[k].cashiercoords.obj, v.cashiercoords.door.oh + 0.0)
                            else
                                SetEntityHeading(Banks[k].cashiercoords.obj, v.cashiercoords.door.ch + 0.0)
                            end
                        end
                    end
                end

                dist = #(pedCoords - vector3(v.vaults.coords.x, v.vaults.coords.y, v.vaults.coords.z))
                if dist < 20.0 then
                    if v.vaultgate.obj == nil or v.vaultgate.obj == 0 or not DoesEntityExist(v.vaultgate.obj) then
                        local door = v.cashiercoords.door
                        Banks[k].vaultgate.obj = GetClosestObjectOfType(door.coords.x, door.coords.y, door.coords.z, 5.0, door.hash)
                    end
                    if not v.vaults.door.opening then
                        if v.vaults.door.open then
                            SetEntityHeading(Banks[k].vaults.obj, v.vaults.door.oh + 0.0)
                        else
                            SetEntityHeading(Banks[k].vaults.obj, v.vaults.door.ch + 0.0)
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('Bank:SyncDoor')
AddEventHandler('Bank:SyncDoor', function(door, action)
    local obj = GetClosestObjectOfType(door.coords.x, door.coords.y, door.coords.z, 5.0, door.hash)
    local objHeading = GetEntityHeading(obj)
    if action then
        Citizen.CreateThread(function()
            for i = objHeading, door.oh, (door.oh > door.ch and 1 or -1) do
                Citizen.Wait(5)
                SetEntityHeading(obj, i + 0.0)
            end
        end)
    else
        Citizen.CreateThread(function()
            for i = objHeading, door.ch, (door.oh > door.ch and -1 or 1) do
                Citizen.Wait(5)
                SetEntityHeading(obj, i + 0.0)
            end
        end)
    end
end)

BANK.Robbery = {
    PickLockDoor = function(self, bank, type, door)
        Progress:ProgressWithStartEvent({
            name = 'lockpick',
            duration = 2000,
            label = 'Picking the Lock',
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                anim = "machinic_loop_mechandplayer",
                flags = 49,
            }
        }, function()
            Action:Hide()
        end, function(status)
            TriggerServerEvent('Bank:SyncDoor', bank, type, door, true)
        end)
    end,
    UnlockDoor = function(self, bank, type)
        local door = Doors:GetCurrentDoor()
        Progress:ProgressWithStartEvent({
            name = 'unlocking',
            duration = 2000,
            label = 'Picking the Lock',
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                anim = "machinic_loop_mechandplayer",
                flags = 49,
            }
        }, function()
            Action:Hide()
        end, function(status)
            TriggerServerEvent('Bank:UnlockDoor', bank, type, door, true)
        end)
    end,
    HackDoor = function(self, bank, type, door)
        Progress:ProgressWithStartEvent({
            name = 'hacking',
            duration = 2000,
            label = 'Hacking the Door',
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = "missheistdockssetup1clipboard@base",
                anim = "base",
                flags = 49,
            },
            prop = {
                model = "p_laptop_02_s",
                rotation = { x = 50.0, y = 0.0, z = 0.0 },
                coords = { x = 0.0, y = 0.0, z = 0.0 }
            }
        }, function()
            Action:Hide()
        end, function(status)
            TriggerServerEvent('Bank:SyncDoor', bank, type, door, true)
        end)
    end,
    ScanDoor = function(self, bank, item)
        Progress:ProgressWithStartEvent({
            name = 'scan',
            duration = 2000,
            label = 'Scanning the Card',
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                anim = "machinic_loop_mechandplayer",
                flags = 49,
            }
        }, function()
            Action:Hide()
        end, function(status)
            TriggerServerEvent('Bank:SyncDoorScan', bank, true)
            TriggerServerEvent('Bank:RemoveAccessCard', item)
        end)
    end,
    SearchCounter = function(self, bank, ck)
        Progress:ProgressWithStartEvent({
            name = 'searching',
            duration = 2000,
            label = 'Searching the Counter',
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = 'mp_arresting',
                anim = 'a_uncuff',
                flags = 49,
            }
        }, function()
            Action:Hide()
        end, function(status)
            TriggerServerEvent('Bank:SyncCounter', bank, ck, true)
            TriggerServerEvent('Bank:CounterReward', bank, ck)
        end)
    end,
    OpenMoneySpot = function(self, bank, ck)
        Progress:ProgressWithStartEvent({
            name = 'mspot',
            duration = 2000,
            label = 'Opening Safety Deposit Box',
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                task = 'WORLD_HUMAN_WELDING'
            }
        }, function()
            Action:Hide()
        end, function(status)
            ClearPedTasksImmediately(PlayerPedId())
            TriggerServerEvent('Bank:SyncMSpot', bank, ck, true)
            TriggerServerEvent('Bank:MSpotReward', bank, ck)
        end)
    end,
    OpenValuableGoods = function(self, bank, ck)
        Progress:ProgressWithStartEvent({
            name = 'vgspot',
            duration = 2000,
            label = 'Opening Safety Deposit Box',
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                task = 'WORLD_HUMAN_WELDING'
            }
        }, function()
            Action:Hide()
        end, function(status)
            ClearPedTasksImmediately(PlayerPedId())
            TriggerServerEvent('Bank:SyncVGSpot', bank, ck, true)
            TriggerServerEvent('Bank:VGSpotReward', bank, ck)
        end)
    end
}