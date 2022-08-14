function REGISTER_CALLBACKS()
  Callbacks:RegisterServerCallback('Inventory:FetchPlayerInventory', function(source, data, cb)
    local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
    local char = player:GetData('Character')

    Inventory:Get(char:GetData('ID'), 1, function(inventory)
      cb({
        size = (LOADED_ENTITIES[1].slots or 10),
        name = "Player",
        inventory = inventory.inventory,
        invType = 1,
        owner = char:GetData('ID')
      })
    end)
  end)

  Callbacks:RegisterServerCallback('Inventory:FetchSecondaryInventory', function(source, data, cb)
    local src = source
    local reqInt = loadedInventorys[src]
    if reqInt then
      Inventory:Get(reqInt.owner, reqInt.invType, function(inventory)
        cb({
          size = LOADED_ENTITIES[reqInt.invType].slots,
          name = LOADED_ENTITIES[reqInt.invType].name,
          inventory = inventory.inventory,
          invType = reqInt.invType,
          owner = reqInt.owner
        })
      end)
    end
  end)

  Callbacks:RegisterServerCallback('Inventory:Server:HasItem', function(source, data, cb)
    local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
    local char = player:GetData('Character')

    Inventory:GetMatchingSlot(char:GetData('ID'), data.item, 1, cb)
  end)

  Callbacks:RegisterServerCallback('Inventory:Server:RemoveItem', function(source, data, cb)
    if data.item.charId and data.item.id and data.item.slot and data.item.invType then
      Inventory:RemoveItem(data.item.charId, data.item.id, (data.amount or 1), data.item.slot, data.item.invType, cb)
    end
  end)

  Callbacks:RegisterServerCallback('Inventory:UseItem', function(source, data, cb)
    Inventory:GetSlot(data.owner, data.slot, data.invType, function(slot)
      Inventory.Items:Use(source, slot, cb)
    end)
  end)

  Callbacks:RegisterServerCallback('Inventory:CheckIfNearDropZone', function(source, data, cb)
    local player = GetPlayerPed(source)
    local pCoords = GetEntityCoords(player)

    Inventory:CheckDropZones(pCoords, function(dropId)
      cb(dropId or nil)
    end)
  end)

  Callbacks:RegisterServerCallback('Inventory:Server:ReceiveAllDrops', function(source, data, cb)
    Database.Game:find({
      collection = 'dropzones',
      query = {}
    }, function(success, results)
      if not success then return end

      local toSend = {}
      for _, drop in pairs(results) do
        toSend[drop.randomIdent] = {
          x = drop.x,
          y = drop.y,
          z = drop.z
        }
      end

      cb(toSend)
    end)
  end)

  -- Callbacks:RegisterServerCallback('Inventory:MoveItem', function(source, data, cb)
  --   local _src = source
  --   local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
  --   local char = player:GetData('Character')
  --   if itemsDatabase[data.name] then
  --     local item = itemsDatabase[data.name]

  --     if data.invTypeFrom == 11 then
  --       if data.countTo > 0 and data.countTo <= item.max then
  --         Wallet:Get(char, function(wallet)
  --           if wallet.Cash >= (item.price * tonumber(data.countTo)) then
  --             local toRemoveFromPlayer = (item.price * tonumber(data.countTo))
  --             Inventory:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo, function(slotTo)
  --               if slotTo == nil then
  --                 Inventory:AddSlot(data.ownerTo, data.name, data.countTo, {}, data.slotTo, data.invTypeTo,
  --                   function(success)
  --                     if success then
  --                       wallet:Modify(-(toRemoveFromPlayer))
  --                       cb({ success = true })

  --                     end
  --                   end)
  --               else
  --                 if slotTo ~= nil and data.name ~= slotTo.Name then
  --                   return;
  --                 end
  --                 if slotTo.Name == data.name then
  --                   if (slotTo.Count + data.countTo) <= item.max then
  --                     Inventory:AddToSlot(data.ownerTo, data.slotTo, data.countTo, data.invTypeTo, function(success)
  --                       if success then
  --                         wallet:Modify(-(toRemoveFromPlayer))
  --                         cb({ success = true })
  --                       end
  --                     end)
  --                   else
  --                     Inventory:GetOpenSlot(data.ownerTo, data.invTypeTo, function(i)
  --                       if i ~= nil and i > 0 and i <= LOADED_ENTITIES[data.invTypeTo].slots then
  --                         Inventory:AddSlot(data.ownerTo, data.name, data.countTo, {}, i, data.invTypeTo,
  --                           function(success)
  --                             if success then
  --                               wallet:Modify(-(toRemoveFromPlayer))
  --                               cb({ success = true })
  --                             end
  --                           end)
  --                       end
  --                     end)
  --                   end
  --                 else
  --                   Inventory:GetOpenSlot(data.ownerTo, data.invTypeTo, function(i)
  --                     if i ~= nil and i > 0 and i <= LOADED_ENTITIES[data.invTypeTo].slots then
  --                       Inventory:AddSlot(data.ownerTo, data.name, data.countTo, {}, i, data.invTypeTo,
  --                         function(success)
  --                           if success then
  --                             wallet:Modify(-(toRemoveFromPlayer))
  --                             cb({ success = true })
  --                           end
  --                         end)
  --                     end
  --                   end)
  --                 end
  --               end
  --             end)
  --           end
  --         end)

  --       end
  --     elseif data.invTypeFrom == 12 then

  --     else
  --       if data.invTypeTo ~= 11 and data.invTypeTo ~= 12 then
  --         if data.ownerFrom == data.ownerTo and data.slotFrom == data.slotTo and data.invTypeFrom == data.invTypeTo then
  --           cb(true)
  --         elseif data.ownerFrom == data.ownerTo and data.invTypeFrom == data.invTypeTo then
  --           -- moving to same inventory as original

  --           -- Are we splitting the fooker?
  --           if (data.countFrom ~= data.countTo) and (data.slotFrom ~= data.slotTo) then

  --             Inventory:GetSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(slotFrom)
  --               Inventory:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo, function(slotTo)
  --                 if slotTo ~= nil and data.name ~= slotTo.Name then
  --                   return;
  --                 end

  --                 if data.countFrom >= slotFrom.Count then
  --                   Inventory:RemoveAmount(data.ownerFrom, data.slotFrom, data.countTo, data.invTypeFrom,
  --                     function(success)
  --                       if success then
  --                         if slotTo == nil then
  --                           Inventory:AddSlot(data.ownerTo, data.name, data.countTo, slotFrom.MetaData, data.slotTo,
  --                             data.invTypeTo, function(success)
  --                             if success then
  --                               cb({ success = true })
  --                               if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
  --                                 processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
  --                               elseif data.invTypeFrom == 10 or
  --                                   data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
  --                                 processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
  --                               end
  --                             end
  --                           end)
  --                         else
  --                           if slotTo.Name == data.name then
  --                             if (slotTo.Count + data.countTo) <= item.max then
  --                               Inventory:AddToSlot(data.ownerTo, data.slotTo, data.countTo, data.invTypeTo,
  --                                 function(success)
  --                                   if success then
  --                                     cb({ success = true })
  --                                     if data.invTypeTo == 10 or
  --                                         (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
  --                                       processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
  --                                     elseif data.invTypeFrom == 10 or
  --                                         data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
  --                                       processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
  --                                     end
  --                                   end
  --                                 end)
  --                             else
  --                               Inventory:SwapSlots(data.ownerFrom, data.ownerTo, data.slotFrom, data.slotTo,
  --                                 data.invTypeFrom, data.invTypeTo, function(meh)
  --                                 if meh then
  --                                   cb({ success = true })
  --                                   if data.invTypeTo == 10 or
  --                                       (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
  --                                     processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
  --                                   elseif data.invTypeFrom == 10 or
  --                                       data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
  --                                     processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
  --                                   end
  --                                 end
  --                               end)
  --                             end
  --                           else
  --                             Inventory:SwapSlots(data.ownerFrom, data.ownerTo, data.slotFrom, data.slotTo,
  --                               data.invTypeFrom, data.invTypeTo, function(meh)
  --                               if meh then
  --                                 cb({ success = true })
  --                                 if data.invTypeTo == 10 or
  --                                     (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')
  --                                     ) then
  --                                   processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
  --                                 elseif data.invTypeFrom == 10 or
  --                                     data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
  --                                   processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
  --                                 end
  --                               end
  --                             end)
  --                           end
  --                         end
  --                       end
  --                     end)
  --                 end
  --               end)
  --             end)
  --           end

  --           -- were moving the entire fucking stack ere boys :)
  --           if data.countFrom == data.countTo then
  --             Inventory:GetSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(slotFrom)
  --               Inventory:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo, function(slotTo)
  --                 if slotTo == nil then
  --                   Inventory:RemoveSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(success)
  --                     if success then
  --                       Inventory:AddSlot(data.ownerTo, data.name, data.countTo, slotFrom.MetaData, data.slotTo,
  --                         data.invTypeTo, function(success)
  --                         if success then
  --                           cb({ success = true })
  --                           if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
  --                             processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
  --                           elseif data.invTypeFrom == 10 or
  --                               data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
  --                             processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
  --                           end
  --                         end
  --                       end)
  --                     end
  --                   end)
  --                 else
  --                   if slotTo.Name == data.name then
  --                     local item = itemsDatabase[data.name]
  --                     if (slotTo.Count + data.countTo) <= item.max then
  --                       Inventory:RemoveSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(success)
  --                         if success then
  --                           Inventory:AddToSlot(data.ownerTo, data.slotTo, data.countTo, data.invTypeTo,
  --                             function(success)
  --                               if success then
  --                                 cb({ success = true })
  --                                 if data.invTypeTo == 10 or
  --                                     (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')
  --                                     ) then
  --                                   processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
  --                                 elseif data.invTypeFrom == 10 or
  --                                     data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
  --                                   processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
  --                                 end
  --                               end
  --                             end)
  --                         end
  --                       end)
  --                     else
  --                       Inventory:SwapSlots(data.ownerFrom, data.ownerTo, data.slotFrom, data.slotTo, data.invTypeFrom,
  --                         data.invTypeTo, function(meh)
  --                         if meh then
  --                           cb({ success = true })
  --                           if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
  --                             processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
  --                           elseif data.invTypeFrom == 10 or
  --                               data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
  --                             processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
  --                           end
  --                         end
  --                       end)
  --                     end
  --                   else
  --                     Inventory:SwapSlots(data.ownerFrom, data.ownerTo, data.slotFrom, data.slotTo, data.invTypeFrom,
  --                       data.invTypeTo, function(meh)
  --                       if meh then
  --                         cb({ success = true })
  --                         if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
  --                           processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
  --                         elseif data.invTypeFrom == 10 or data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
  --                           processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
  --                         end
  --                       end
  --                     end)
  --                   end
  --                 end
  --               end)
  --             end)
  --           end
  --         else
  --           -- moving to another inventory
  --           if data.countTo ~= data.countFrom then
  --             -- Splitting?
  --             Inventory:GetSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(slotFrom)
  --               Inventory:RemoveAmount(data.ownerFrom, data.slotFrom, data.countTo, data.invTypeFrom,
  --                 function(success)
  --                   if success then
  --                     Inventory:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo, function(slotTo)
  --                       if slotTo == nil then
  --                         Inventory:AddSlot(data.ownerTo, data.name, data.countTo, slotFrom.MetaData, data.slotTo,
  --                           data.invTypeTo, function(success)
  --                           if success then
  --                             cb({ success = true })
  --                             if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
  --                               processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
  --                             elseif data.invTypeFrom == 10 or
  --                                 data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
  --                               processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
  --                             end
  --                           end
  --                         end)
  --                       else
  --                         if slotTo.Name == data.name then
  --                           if (slotTo.Count + data.countTo) <= item.max then
  --                             Inventory:AddToSlot(data.ownerTo, data.slotTo, data.countTo, data.invTypeTo,
  --                               function(success)
  --                                 if success then
  --                                   cb({ success = true })
  --                                   if data.invTypeTo == 10 or
  --                                       (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
  --                                     processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
  --                                   elseif data.invTypeFrom == 10 or
  --                                       data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
  --                                     processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
  --                                   end
  --                                 end
  --                               end)
  --                           else
  --                             Inventory:SwapSlots(data.ownerFrom, data.ownerTo, data.slotFrom, data.slotTo,
  --                               data.invTypeFrom, data.invTypeTo, function(meh)
  --                               if meh then
  --                                 cb({ success = true })
  --                                 if data.invTypeTo == 10 or
  --                                     (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')
  --                                     ) then
  --                                   processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
  --                                 elseif data.invTypeFrom == 10 or
  --                                     data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
  --                                   processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
  --                                 end
  --                               end
  --                             end)
  --                           end
  --                         else
  --                           Inventory:SwapSlots(data.ownerFrom, data.ownerTo, data.slotFrom, data.slotTo,
  --                             data.invTypeFrom, data.invTypeTo, function(meh)
  --                             if meh then
  --                               cb({ success = true })
  --                               if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
  --                                 processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
  --                               elseif data.invTypeFrom == 10 or
  --                                   data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
  --                                 processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
  --                               end
  --                             end
  --                           end)
  --                         end
  --                       end
  --                     end)
  --                   end
  --                 end)
  --             end)
  --           else
  --             -- Full stack
  --             Inventory:GetSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(slotFrom)
  --               Inventory:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo, function(slotTo)
  --                 if slotTo == nil then
  --                   Inventory:RemoveSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(success)
  --                     if success then
  --                       if slotFrom.invType == 1 and slotFrom.details.type == 2 then
  --                         Inventory:RemoveWeapon(_src, slotFrom._id)
  --                       end
  --                       Inventory:AddSlot(data.ownerTo, data.name, data.countTo, slotFrom.MetaData, data.slotTo,
  --                         data.invTypeTo, function(success)
  --                         if success then
  --                           cb({ success = true })
  --                           if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
  --                             processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
  --                           elseif data.invTypeFrom == 10 or
  --                               data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
  --                             processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
  --                           end
  --                         end
  --                       end)
  --                     end
  --                   end)
  --                 else
  --                   if slotTo.Name == data.name then
  --                     local item = itemsDatabase[data.name]
  --                     if (slotTo.Count + data.countTo) <= item.max then
  --                       Inventory:RemoveSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(success)
  --                         if success then
  --                           if slotFrom.invType == 1 and slotFrom.details.type == 2 then
  --                             Inventory:RemoveWeapon(_src, slotFrom._id)
  --                           end
  --                           Inventory:AddToSlot(data.ownerTo, data.slotTo, data.countTo, data.invTypeTo,
  --                             function(success)
  --                               if success then
  --                                 cb({ success = true })
  --                                 if data.invTypeTo == 10 or
  --                                     (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')
  --                                     ) then
  --                                   processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
  --                                 elseif data.invTypeFrom == 10 or
  --                                     data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
  --                                   processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
  --                                 end
  --                               end
  --                             end)
  --                         end
  --                       end)
  --                     else
  --                       Inventory:SwapSlots(data.ownerFrom, data.ownerTo, data.slotFrom, data.slotTo, data.invTypeFrom,
  --                         data.invTypeTo, function(meh)
  --                         if meh then
  --                           if slotFrom.invType == 1 and slotFrom.details.type == 2 then
  --                             Inventory:RemoveWeapon(_src, slotFrom._id)
  --                           end
  --                           cb({ success = true })
  --                           if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
  --                             processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
  --                           elseif data.invTypeFrom == 10 or
  --                               data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
  --                             processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
  --                           end
  --                         end
  --                       end)
  --                     end
  --                   else
  --                     Inventory:SwapSlots(data.ownerFrom, data.ownerTo, data.slotFrom, data.slotTo, data.invTypeFrom,
  --                       data.invTypeTo, function(meh)
  --                       if meh then
  --                         if slotFrom.invType == 1 and slotFrom.details.type == 2 then
  --                           Inventory:RemoveWeapon(_src, slotFrom._id)
  --                         end
  --                         cb({ success = true })
  --                         if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= char:GetData('ID')) then
  --                           processRefreshForClients(data.ownerTo, data.invTypeTo, _src)
  --                         elseif data.invTypeFrom == 10 or data.invTypeFrom == 1 and data.ownerFrom ~= char:GetData('ID') then
  --                           processRefreshForClients(data.ownerFrom, data.invTypeFrom, _src)
  --                         end
  --                       end
  --                     end)
  --                   end
  --                 end
  --               end)
  --             end)
  --           end
  --         end
  --       else
  --         -- Error putting item into incompatible storage (e.g shop, etc..)
  --       end

  --     end
  --   else
  --     -- is there a pwnzer thing for this or ?
  --     cb({ reason = "Item does not exist" })
  --   end
  -- end)

end

function REGISTER_ITEM_CALLBACKS()
  Callbacks:RegisterServerCallback('Items:Get', function(source, data, cb)
    cb(SHARED_ITEMS)
  end)

  Callbacks:RegisterServerCallback('Items:GetItem', function(source, data, cb)
    if data and data.item then
      cb(SHARED_ITEMS[data.item])
    end
  end)
end
