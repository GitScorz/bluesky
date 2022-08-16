function REGISTER_CALLBACKS()
  Callbacks:RegisterServerCallback('Inventory:FetchPlayerInventory', function(source, data, cb)
    local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
    local char = player:GetData('Character')

    Inventory:Get(char:GetData('ID'), 1, function(inventory)
      cb({
        owner = char:GetData('ID'),
        size = (LOADED_ENTITIES[1].slots or 10),
        name = "Player",
        inventory = inventory.inventory,
        invType = 1,
        maxWeight = Config.MaxWeight,
        weight = CalculateWeight(inventory.inventory),
      })
    end)
  end)

  Callbacks:RegisterServerCallback('Inventory:FetchSecondaryInventory', function(source, data, cb)
    local src = source
    local reqInt = LOADED_INVENTORIES[src]
    if reqInt then
      Inventory:Get(reqInt.owner, reqInt.invType, function(inventory)
        cb({
          size = LOADED_ENTITIES[reqInt.invType].slots,
          name = LOADED_ENTITIES[reqInt.invType].name,
          maxWeight = LOADED_ENTITIES[reqInt.invType].maxWeight,
          weight = CalculateWeight(inventory.inventory),
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

      local drops = {}
      for _, drop in pairs(results) do
        dropData[drop.randomIdent] = {
          x = drop.x,
          y = drop.y,
          z = drop.z
        }
      end

      cb(drops)
    end)
  end)

  Callbacks:RegisterServerCallback('Inventory:MoveItem', function(source, data, cb)
    local _src = source
    local player = exports['bs_base']:FetchComponent('Fetch'):Source(_src)
    local char = player:GetData('Character')

    local itemId = data.id
    local charId = char:GetData('ID')

    if Inventory:IsValidItem(itemId) then
      local item = SHARED_ITEMS[itemId]

      --### SHOP ###--
      if data.invTypeFrom == 11 and data.invTypeTo ~= 11 then
        if data.quantityTo > 0 then
          Wallet:Get(charId, function(wallet)
            if wallet.money >= data.quantityTo * item.price then
              Inventory.AddItem(charId, itemId, data.quantityTo, {}, data.invTypeTo, _src)
            else
              TriggerClientEvent('Notification:SendError', _src, 'Insufficient funds.')
              cb(false)
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
            if (data.quantityFrom ~= data.quantityTo) and (data.slotFrom ~= data.slotTo) then

              Inventory:GetSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(slotFrom)
                Inventory:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo, function(slotTo)
                  if slotTo ~= nil and itemId ~= slotTo.id then
                    return;
                  end

                  if data.quantityFrom >= slotFrom.quantity then
                    Inventory:RemoveAmount(data.ownerFrom, data.slotFrom, data.quantityTo, data.invTypeFrom,
                      function(success)
                        if success then
                          if slotTo == nil then
                            Inventory:AddSlot(data.ownerTo, itemId, data.quantityTo, slotFrom.metaData, data.slotTo,
                              data.invTypeTo, function(success)
                              if success then
                                cb(true)
                                if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= charId) then
                                  REFRESH_ALL_CLIENTS(data.ownerTo, data.invTypeTo, _src)
                                elseif data.invTypeFrom == 10 or
                                    data.invTypeFrom == 1 and data.ownerFrom ~= charId then
                                  REFRESH_ALL_CLIENTS(data.ownerFrom, data.invTypeFrom, _src)
                                end
                              end
                            end)
                          else
                            if slotTo.id == itemId then
                              Inventory:AddToSlot(data.ownerTo, data.slotTo, data.quantityTo, data.invTypeTo,
                                function(success)
                                  if success then
                                    cb(true)
                                    if data.invTypeTo == 10 or
                                        (data.invTypeTo == 1 and data.ownerTo ~= charId) then
                                      REFRESH_ALL_CLIENTS(data.ownerTo, data.invTypeTo, _src)
                                    elseif data.invTypeFrom == 10 or
                                        data.invTypeFrom == 1 and data.ownerFrom ~= charId then
                                      REFRESH_ALL_CLIENTS(data.ownerFrom, data.invTypeFrom, _src)
                                    end
                                  end
                                end)
                            else
                              Inventory:SwapSlots(data.ownerFrom, data.ownerTo, data.slotFrom, data.slotTo,
                                data.invTypeFrom, data.invTypeTo, function(meh)
                                if meh then
                                  cb(true)
                                  if data.invTypeTo == 10 or
                                      (data.invTypeTo == 1 and data.ownerTo ~= charId
                                      ) then
                                    REFRESH_ALL_CLIENTS(data.ownerTo, data.invTypeTo, _src)
                                  elseif data.invTypeFrom == 10 or
                                      data.invTypeFrom == 1 and data.ownerFrom ~= charId then
                                    REFRESH_ALL_CLIENTS(data.ownerFrom, data.invTypeFrom, _src)
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
            if data.quantityFrom == data.quantityTo then
              Inventory:GetSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(slotFrom)
                Inventory:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo, function(slotTo)
                  if slotTo == nil then
                    Inventory:RemoveSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(success)
                      if success then
                        Inventory:AddSlot(data.ownerTo, itemId, data.quantityTo, slotFrom.metaData, data.slotTo,
                          data.invTypeTo, function(success)
                          if success then
                            cb(true)
                            if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= charId) then
                              REFRESH_ALL_CLIENTS(data.ownerTo, data.invTypeTo, _src)
                            elseif data.invTypeFrom == 10 or
                                data.invTypeFrom == 1 and data.ownerFrom ~= charId then
                              REFRESH_ALL_CLIENTS(data.ownerFrom, data.invTypeFrom, _src)
                            end
                          end
                        end)
                      end
                    end)
                  else
                    if slotTo.id == itemId then
                      local item = SHARED_ITEMS[itemId]
                      Inventory:RemoveSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(success)
                        if success then
                          Inventory:AddToSlot(data.ownerTo, data.slotTo, data.quantityTo, data.invTypeTo,
                            function(success)
                              if success then
                                cb(true)
                                if data.invTypeTo == 10 or
                                    (data.invTypeTo == 1 and data.ownerTo ~= charId
                                    ) then
                                  REFRESH_ALL_CLIENTS(data.ownerTo, data.invTypeTo, _src)
                                elseif data.invTypeFrom == 10 or
                                    data.invTypeFrom == 1 and data.ownerFrom ~= charId then
                                  REFRESH_ALL_CLIENTS(data.ownerFrom, data.invTypeFrom, _src)
                                end
                              end
                            end)
                        end
                      end)
                    else
                      Inventory:SwapSlots(data.ownerFrom, data.ownerTo, data.slotFrom, data.slotTo, data.invTypeFrom,
                        data.invTypeTo, function(meh)
                        if meh then
                          cb(true)
                          if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= charId) then
                            REFRESH_ALL_CLIENTS(data.ownerTo, data.invTypeTo, _src)
                          elseif data.invTypeFrom == 10 or data.invTypeFrom == 1 and data.ownerFrom ~= charId then
                            REFRESH_ALL_CLIENTS(data.ownerFrom, data.invTypeFrom, _src)
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
            if data.quantityTo ~= data.quantityFrom then
              -- Splitting?
              Inventory:GetSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(slotFrom)
                Inventory:RemoveAmount(data.ownerFrom, data.slotFrom, data.quantityTo, data.invTypeFrom,
                  function(success)
                    if success then
                      Inventory:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo, function(slotTo)
                        if slotTo == nil then
                          Inventory:AddSlot(data.ownerTo, itemId, data.quantityTo, slotFrom.metaData, data.slotTo,
                            data.invTypeTo, function(success)
                            if success then
                              cb(true)
                              if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= charId) then
                                REFRESH_ALL_CLIENTS(data.ownerTo, data.invTypeTo, _src)
                              elseif data.invTypeFrom == 10 or
                                  data.invTypeFrom == 1 and data.ownerFrom ~= charId then
                                REFRESH_ALL_CLIENTS(data.ownerFrom, data.invTypeFrom, _src)
                              end
                            end
                          end)
                        else
                          if slotTo.id == itemId then
                            Inventory:AddToSlot(data.ownerTo, data.slotTo, data.quantityTo, data.invTypeTo,
                              function(success)
                                if success then
                                  cb(true)
                                  if data.invTypeTo == 10 or
                                      (data.invTypeTo == 1 and data.ownerTo ~= charId) then
                                    REFRESH_ALL_CLIENTS(data.ownerTo, data.invTypeTo, _src)
                                  elseif data.invTypeFrom == 10 or
                                      data.invTypeFrom == 1 and data.ownerFrom ~= charId then
                                    REFRESH_ALL_CLIENTS(data.ownerFrom, data.invTypeFrom, _src)
                                  end
                                end
                              end)
                          else
                            Inventory:SwapSlots(data.ownerFrom, data.ownerTo, data.slotFrom, data.slotTo,
                              data.invTypeFrom, data.invTypeTo, function(meh)
                              if meh then
                                cb(true)
                                if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= charId) then
                                  REFRESH_ALL_CLIENTS(data.ownerTo, data.invTypeTo, _src)
                                elseif data.invTypeFrom == 10 or
                                    data.invTypeFrom == 1 and data.ownerFrom ~= charId then
                                  REFRESH_ALL_CLIENTS(data.ownerFrom, data.invTypeFrom, _src)
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
                        Inventory:AddSlot(data.ownerTo, itemId, data.quantityTo, slotFrom.metaData, data.slotTo,
                          data.invTypeTo, function(success)
                          if success then
                            cb(true)
                            if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= charId) then
                              REFRESH_ALL_CLIENTS(data.ownerTo, data.invTypeTo, _src)
                            elseif data.invTypeFrom == 10 or
                                data.invTypeFrom == 1 and data.ownerFrom ~= charId then
                              REFRESH_ALL_CLIENTS(data.ownerFrom, data.invTypeFrom, _src)
                            end
                          end
                        end)
                      end
                    end)
                  else
                    if slotTo.id == itemId then
                      local item = SHARED_ITEMS[itemId]
                      Inventory:RemoveSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(success)
                        if success then
                          if slotFrom.invType == 1 and slotFrom.details.type == 2 then
                            Inventory:RemoveWeapon(_src, slotFrom._id)
                          end
                          Inventory:AddToSlot(data.ownerTo, data.slotTo, data.quantityTo, data.invTypeTo,
                            function(success)
                              if success then
                                cb(true)
                                if data.invTypeTo == 10 or
                                    (data.invTypeTo == 1 and data.ownerTo ~= charId
                                    ) then
                                  REFRESH_ALL_CLIENTS(data.ownerTo, data.invTypeTo, _src)
                                elseif data.invTypeFrom == 10 or
                                    data.invTypeFrom == 1 and data.ownerFrom ~= charId then
                                  REFRESH_ALL_CLIENTS(data.ownerFrom, data.invTypeFrom, _src)
                                end
                              end
                            end)
                        end
                      end)
                    else
                      Inventory:SwapSlots(data.ownerFrom, data.ownerTo, data.slotFrom, data.slotTo, data.invTypeFrom,
                        data.invTypeTo, function(meh)
                        if meh then
                          if slotFrom.invType == 1 and slotFrom.details.type == 2 then
                            Inventory:RemoveWeapon(_src, slotFrom._id)
                          end
                          cb(true)
                          if data.invTypeTo == 10 or (data.invTypeTo == 1 and data.ownerTo ~= charId) then
                            REFRESH_ALL_CLIENTS(data.ownerTo, data.invTypeTo, _src)
                          elseif data.invTypeFrom == 10 or data.invTypeFrom == 1 and data.ownerFrom ~= charId then
                            REFRESH_ALL_CLIENTS(data.ownerFrom, data.invTypeFrom, _src)
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
      -- we need to ban this guy...
      TriggerClientEvent('Notification:SendAlert', _src, 'Please stop it.')
    end
  end)

  Callbacks:RegisterServerCallback('Inventory:Server:NextSlotInSecondary', function(source, data, cb)
    Inventory:GetOpenSlot(data.ownerTo, data.invTypeTo, function(i)
      if i ~= nil and i > 0 and i <= LOADED_ENTITIES[data.invTypeTo].slots then
        Inventory:GetSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(slotFrom)
          if slotFrom ~= nil then
            Inventory:UpdateSlot(slotFrom._id, data.ownerTo, i, data.invTypeTo, function(success)
              cb(success)
            end)
          end
        end)
      end
    end)
  end)
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
