Database = nil
Callbacks = nil
Logger = nil
Inventory = nil
loadedInventorys = {}
itemsDatabase = {}
LoadedEntitys = {}

AddEventHandler('Inventory:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Database = exports['bs_base']:FetchComponent('Database')
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Logger = exports['bs_base']:FetchComponent('Logger')
    Utils = exports['bs_base']:FetchComponent('Utils')
    Default = exports['bs_base']:FetchComponent('Default')
    Inventory = exports['bs_base']:FetchComponent('Inventory')
    Items = exports['bs_base']:FetchComponent('Items')
    EntityTypes = exports['bs_base']:FetchComponent('EntityTypes')
    Chat = exports['bs_base']:FetchComponent('Chat')
    Wallet = exports['bs_base']:FetchComponent('Wallet')
    Execute = exports['bs_base']:FetchComponent('Execute')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Inventory', {
        'Database',
        'Callbacks',
        'Logger',
        'Utils',
        'Inventory',
        'Items',
        'Chat',
        'EntityTypes',
        'Default',
        'Wallet',
        'Execute',
    }, function(error)
        if #error > 0 then
            return
        end
        RetrieveComponents()

        DefaultData()
        DefaultEntityData()
        DefaultShopData()
        RegisterCallbacks()
        processItemCallbacks()
        loadedInventorys = {}
        Database.Game:find({
            collection = 'dropzones',
            query = {}
        }, function(success, dropzones)
            if not success then
                return ;
            end
            local totalDeleted = 0
            if dropzones[1] then
                for i = 1, #dropzones do
                    local done = false
                    Database.Game:delete({
                        collection = 'inventory',
                        query = {
                            invType = 10,
                            Owner = dropzones[i].randomIdent
                        }
                    }, function(delsuccess, deleted)
                        if not delsuccess then
                            return ;
                        end

                        Database.Game:deleteOne({
                            collection = 'dropzones',
                            query = {
                                randomIdent = dropzones[i].randomIdent
                            }
                        }, function(successdr, dropdelete)
                            if not successdr then
                                return ;
                            end
                            totalDeleted = totalDeleted + 1
                            done = true
                        end)
                    end)
                    while not done do
                        Wait(0)
                    end
                end

                if totalDeleted > 0 then
                    Logger:Trace('Inventory', totalDeleted .. ' Dropzones have been deleted from the server', { console = true })
                end
            end

            Database.Game:delete({
                collection = 'inventory',
                query = {
                    invType = 16,
                }
            }, function(delsuccess, deleted)
                if not delsuccess then
                    return ;
                end
                if deleted > 0 then
                    Logger:Trace('Inventory', deleted .. ' Items have been collected from trash containers.', { console = true })
                end
            end)

        end)

        Database.Game:find({
            collection = 'items',
            query = {

            }
        }, function(success, results)
            if not success then
                return ;
            end
            for k, v in ipairs(results) do
                itemsDatabase[v.name] = v
            end
        end)
        Database.Game:find({
            collection = 'entitytypes',
            query = {

            }
        }, function(success, results)
            if not success then
                return ;
            end
            for k, v in ipairs(results) do
                LoadedEntitys[tonumber(v.id)] = v
            end
        end)

        Chat:RegisterAdminCommand('giveitem', function(source, args, rawCommand)
            local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
            local char = player:GetData('Character')
            if tostring(args[1]) ~= nil and tonumber(args[2]) ~= nil then
                Items:GetItem(args[1], function(itemExist)
                    if itemExist then
                        if itemExist.type ~= 2 then
                            Inventory:AddItem(char:GetData('ID'), args[1], tonumber(args[2]), {}, 1)
                        else
                            Execute:Client(source, 'Notification', 'Error', 'You can only give items with this command, try /giveweapon')
                        end
                    else
                        Execute:Client(source, 'Notification', 'Error', 'Item not located')
                    end
                end)
            end
        end, {
            help = 'Give Item',
            params = {
                {
                    name = 'Item Name',
                    help = 'The name of the Item'
                },
                {
                    name = 'Item Count',
                    help = 'The count of the Item'
                }
            }
        }, 2)

        Chat:RegisterAdminCommand('giveweapon', function(source, args, rawCommand)
            local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
            local char = player:GetData('Character')
            if tostring(args[1]) ~= nil then
                local weapon = string.upper(args[1])
                Items:GetItem(weapon, function(itemExist)
                    if itemExist then
                        if itemExist.type == 2 then
                            local ammo = itemExist.weaponConfig.defaultAmmo
                            if args[2] ~= nil then
                                ammo = tonumber(args[2])
                            end

                            Inventory:AddItem(char:GetData('ID'), weapon, 1, { ['ammo'] = ammo }, 1)
                        else
                            Execute:Client(source, 'Notification', 'Error', 'You can only give weapons with this command, try /giveitem')
                        end
                    else
                        Execute:Client(source, 'Notification', 'Error', 'Weapon not located')
                    end
                end)
            end
        end, {
            help = 'Give Weapon',
            params = {
                {
                    name = 'Weapon Name',
                    help = 'The name of the Weapon'
                },
                {
                    name = 'Ammo',
                    help = '[Optional] The amount of ammo with the weapon.'
                }
            }
        }, 2)
    end)
