RegisterServerEvent('Characters:Server:Spawn')
AddEventHandler('Characters:Server:Spawn', function()
    TriggerClientEvent('Bank:SyncBanks', source, Banks)
end)

RegisterServerEvent('Bank:SyncDoor')
AddEventHandler('Bank:SyncDoor', function(bank, type, door, action)
    for k, v in pairs(Banks) do
        if v._id == bank then
            if type == 'cashier' then
                Banks[k].cashiercoords.door.open = action
                Banks[k].cashiercoords.door.opening = action
                if action then
                    Citizen.CreateThread(function()
                        Citizen.Wait(3000)
                        Banks[k].cashiercoords.door.opening = false
                        TriggerClientEvent('Bank:SyncBanks', -1, Banks)
                    end)
                end
            end
            if type == 'vault' then
                Banks[k].vaults.door.open = action
                Banks[k].vaults.door.opening = action
                if action then
                    Citizen.CreateThread(function()
                        Citizen.Wait(3000)
                        Banks[k].vaults.door.opening = false
                        TriggerClientEvent('Bank:SyncBanks', -1, Banks)
                    end)
                end
            end
            TriggerClientEvent('Bank:SyncDoor', -1, door, action)
            TriggerClientEvent('Bank:SyncBanks', -1, Banks)
            return
        end
    end
end)

RegisterServerEvent('Bank:UnlockDoor')
AddEventHandler('Bank:UnlockDoor', function(bank, type, door, action)
    for k, v in pairs(Banks) do
        if v._id == bank then
            if type == 'cashier' then
                Banks[k].cashiercoords.door.open = action
                Banks[k].cashiercoords.door.id = door
            end
            if type == 'vault' then
                Banks[k].vaults.door.open = action
                Banks[k].vaults.door.id = door
            end
            TriggerClientEvent('Bank:SyncBanks', -1, Banks)
            TriggerEvent('Doors:server:updateDoor', door, not action)
            return
        end
    end
end)

RegisterServerEvent('Bank:SyncDoorScan')
AddEventHandler('Bank:SyncDoorScan', function(bank, action)
    for k, v in pairs(Banks) do
        if v._id == bank then
            Banks[k].vaults.door.scanned = action
            TriggerClientEvent('Bank:SyncBanks', -1, Banks)
            return
        end
    end
end)

RegisterServerEvent('Bank:SyncCounter')
AddEventHandler('Bank:SyncCounter', function(bank, ck, action)
    for k, v in pairs(Banks) do
        if v._id == bank then
            Banks[k].cashiercoords.counters[ck].open = action
        end
    end
    TriggerClientEvent('Bank:SyncBanks', -1, Banks)
end)

RegisterServerEvent('Bank:SyncMSpot')
AddEventHandler('Bank:SyncMSpot', function(bank, ck, action)
    for k, v in pairs(Banks) do
        if v._id == bank then
            Banks[k].m_spots[ck].open = action
        end
    end
    TriggerClientEvent('Bank:SyncBanks', -1, Banks)
end)

RegisterServerEvent('Bank:SyncVGSpot')
AddEventHandler('Bank:SyncVGSpot', function(bank, ck, action)
    for k, v in pairs(Banks) do
        if v._id == bank then
            Banks[k].vg_spots[ck].open = action
        end
    end
    TriggerClientEvent('Bank:SyncBanks', -1, Banks)
end)

Banks = {}

RegisterServerEvent('Bank:ResetBanks')
AddEventHandler('Bank:ResetBanks', function()
    for k, v in ipairs(Banks) do
        if v.bankType == 'Big' and v.bankType == 'Paleto' then
            TriggerEvent('Bank:UnlockDoor', v._id, 'cashier', v.cashiercoords.door.id, false)
        else
            TriggerEvent('Bank:SyncDoor', v._id, 'cashier', v.cashiercoords.door, false)
        end
        TriggerEvent('Bank:SyncDoor', v._id, 'vault', v.vaults.door, false)
    end

    LoadBanks(function()
        TriggerClientEvent('Bank:SyncBanks', -1, Banks)
    end)
end)

RegisterServerEvent('Bank:ResetBank')
AddEventHandler('Bank:ResetBank', function(id)
    for k, v in ipairs(Banks) do
        if v._id == id then
            if v.bankType == 'Big' and v.bankType == 'Paleto' then
                TriggerEvent('Bank:UnlockDoor', v._id, 'cashier', v.cashiercoords.door.id, false)
            else
                TriggerEvent('Bank:SyncDoor', v._id, 'cashier', v.cashiercoords.door, false)
            end
            TriggerEvent('Bank:SyncDoor', v._id, 'vault', v.vaults.door, false)
            break
        end
    end
    LoadBank(id, function(bank)
        TriggerClientEvent('Bank:SyncBanks', -1, Banks)
    end)
end)

function LoadBanks(cb)
    Database.Game:find({
        collection = 'banks',
    }, function(success, results)
        if not success then
            return
        end
        Banks = {
            results[1]
        }
        if cb then
            cb()
        end
    end)
end

function LoadBank(id, cb)
    Database.Game:findOne({
        collection = 'banks',
        query = {
            _id = id
        }
    }, function(success, results)
        if not success then
            return
        end
        for k, v in ipairs(Banks) do
            if v._id == id then
                Banks[k] = results[1]
                break
            end
        end
        if cb then
            cb(results[1])
        end
    end)
end

RegisterServerEvent('Bank:StartBankRobbery')
AddEventHandler('Bank:StartBankRobbery', function(id)
    for k, v in ipairs(Banks) do
        if v._id == id then
            Banks[k].bankOpen = false
            Banks[k].bankCooldown = os.time() + 1 * 60 * 60
            return
        end
    end
end)

RegisterServerEvent('Bank:CounterReward')
AddEventHandler('Bank:CounterReward', function(bank)
    local source = source
    local random = math.random(95, 100)
    if random >= 95 then
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        local char = player:GetData('Character')
        Inventory:AddItem(char:GetData('ID'), 'vaultcard', 1, {
            bank = bank
        }, 1)
    end
end)

RegisterServerEvent('Bank:RemoveAccessCard')
AddEventHandler('Bank:RemoveAccessCard', function(item)
    local source = source
    local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
    local char = player:GetData('Character')
    Inventory:RemoveItem(source, char:GetData('ID'), 'vaultcard', 1, item.Slot, 1)
end)

RegisterServerEvent('Bank:MSpotReward')
AddEventHandler('Bank:MSpotReward', function()
    local source = source
    local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
    local char = player:GetData('Character')
    Wallet:Add(char, math.random(1000))
end)

RegisterServerEvent('Bank:VGSpotReward')
AddEventHandler('Bank:VGSpotReward', function()
    local source = source
    local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
    local char = player:GetData('Character')
    local items = { 'rolex', 'ring', 'valuegoods' }
    Inventory:AddItem(char:GetData('ID'), items[math.random(#items)], math.random(5), {}, 1)
end)