end)

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Inventory', INVENTORY)
end)

RegisterServerEvent('Inventory:server:closeSecondary')
AddEventHandler('Inventory:server:closeSecondary', function()
    local src = source
    if loadedInventorys[src] then

        if loadedInventorys[src].invType == 10 then
            Inventory:ManageDropzone(loadedInventorys[src].owner, function()

            end)
        end

        loadedInventorys[src] = nil
    end
end)

function processRefreshForClients(owner, invType, source)
    for k, v in pairs(loadedInventorys) do
        if v.owner == owner and v.invType == invType and v.source ~= source then
            if invType == 1 then

            else
                TriggerClientEvent('Inventory:Client:RefreshSecondary', tonumber(v.source))
            end
        end
    end
end

function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Inventory:Server:HasItem', function(source, data, cb)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        local char = player:GetData('Character')
        Inventory:GetMatchingSlot(char:GetData('ID'), data.item, 1, cb)
    end)

    Callbacks:RegisterServerCallback('Inventory:UseSlot', function(source, data, cb)
        if data and data.slot then
            local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
            local char = player:GetData('Character')
            Inventory:GetMatchingSlot(char:GetData('ID'), data.item, 1, cb)
        end
    end)

    Callbacks:RegisterServerCallback('Inventory:Server:RemoveItem', function(source, data, cb)
        if data.item.Owner and data.item.Name and data.item.Slot and data.item.invType then
            Inventory:RemoveItem(data.item.Owner, data.item.Name, (data.amount or 1), data.item.Slot, data.item.invType, cb)
        end
    end)

    Callbacks:RegisterServerCallback('Inventory:UseSlot', function(source, data, cb)
        if data and data.slot then
            local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
            local char = player:GetData('Character')
            if player and char then
                Inventory:GetSlot(char:GetData('ID'), data.slot, 1, function(slotFrom)
                    if slotFrom ~= nil then
                        if slotFrom.Count > 0 then
                            Inventory.Items:Use(source, slotFrom, function(yea)
                                TriggerClientEvent('Inventory:Client:RefreshPlayer', source)
                                cb(yea)
                            end)
                        else
                            cb(false)
                        end
                    else
                        cb(false)
                    end
                end)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Inventory:Server:NextSlotInSecondary', function(source, data, cb)
        Inventory:GetOpenSlot(data.ownerTo, data.invTypeTo, function(i)
            if i ~= nil and i > 0 and i <= LoadedEntitys[data.invTypeTo].slots then
                Inventory:GetSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(slotFrom)
                    if slotFrom ~= nil then
                        --UpdateSlot = function(self, id, Owner, Slot, invType, cb)
                        Inventory:UpdateSlot(slotFrom._id, data.ownerTo, i, data.invTypeTo, function(success)
                            cb(success)
                        end)
                    end
                end)
            end
        end)
    end)

    Callbacks:RegisterServerCallback('Inventory:GetSecondInventory', function(source, data, cb)
        local src = source
        local reqInt = loadedInventorys[src]
        if reqInt then
            Inventory:Get(reqInt.owner, reqInt.invType, function(inventory)
                cb({
                    size = LoadedEntitys[reqInt.invType].slots,
                    name = LoadedEntitys[reqInt.invType].name,
                    inventory = inventory.inventory,
                    invType = reqInt.invType,
                    owner = reqInt.owner
                })
            end)
        end
    end)

    Callbacks:RegisterServerCallback('Inventory:GetPlayerInventory', function(source, data, cb)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        local char = player:GetData('Character')
        Inventory:Get(char:GetData('ID'), 1, function(inventory)
            cb({
                size = (LoadedEntitys[1].slots or 10),
                name = char:GetData('First') .. ' ' .. char:GetData('Last'),
                inventory = inventory.inventory,
                invType = 1,
                owner = char:GetData('ID')
            })
        end)
    end)

    Callbacks:RegisterServerCallback('Inventory:MoveItem', function(source, data, cb)
        local _src = source
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        local char = player:GetData('Character')
        if itemsDatabase[data.name] then
            local item = itemsDatabase[data.name]

            if data.invTypeFrom == 11 then
                if data.countTo > 0 and data.countTo <= item.max then
                    Wallet:Get(char, function(wallet)
                        if wallet.Cash >= (item.price * tonumber(data.countTo)) then
                            local toRemoveFromPlayer = (item.price * tonumber(data.countTo))
                            Inventory:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo, function(slotTo)
                                if slotTo == nil then
                                    Inventory:AddSlot(data.ownerTo, data.name, data.countTo, {}, data.slotTo, data.invTypeTo, function(success)
                                        if success then
                                            wallet:Modify(-(toRemoveFromPlayer))
                                            cb({ success = true })

                                        end
                                    end)
                                else
                                    if slotTo ~= nil and data.name ~= slotTo.Name then
                                        return ;
                                    end
                                    if slotTo.Name == data.name then
                                        if (slotTo.Count + data.countTo) <= item.max then
                                            Inventory:AddToSlot(data.ownerTo, data.slotTo, data.countTo, data.invTypeTo, function(success)
                                                if success then
                                                    wallet:Modify(-(toRemoveFromPlayer))
                                                    cb({ success = true })
                                                end
                                            end)
                                        else
                                            Inventory:GetOpenSlot(data.ownerTo, data.invTypeTo, function(i)
                                                if i ~= nil and i > 0 and i <= LoadedEntitys[data.invTypeTo].slots then
                                                    Inventory:AddSlot(data.ownerTo, data.name, data.countTo, {}, i, data.invTypeTo, function(success)
                                                        if success then
                                                            wallet:Modify(-(toRemoveFromPlayer))
                                                            cb({ success = true })
                                                        end
                                                    end)
                                                end
                                            end)
                                        end
                                    else
                                        Inventory:GetOpenSlot(data.ownerTo, data.invTypeTo, function(i)
                                            if i ~= nil and i > 0 and i <= LoadedEntitys[data.invTypeTo].slots then
                                                Inventory:AddSlot(data.ownerTo, data.name, data.countTo, {}, i, data.invTypeTo, function(success)
                                                    if success then
                                                        wallet:Modify(-(toRemoveFromPlayer))
                                                        cb({ success = true })
                                                    end
                                                end)
                                            end
                                        end)
                                    end
                                end
                            end)
                        end
                    end)

                end
            elseif data.invTypeFrom == 12 then

            else
                if data.invTypeTo ~= 11 and data.invTypeTo ~= 12 then
                    if data.ownerFrom == data.ownerTo and data.slotFrom == data.slotTo and data.invTypeFrom == data.invTypeTo then
                        cb(true)
                    elseif data.ownerFrom == data.ownerTo and data.invTypeFrom == data.invTypeTo then
                        -- moving to same inventory as original

                        -- Are we splitting the fooker?
                        if (data.countFrom ~= data.countTo) and (data.slotFrom ~= data.slotTo) then

                            Inventory:GetSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(slotFrom)
                                Inventory:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo, function(slotTo)
                                    if slotTo ~= nil and data.name ~= slotTo.Name then
                                        return ;
                                    end

                                    if data.countFrom >= slotFrom.Count then
                                        Inventory:RemoveAmount(data.ownerFrom, data.slotFrom, data.countTo, data.invTypeFrom, function(success)
                                            if success then
                                                if slotTo == nil then
                                                    Inventory:AddSlot(data.ownerTo, data.name, data.countTo, slotFrom.MetaData, data.slotTo, data.invTypeTo, function(success)
                                                        if success then
                                                            cb({ success = true })
                                                            if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
                                                                processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
                                                            elseif data.invTypeFrom == 10 or data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
                                                                processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
                                                            end
                                                        end
                                                    end)
                                                else
                                                    if slotTo.Name == data.name then
                                                        if (slotTo.Count + data.countTo) <= item.max then
                                                            Inventory:AddToSlot(data.ownerTo, data.slotTo, data.countTo, data.invTypeTo, function(success)
                                                                if success then
                                                                    cb({ success = true })
                                                                    if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
                                                                        processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
                                                                    elseif data.invTypeFrom == 10 or data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
                                                                        processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
                                                                    end
                                                                end
                                                            end)
                                                        else
                                                            Inventory:SwapSlots(data.ownerFrom, data.ownerTo, data.slotFrom, data.slotTo, data.invTypeFrom, data.invTypeTo, function(meh)
                                                                if meh then
                                                                    cb({ success = true })
                                                                    if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
                                                                        processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
                                                                    elseif data.invTypeFrom == 10 or data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
                                                                        processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
                                                                    end
                                                                end
                                                            end)
                                                        end
                                                    else
                                                        Inventory:SwapSlots(data.ownerFrom, data.ownerTo, data.slotFrom, data.slotTo, data.invTypeFrom, data.invTypeTo, function(meh)
                                                            if meh then
                                                                cb({ success = true })
                                                                if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
                                                                    processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
                                                                elseif data.invTypeFrom == 10 or data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
                                                                    processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
                                                                end
                                                            end
                                                        end)
                                                    end
                                                end
                                            end
                                        end)
                                    end
                                end)
                            end)
                        end

                        -- were moving the entire fucking stack ere boys :)
                        if data.countFrom == data.countTo then
                            Inventory:GetSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(slotFrom)
                                Inventory:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo, function(slotTo)
                                    if slotTo == nil then
                                        Inventory:RemoveSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(success)
                                            if success then
                                                Inventory:AddSlot(data.ownerTo, data.name, data.countTo, slotFrom.MetaData, data.slotTo, data.invTypeTo, function(success)
                                                    if success then
                                                        cb({ success = true })
                                                        if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
                                                            processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
                                                        elseif data.invTypeFrom == 10 or data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
                                                            processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
                                                        end
                                                    end
                                                end)
                                            end
                                        end)
                                    else
                                        if slotTo.Name == data.name then
                                            local item = itemsDatabase[data.name]
                                            if (slotTo.Count + data.countTo) <= item.max then
                                                Inventory:RemoveSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(success)
                                                    if success then
                                                        Inventory:AddToSlot(data.ownerTo, data.slotTo, data.countTo, data.invTypeTo, function(success)
                                                            if success then
                                                                cb({ success = true })
                                                                if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
                                                                    processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
                                                                elseif data.invTypeFrom == 10 or data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
                                                                    processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
                                                                end
                                                            end
                                                        end)
                                                    end
                                                end)
                                            else
                                                Inventory:SwapSlots(data.ownerFrom, data.ownerTo, data.slotFrom, data.slotTo, data.invTypeFrom, data.invTypeTo, function(meh)
                                                    if meh then
                                                        cb({ success = true })
                                                        if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
                                                            processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
                                                        elseif data.invTypeFrom == 10 or data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
                                                            processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
                                                        end
                                                    end
                                                end)
                                            end
                                        else
                                            Inventory:SwapSlots(data.ownerFrom, data.ownerTo, data.slotFrom, data.slotTo, data.invTypeFrom, data.invTypeTo, function(meh)
                                                if meh then
                                                    cb({ success = true })
                                                    if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
                                                        processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
                                                    elseif data.invTypeFrom == 10 or data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
                                                        processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
                                                    end
                                                end
                                            end)
                                        end
                                    end
                                end)
                            end)
                        end
                    else
                        -- moving to another inventory
                        if data.countTo ~= data.countFrom then
                            -- Splitting?
                            Inventory:GetSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(slotFrom)
                                Inventory:RemoveAmount(data.ownerFrom, data.slotFrom, data.countTo, data.invTypeFrom, function(success)
                                    if success then
                                        Inventory:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo, function(slotTo)
                                            if slotTo == nil then
                                                Inventory:AddSlot(data.ownerTo, data.name, data.countTo, slotFrom.MetaData, data.slotTo, data.invTypeTo, function(success)
                                                    if success then
                                                        cb({ success = true })
                                                        if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
                                                            processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
                                                        elseif data.invTypeFrom == 10 or data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
                                                            processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
                                                        end
                                                    end
                                                end)
                                            else
                                                if slotTo.Name == data.name then
                                                    if (slotTo.Count + data.countTo) <= item.max then
                                                        Inventory:AddToSlot(data.ownerTo, data.slotTo, data.countTo, data.invTypeTo, function(success)
                                                            if success then
                                                                cb({ success = true })
                                                                if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
                                                                    processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
                                                                elseif data.invTypeFrom == 10 or data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
                                                                    processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
                                                                end
                                                            end
                                                        end)
                                                    else
                                                        Inventory:SwapSlots(data.ownerFrom, data.ownerTo, data.slotFrom, data.slotTo, data.invTypeFrom, data.invTypeTo, function(meh)
                                                            if meh then
                                                                cb({ success = true })
                                                                if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
                                                                    processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
                                                                elseif data.invTypeFrom == 10 or data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
                                                                    processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
                                                                end
                                                            end
                                                        end)
                                                    end
                                                else
                                                    Inventory:SwapSlots(data.ownerFrom, data.ownerTo, data.slotFrom, data.slotTo, data.invTypeFrom, data.invTypeTo, function(meh)
                                                        if meh then
                                                            cb({ success = true })
                                                            if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
                                                                processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
                                                            elseif data.invTypeFrom == 10 or data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
                                                                processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
                                                            end
                                                        end
                                                    end)
                                                end
                                            end
                                        end)
                                    end
                                end)
                            end)
                        else
                            -- Full stack
                            Inventory:GetSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(slotFrom)
                                Inventory:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo, function(slotTo)
                                    if slotTo == nil then
                                        Inventory:RemoveSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(success)
                                            if success then
                                                if slotFrom.invType == 1 and slotFrom.details.type == 2 then
                                                    Inventory:RemoveWeapon(_src, slotFrom._id)
                                                end
                                                Inventory:AddSlot(data.ownerTo, data.name, data.countTo, slotFrom.MetaData, data.slotTo, data.invTypeTo, function(success)
                                                    if success then
                                                        cb({ success = true })
                                                        if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
                                                            processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
                                                        elseif data.invTypeFrom == 10 or data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
                                                            processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
                                                        end
                                                    end
                                                end)
                                            end
                                        end)
                                    else
                                        if slotTo.Name == data.name then
                                            local item = itemsDatabase[data.name]
                                            if (slotTo.Count + data.countTo) <= item.max then
                                                Inventory:RemoveSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(success)
                                                    if success then
                                                        if slotFrom.invType == 1 and slotFrom.details.type == 2 then
                                                            Inventory:RemoveWeapon(_src, slotFrom._id)
                                                        end
                                                        Inventory:AddToSlot(data.ownerTo, data.slotTo, data.countTo, data.invTypeTo, function(success)
                                                            if success then
                                                                cb({ success = true })
                                                                if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
                                                                    processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
                                                                elseif data.invTypeFrom == 10 or data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
                                                                    processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
                                                                end
                                                            end
                                                        end)
                                                    end
                                                end)
                                            else
                                                Inventory:SwapSlots(data.ownerFrom, data.ownerTo, data.slotFrom, data.slotTo, data.invTypeFrom, data.invTypeTo, function(meh)
                                                    if meh then
                                                        if slotFrom.invType == 1 and slotFrom.details.type == 2 then
                                                            Inventory:RemoveWeapon(_src, slotFrom._id)
                                                        end
                                                        cb({ success = true })
                                                        if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
                                                            processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
                                                        elseif data.invTypeFrom == 10 or data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
                                                            processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
                                                        end
                                                    end
                                                end)
                                            end
                                        else
                                            Inventory:SwapSlots(data.ownerFrom, data.ownerTo, data.slotFrom, data.slotTo, data.invTypeFrom, data.invTypeTo, function(meh)
                                                if meh then
                                                    if slotFrom.invType == 1 and slotFrom.details.type == 2 then
                                                        Inventory:RemoveWeapon(_src, slotFrom._id)
                                                    end
                                                    cb({ success = true })
                                                    if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
                                                        processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
                                                    elseif data.invTypeFrom == 10 or data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
                                                        processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
                                                    end
                                                end
                                            end)
                                        end
                                    end
                                end)
                            end)
                        end
                    end
                else
                    -- Error putting item into incompatible storage (e.g shop, etc..)
                end

            end
        else
            -- is there a pwnzer thing for this or ?
            cb({ reason = "Item does not exist" })
        end
    end)
    Callbacks:RegisterServerCallback('Inventory:UseItem', function(source, data, cb)
        Inventory:GetSlot(data.owner, data.slot, data.invType, function(slot)
            Inventory.Items:Use(source, slot, cb)
        end)
    end)
    Callbacks:RegisterServerCallback('Inventory:CheckIfNearDropZone', function(source, data, cb)
        local _src = source
        local playerPed = GetPlayerPed(source)
        local playerCoords = GetEntityCoords(playerPed)
        Inventory:CheckDropZones(playerCoords, function(dropid)
            cb((dropid or nil))
        end)
    end)
    Callbacks:RegisterServerCallback('Inventory:Server:ReceiveAllDrops', function(source, data, cb)
        Database.Game:find({
            collection = 'dropzones',
            query = {}
        }, function(success, results)
            if not success then
                return ;
            end
            local toSend = {}
            for k, v in pairs(results) do
                toSend[v.randomIdent] = { x = v.x, y = v.y, z = v.z }
            end
            cb(toSend)
        end)
    end)
    Callbacks:RegisterServerCallback('Inventory:Server:retreiveStores', function(source, data, cb)
        Database.Game:find({
            collection = 'shops',
            query = {}
        }, function(success, result)
            if not success then
                return ;
            end
            cb(result)
        end)
    end)
end

RegisterServerEvent('Inventory:Server:createNewDropzone')
AddEventHandler('Inventory:Server:createNewDropzone', function()
    local src = source
    local playerPed = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerPed)

    local fuckBecauseFuck = {
        ['x'] = playerCoords.x,
        ['y'] = playerCoords.y,
        ['z'] = playerCoords.z
    }

    Inventory:CreateDropzone(fuckBecauseFuck, function(meh)
        if meh ~= nil and meh > 0 then
            Inventory:OpenSecondary(src, 10, meh)
        end
    end)
end)

RegisterServerEvent('Inventory:Server:openShop')
AddEventHandler('Inventory:Server:openShop', function(shopid)
    local src = source
    if shopid and shopid > 0 then
        Inventory:OpenSecondary(src, 11, shopid)
    end
end)

RegisterServerEvent('Inventory:Server:requestSecondaryInventory')
AddEventHandler('Inventory:Server:requestSecondaryInventory', function(inv)
    Inventory:OpenSecondary(source, inv.invType, inv.owner)
end)

INVENTORY = {
    RemoveWeapon = function(self, src, id)
        if src then
            TriggerClientEvent('Inventory:RemoveWeapon', src, id)
        end
    end,
    ManageDropzone = function(self, dropzoneIdent, cb)
        Database.Game:find({
            collection = 'inventory',
            query = {
                Owner = dropzoneIdent,
                invType = 10
            }
        }, function(success, results)
            if not success then
                return
            end

            if #results > 0 then
                Database.Game:findOne({
                    collection = 'dropzones',
                    query = {
                        randomIdent = dropzoneIdent
                    }
                }, function(success2, dzresults)
                    if not success2 then
                        return
                    end
                    local coordsToAdd = {
                        ['x'] = dzresults[1].x,
                        ['y'] = dzresults[1].y,
                        ['z'] = dzresults[1].z,
                    }
                    TriggerClientEvent('Inventory:Client:ProcessDropzone', -1, 'add', dropzoneIdent, coordsToAdd)
                    cb(true)
                end)
            else
                Database.Game:deleteOne({
                    collection = 'dropzones',
                    query = {
                        randomIdent = dropzoneIdent
                    }
                }, function(success, results)
                    if not success then
                        return
                    end
                    if results > 0 then
                        TriggerClientEvent('Inventory:Client:ProcessDropzone', -1, 'remove', dropzoneIdent)
                        cb(true)
                    end
                end)
            end
        end)
    end,
    CreateDropzone = function(self, coords, cb)
        local generateIdent = math.random(70000000)
        local doc = {
            x = coords.x,
            y = coords.y,
            z = coords.z,
            randomIdent = generateIdent
        }
        Database.Game:insertOne({
            collection = 'dropzones',
            document = doc
        }, function(success, results)
            if not success then
                return
            end

            if cb ~= nil then
                if results > 0 then
                    cb(generateIdent)
                end
            end
        end)
    end,
    CheckDropZones = function(self, coords, cb)
        Database.Game:find({
            collection = 'dropzones',
            query = {

            }
        }, function(success, result)
            if not success then
                cb(nil)
                return ;
            end
            local found = false
            for k, v in pairs(result) do
                local distance = #(coords - vector3(v.x, v.y, v.z))
                if distance < 2.0 then
                    found = true
                    cb(v.randomIdent)
                    break
                end
            end

            if not found then
                cb(nil)
            end
        end)
    end,
    OpenSecondary = function(self, _src, invType, Owner)
        if _src and invType and Owner then
            loadedInventorys[_src] = { owner = Owner, invType = tonumber(invType), source = tonumber(_src) }
            if loadedInventorys[_src] then
                local reqInt = loadedInventorys[_src]
                Inventory:Get(Owner, invType, function(inventory)
                    loadedInventorys[_src].entity = { slots = (tonumber(LoadedEntitys[invType].slots) or 10), name = (LoadedEntitys[invType].name or "Unknown") }
                    local requestedInventory = {
                        size = LoadedEntitys[tonumber(invType)].slots or 10,
                        name = LoadedEntitys[tonumber(invType)].name or "Unknown",
                        inventory = inventory.inventory,
                        invType = invType,
                        owner = Owner
                    }
                    TriggerClientEvent('Inventory:client:loadSecondary', _src, requestedInventory)
                end)
            end
        end
    end,
    Get = function(self, Owner, Type, cb)
        if Type == 11 then
            local returnTable = {}
            Database.Game:findOne({
                collection = 'shops',
                id = Owner
            }, function(success, results)
                if not success then
                    return ;
                end
                local items = {}
                for k, v in pairs(Config.ShopItemSets[results[1].shop_itemset]) do
                    items[tostring(k)] = { Slot = k, Label = itemsDatabase[v].label, Image = itemsDatabase[v].image, Count = 50, Name = v, invType = 11, MetaData = {}, Owner = tostring(Owner), Price = itemsDatabase[v].price }
                end
                cb({
                    inventory = items,
                    owner = Owner,
                    InvType = Type
                })

            end)
        else
            Database.Game:find({
                collection = 'inventory',
                query = {
                    Owner = Owner,
                    invType = Type
                }
            }, function(success, results)
                if not success then
                    return
                end
                local table = {}
                for k, v in ipairs(results) do
                    v.Image = itemsDatabase[v.Name].image
                    v.Label = itemsDatabase[v.Name].label
                    table[tostring(v.Slot)] = v
                end
                cb({
                    inventory = table,
                    owner = Owner,
                    InvType = Type
                })
            end)
        end
    end,
    GetOpenSlot = function(self, Owner, invType, cb)
        Database.Game:find({
            collection = 'inventory',
            query = {
                Owner = Owner,
                invType = invType
            },
            options = {
                sort = {
                    Slot = 1
                }
            },
        }, function(success, results)
            if not success then
                return
            end
            for i = 1, #results, 1 do
                local slot = results[i]
                if i ~= slot.Slot then
                    cb(i)
                    return
                end
            end
            cb(#results + 1)
        end)
    end,
    GetMatchingSlot = function(self, Owner, Name, invType, cb)
        Database.Game:findOne({
            collection = 'inventory',
            query = {
                Owner = Owner,
                Name = Name,
                invType = invType
            }
        }, function(success, results)
            if not success then
                return
            end
            if #results == 0 then
                Logger:Error('Inventory', 'Could not find Matching Slot for ' .. Name .. ' for ' .. Owner, { console = false })
                cb(nil)
                return
            end
            cb(results[1])
        end)
    end,
    MoveSlot = function(self, OwnerFrom, OwnerTo, SlotFrom, SlotTo, invTypeFrom, invTypeTo, cb)
        Inventory:GetSlot(OwnerFrom, SlotFrom, invTypeFrom, function(slot)
            Inventory:UpdateSlot(slot._id, OwnerTo, SlotTo, invTypeTo, cb)
        end)
    end,
    SwapSlots = function(self, OwnerFrom, OwnerTo, SlotFrom, SlotTo, invTypeFrom, invTypeTo, cb)
        Inventory:GetSlot(OwnerFrom, SlotFrom, invTypeFrom, function(slotFrom)
            Inventory:GetSlot(OwnerTo, SlotTo, invTypeTo, function(slotTo)
                Inventory:UpdateSlot(slotFrom._id, OwnerTo, SlotTo, invTypeTo, function(success)
                    if success then
                        Inventory:UpdateSlot(slotTo._id, OwnerFrom, SlotFrom, invTypeFrom, function(success)
                            cb(success)
                        end)
                    end
                end)
            end)
        end)
    end,
    UpdateSlot = function(self, id, Owner, Slot, invType, cb)
        Database.Game:updateOne({
            collection = 'inventory',
            query = {
                _id = id
            },
            update = {
                ['$set'] = {
                    Owner = Owner,
                    Slot = Slot,
                    invType = invType
                }
            }
        }, function(success, results)
            if not success then
                return
            end
            if cb ~= nil then
                cb(results > 0)
            end
        end)
    end,
    GetFreeSlotNumbers = function(self, Owner, invType, cb)
        Database.Game:find({
            collection = 'inventory',
            query = {
                Owner = Owner,
                invType = invType
            }
        }, function(success, result)
            if not success then
                return ;
            end
            local occupiedTable = {}
            local unOccupiedSlots = {}
            for k, v in pairs(result) do
                occupiedTable[v.Slot] = true
            end

            for i = 1, LoadedEntitys[invType].slots do
                if not occupiedTable[i] then
                    unOccupiedSlots[i] = true
                end
            end
            cb(unOccupiedSlots)
        end)
    end,
    GetSlot = function(self, Owner, Slot, invType, cb)
        Database.Game:findOne({
            collection = 'inventory',
            query = {
                Owner = Owner,
                Slot = Slot,
                invType = invType
            }
        }, function(success, results)
            if not success then
                return
            end
            if #results == 0 then
                Logger:Error('Inventory', 'Slot ' .. Slot .. ' Does Not Exists for ' .. Owner, { console = false })
                cb(nil)
                return
            end
            Items:GetItem(results[1].Name, function(itemExist)
                results[1].details = itemExist
                cb(results[1])
            end)
        end)
    end,
    AddItem = function(self, Owner, Name, Count, MetaData, invType)
        Items:GetItem(Name, function(itemExist)
            if itemExist then
                if itemExist.type == 2 then
                    if not MetaData.SerialNumber then
                        MetaData.SerialNumber = math.random(10000000, 99999999)
                    end
                end

                if (itemExist.isUnique and not itemExist.isStackable) then
                    Inventory:GetFreeSlotNumbers(Owner, invType, function(slots)
                        if Utils:GetTableLength(slots) >= Count then
                            local totalGiven = 0
                            for k, v in pairs(slots) do
                                Inventory:AddSlot(Owner, Name, 1, MetaData, k, invType)
                                totalGiven = totalGiven + 1
                                if totalGiven == Count then
                                    break ;
                                end
                            end
                        end
                    end)
                else
                    if Count <= itemExist.max then
                        Inventory:GetMatchingSlot(Owner, Name, invType, function(mSlot)
                            if mSlot == nil then
                                Inventory:GetOpenSlot(Owner, invType, function(oSlot)
                                    Inventory:AddSlot(Owner, Name, Count, MetaData, oSlot, invType)
                                end)
                            else
                                if (mSlot.Count + Count) <= LoadedEntitys[mSlot.invType].slots then
                                    Inventory:AddToSlot(Owner, mSlot.Slot, Count, invType)
                                else
                                    Inventory:GetOpenSlot(Owner, invType, function(gammaSlot)
                                        if gammaSlot ~= nil and gammaSlot > 0 and gammaSlot <= LoadedEntitys[invType].slots then
                                            Inventory:AddSlot(Owner, Name, Count, MetaData, gammaSlot, invType)
                                        else
                                            -- no availiable slots.
                                        end
                                    end)
                                end
                            end
                        end)
                    end
                end
            end
        end)
    end,
    RemoveItem = function(self, Owner, Name, Count, Slot, invType, cb)
        Inventory:GetSlot(Owner, Slot, invType, function(slot)
            if slot == nil then
                Logger:Error('Inventory', 'Failed to remove ' .. Count .. ' from Slot ' .. Slot .. ' for ' .. Owner, { console = false })
                return
            end
            if slot.Count - Count <= 0 then
                Inventory:RemoveSlot(Owner, slot.Slot, invType)
            else
                Inventory:RemoveFromSlot(Owner, slot.Slot, invType, Count)
                continue = false
            end
            if cb then
                cb(true)
            end
        end)
    end,
    AddSlot = function(self, Owner, Name, Count, MetaData, Slot, invType, cb)
        Database.Game:findOne({
            collection = 'inventory',
            query = {
                Owner = Owner,
                Slot = Slot,
                invType = invType
            }
        }, function(success, results)
            if not success then
                return
            end
            if #results > 0 then
                Logger:Error('Inventory', 'Slot ' .. Slot .. ' Already Exists for ' .. Owner, { console = false })
                return
            end
            local doc = {
                Owner = Owner,
                Name = Name,
                Count = Count,
                MetaData = MetaData,
                Slot = Slot,
                invType = invType
            }
            Database.Game:insertOne({
                collection = 'inventory',
                document = doc
            }, function(success, results)
                if not success then
                    return
                end
                if cb ~= nil then
                    cb(results > 0)
                end
            end)
        end)
    end,
    RemoveAmount = function(self, owner, slot, amount, invType, cb)
        Database.Game:findOne({
            collection = 'inventory',
            query = {
                Owner = owner,
                Slot = slot,
                invType = invType
            }
        }, function(success, results)
            if not success then
                return
            end
            if #results == 0 then
                Logger:Error('Inventory', 'Slot ' .. slot .. ' Does Not Exists for ' .. owner, { console = false })
                return
            end
            Database.Game:updateOne({
                collection = 'inventory',
                query = {
                    Owner = owner,
                    Slot = slot,
                    invType = invType
                },
                update = {
                    ['$inc'] = { Count = (amount * -1) }
                }
            }, function(success, results)
                if not success then
                    return
                end
                if cb ~= nil then
                    cb(results > 0)
                end
            end)
        end)
    end,
    RemoveSlot = function(self, Owner, Slot, invType, cb)
        Database.Game:findOne({
            collection = 'inventory',
            query = {
                Owner = Owner,
                Slot = Slot,
                invType = invType
            }
        }, function(success, results)
            if not success then
                return
            end
            if #results == 0 then
                Logger:Error('Inventory', 'Slot ' .. Slot .. ' Does Not Exists for ' .. Owner, { console = false })
                return
            end
            Database.Game:deleteOne({
                collection = 'inventory',
                query = {
                    Owner = Owner,
                    Slot = Slot,
                    invType = invType
                }
            }, function(success, results)
                if not success then
                    return
                end
                if cb ~= nil then
                    cb(results > 0)
                end
            end)
        end)
    end,
    AddToSlot = function(self, Owner, Slot, Count, invType, cb)
        Database.Game:updateOne({
            collection = 'inventory',
            query = {
                Owner = Owner,
                Slot = Slot,
                invType = invType
            },
            update = {
                ['$inc'] = {
                    Count = Count
                }
            }
        }, function(success, results)
            if not success then
                return
            end
            if results == 0 then
                Logger:Error('Inventory', 'Slot ' .. Slot .. ' Does Not Exists for ' .. Owner, { console = false })
                if cb ~= nil then
                    cb(results > 0)
                end
                return
            end
            if cb ~= nil then
                cb(results > 0)
            end
        end)
    end,
    RemoveFromSlot = function(self, Owner, Slot, Count, invType, cb)
        Database.Game:updateOne({
            collection = 'inventory',
            query = {
                Owner = Owner,
                Slot = Slot,
                invType = invType
            },
            update = {
                ['$inc'] = {
                    Count = -Count
                }
            }
        }, function(success, results)
            if not success then
                return
            end
            if results == 0 then
                Logger:Error('Inventory', 'Slot ' .. Slot .. ' Does Not Exists for ' .. Owner, { console = false })
                if cb ~= nil then
                    cb(results > 0)
                end
                return
            end
            if cb ~= nil then
                cb(results > 0)
            end
        end)
    end,
    DoSlotsMatch = function(self, Left, Right)
        local metaMatch = true

        for k, v in pairs(Left.MetaData) do
            if Right[k] ~= Left[k] then
                metaMatch = false
                break
            end
        end

        for k, v in pairs(Right.MetaData) do
            if Right[k] ~= Left[k] then
                metaMatch = false
                break
            end
        end

        return Left.Name == Right.Name and metaMatch
    end,
    Items = {
        RegisterUse = function(self, name, component, cb)
            if ItemCallbacks[name] == nil then
                ItemCallbacks[name] = {}
            end
            ItemCallbacks[name][component] = cb
        end,
        Use = function(self, source, item, cb)
            TriggerClientEvent('Markers:ItemAction', source, item)
            if ItemCallbacks[item.Name] ~= nil then
                for k, callback in pairs(ItemCallbacks[item.Name]) do
                    callback(source, item)
                end
            end
            Items:GetItem(item.Name, function(itemExists)
                if itemExists.closeUi then
                    TriggerClientEvent('Inventory:CloseUI', source)
                end
            end)
            cb(true)
        end
    }
}

ItemCallbacks = {}