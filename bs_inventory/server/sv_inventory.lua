LOADED_ENTITIES = {}
LOADED_INVENTORIES = {}
ITEM_CALLBACKS = {}

AddEventHandler('Inventory:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Database = exports['bs_base']:FetchComponent('Database')
  Callbacks = exports['bs_base']:FetchComponent('Callbacks')
  Logger = exports['bs_base']:FetchComponent('Logger')
  Default = exports['bs_base']:FetchComponent('Default')
  Inventory = exports['bs_base']:FetchComponent('Inventory')
  Items = exports['bs_base']:FetchComponent('Items')
  EntityTypes = exports['bs_base']:FetchComponent('EntityTypes')
  Chat = exports['bs_base']:FetchComponent('Chat')
  Wallet = exports['bs_base']:FetchComponent('Wallet')
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
  }, function(error)
    if #error > 0 then return; end
    RetrieveComponents()

    --# DEFAULT #--
    DEFAULT_ENTITY_DATA()

    --# CALLBACKS #--
    REGISTER_CALLBACKS()
    REGISTER_ITEM_CALLBACKS()

    --# COMMANDS #--
    Chat:RegisterAdminCommand('giveitem', function(src, args, raw)
      local itemId = args[1]
      local amount = args[2]

      if tostring(itemId) ~= nil and tonumber(amount) ~= nil then
        if Inventory:IsValidItem(itemId) then
          local player = exports['bs_base']:FetchComponent('Fetch'):Source(src)
          local char = player:GetData('Character')

          Inventory:AddItem(char:GetData('ID'), itemId, tonumber(amount), {}, 1, src)
        else
          TriggerClientEvent('Notification:SendError', src, 'Item does not exist.')
        end
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

    --# INITIALIZE #--

    LOADED_INVENTORIES = {}

    Database.Game:find({
      collection = 'dropzones',
      query = {}
    }, function(success, dropzones)
      if not success then return end

      local totalDeleted = 0

      if dropzones[1] then
        for i = 1, #dropzones do
          local done = false

          Database.Game:delete({
            collection = 'user_inventory',
            query = {
              invType = 10,
              owner = dropzones[i].randomIdent
            }
          }, function(delsuccess, deleted)
            if not delsuccess then return end

            Database.Game:deleteOne({
              collection = 'dropzones',
              query = {
                randomIdent = dropzones[i].randomIdent
              }
            }, function(successdr, dropdelete)
              if not successdr then return end

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
        collection = 'user_inventory',
        query = {
          invType = 16,
        }
      }, function(delsuccess, deleted)
        if not delsuccess then
          return;
        end
        if deleted > 0 then
          Logger:Trace('Inventory', deleted .. ' Items have been collected from trash containers.', { console = true })
        end
      end)
    end)

    Database.Game:find({
      collection = 'entitytypes',
      query = {}
    }, function(success, results)
      if not success then return end

      for k, v in ipairs(results) do
        LOADED_ENTITIES[tonumber(v.id)] = v
      end
    end)
  end)
end)

RegisterServerEvent('Inventory:Server:CloseSecondary')
AddEventHandler('Inventory:Server:CloseSecondary', function()
  local src = source
  if LOADED_INVENTORIES[src] then

    if LOADED_INVENTORIES[src].invType == 10 then
      Inventory:ManageDropzone(LOADED_INVENTORIES[src].owner, function()

      end)
    end

    LOADED_INVENTORIES[src] = nil
  end
end)

function REFRESH_ALL_CLIENTS(owner, invType, source)
  for k, v in pairs(LOADED_INVENTORIES) do
    if v.owner == owner and v.invType == invType and v.source ~= source then
      if invType ~= 1 then
        TriggerClientEvent('Inventory:Client:RefreshSecondary', tonumber(v.source))
      end
    end
  end
end

INVENTORY = {
  OpenSecondary = function(self, _src, invType, owner)
    if _src and invType and owner then
      LOADED_INVENTORIES[_src] = {
        owner = owner,
        invType = tonumber(invType),
        source = tonumber(_src)
      }

      if LOADED_INVENTORIES[_src] then
        local reqInt = LOADED_INVENTORIES[_src]

        Inventory:Get(owner, invType, function(inventory)
          LOADED_INVENTORIES[_src].entity = {
            slots = (tonumber(LOADED_ENTITIES[invType].slots) or 10),
            name = (LOADED_ENTITIES[invType].name or "Unknown")
          }

          local requestedInventory = {
            size = LOADED_ENTITIES[tonumber(invType)].slots or 10,
            name = LOADED_ENTITIES[tonumber(invType)].name or "Unknown",
            maxWeight = LOADED_ENTITIES[tonumber(invType)].maxWeight or 250,
            weight = CalculateInventoryWeight(inventory.inventory),
            inventory = inventory.inventory,
            invType = invType,
            owner = owner
          }

          TriggerClientEvent('Inventory:Client:LoadSecondary', _src, requestedInventory)
        end)
      end
    end
  end,

  --# ADDERS #--

  AddItem = function(self, owner, itemId, amount, metaData, invType, src)
    if not Inventory:IsValidItem(itemId) then
      Logger:Warn('Inventory', 'Tried to give an unregistered item: ' + itemId, { console = true })
      return
    end

    Inventory:Get(owner, 1, function(inventory)
      if CalculateInventoryWeight(inventory.inventory) > Config.MaxWeight then
        TriggerClientEvent('Notification:SendError', owner, 'You\'re full.')
        return
      end

      TriggerClientEvent('Inventory:AddItem', src, itemId, amount)
      local itemData = SHARED_ITEMS[itemId]

      if itemData.isStackable then
        Inventory:GetMatchingSlot(owner, itemId, invType, function(mSlot)
          if mSlot == nil then
            Inventory:GetOpenSlot(owner, invType, function(oSlot)
              Inventory:AddSlot(owner, itemId, amount, metaData, oSlot, invType)
            end)
          else
            if (mSlot.quantity + amount) <= LOADED_ENTITIES[mSlot.invType].slots then
              Inventory:AddToSlot(owner, mSlot.slot, amount, invType)
            else
              Inventory:GetOpenSlot(owner, invType, function(gammaSlot)
                if gammaSlot ~= nil and gammaSlot > 0 and gammaSlot <= LOADED_ENTITIES[invType].slots then
                  Inventory:AddSlot(owner, itemId, amount, metaData, gammaSlot, invType)
                else
                  TriggerClientEvent('Notification:SendError', src, 'You\'re full!')
                end
              end)
            end
          end
        end)
      else
        Inventory:GetFreeSlotNumbers(owner, invType, function(slots)
          if Utils:GetTableLength(slots) >= amount then
            local totalGiven = 0
            for k, v in pairs(slots) do
              Inventory:AddSlot(owner, itemId, 1, metaData, k, invType)
              totalGiven = totalGiven + 1

              if totalGiven == amount then
                break;
              end
            end
          end
        end)
      end
    end)
  end,

  AddSlot = function(self, owner, itemId, amount, metaData, slot, invType, cb)
    Database.Game:findOne({
      collection = 'user_inventory',
      query = {
        owner = owner,
        slot = slot,
        invType = invType
      }
    }, function(success, results)
      if not success then return end
      if #results > 0 then
        Logger:Error('Inventory', 'Slot ' .. slot .. ' Already Exists for ' .. owner, { console = false })
        return
      end

      local doc = {
        owner = owner,
        id = itemId,
        quantity = amount,
        metaData = metaData,
        slot = slot,
        invType = invType
      }

      Database.Game:insertOne({
        collection = 'user_inventory',
        document = doc
      }, function(success, results)
        if not success then return end

        if cb ~= nil then
          cb(results > 0)
        end
      end)
    end)
  end,

  AddToSlot = function(self, owner, slot, amount, invType, cb)
    Database.Game:updateOne({
      collection = 'user_inventory',
      query = {
        owner = owner,
        slot = slot,
        invType = invType
      },
      update = {
        ['$inc'] = {
          quantity = amount
        }
      }
    }, function(success, results)
      if not success then return end

      if results == 0 then
        Logger:Error('Inventory', 'Slot ' .. slot .. ' Does Not Exists for ' .. owner, { console = false })

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

  --# REMOVERS #--

  RemoveItem = function(self, src, owner, itemId, amount, slot, invType, cb)
    Inventory:GetSlot(owner, slot, invType, function(data)

      if data == nil then
        Logger:Error('Inventory', 'Failed to remove ' .. amount .. ' from Slot ' .. slot .. ' for ' .. owner,
          { console = false })
        return
      end

      TriggerClientEvent('Inventory:RemoveItem', src, itemId, amount)

      if data.quantity - amount <= 0 then
        Inventory:RemoveSlot(owner, data.slot, invType)
      else
        Inventory:RemoveFromSlot(owner, data.slot, invType, amount)
        continue = false
      end

      if cb then
        cb(true)
      end
    end)
  end,

  RemoveAmount = function(self, owner, slot, amount, invType, cb)
    Database.Game:findOne({
      collection = 'user_inventory',
      query = {
        owner = owner,
        slot = slot,
        invType = invType
      }
    }, function(success, results)
      if not success then return end

      if #results == 0 then
        Logger:Error('Inventory', 'Slot ' .. slot .. ' Does Not Exists for ' .. owner, { console = false })
        return
      end

      Database.Game:updateOne({
        collection = 'user_inventory',
        query = {
          owner = owner,
          slot = slot,
          invType = invType
        },
        update = {
          ['$inc'] = { quantity = (amount * -1) }
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

  RemoveSlot = function(self, owner, slot, invType, cb)
    Database.Game:findOne({
      collection = 'user_inventory',
      query = {
        owner = owner,
        slot = slot,
        invType = invType
      }
    }, function(success, results)
      if not success then return end

      if #results == 0 then
        Logger:Error('Inventory', 'Slot ' .. slot .. ' Does Not Exists for ' .. owner, { console = false })
        return
      end

      Database.Game:deleteOne({
        collection = 'user_inventory',
        query = {
          owner = owner,
          slot = slot,
          invType = invType
        }
      }, function(success, results)
        if not success then return end

        if cb ~= nil then
          cb(results > 0)
        end
      end)
    end)
  end,

  RemoveFromSlot = function(self, owner, slot, amount, invType, cb)
    Database.Game:updateOne({
      collection = 'user_inventory',
      query = {
        owner = owner,
        slot = slot,
        invType = invType
      },
      update = {
        ['$inc'] = {
          quantity = -amount
        }
      }
    }, function(success, results)
      if not success then return end

      if results == 0 then
        Logger:Error('Inventory', 'Slot ' .. slot .. ' Does Not Exists for ' .. owner, { console = false })

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

  --# GETTERS #--

  GetFreeSlotNumbers = function(self, owner, invType, cb)
    Database.Game:find({
      collection = 'user_inventory',
      query = {
        owner = owner
      }
    }, function(success, result)
      if not success then return end

      local occupiedTable = {}
      local unOccupiedSlots = {}

      for k, v in pairs(result) do
        occupiedTable[v.slot] = true
      end

      for i = 1, LOADED_ENTITIES[invType].slots do
        if not occupiedTable[i] then
          unOccupiedSlots[i] = true
        end
      end

      cb(unOccupiedSlots)
    end)
  end,

  GetMatchingSlot = function(self, owner, itemId, invType, cb)
    Database.Game:findOne({
      collection = 'user_inventory',
      query = {
        owner = owner,
        id = itemId,
        invType = invType
      }
    }, function(success, results)
      if not success then return end

      if #results == 0 then
        Logger:Error('Inventory', 'Could not find Matching Slot for ' .. itemId .. ' for ' .. owner, { console = false })
        cb(nil)
        return
      end

      cb(results[1])
    end)
  end,

  GetOpenSlot = function(self, owner, invType, cb)
    Database.Game:find({
      collection = 'user_inventory',
      query = {
        owner = owner,
        invType = invType
      },
      options = {
        sort = {
          slot = 1
        }
      },
    }, function(success, results)
      if not success then return end

      for i = 1, #results, 1 do
        local item = results[i]
        if i ~= item.slot then
          cb(i)
          return
        end
      end

      cb(#results + 1)
    end)
  end,

  GetSlot = function(self, owner, slot, invType, cb)
    Database.Game:findOne({
      collection = 'user_inventory',
      query = {
        owner = owner,
        slot = slot,
        invType = invType
      }
    }, function(success, results)
      if not success then return end

      if #results == 0 then
        Logger:Error('Inventory', 'Slot ' .. slot .. ' Does Not Exists for ' .. owner, { console = false })
        cb(nil)
        return
      end

      if Inventory:IsValidItem(results[1].id) then
        cb(results[1])
      end
    end)
  end,

  Get = function(self, Owner, Type, cb)
    if Type == 11 then
      local items = {}
      for k, v in pairs(Config.TwentyFourSeven) do
        items[tostring(k)] = {
          id = v,
          label = SHARED_ITEMS[v].label,
          price = SHARED_ITEMS[v].price,
          description = SHARED_ITEMS[v].description,
          weight = SHARED_ITEMS[v].weight,
          owner = tostring(Owner),
          quantity = 50,
          metaData = {},
          slot = k,
        }
      end

      cb({
        inventory = items,
        owner = Owner,
        invType = Type
      })

      -- Database.Game:findOne({
      --   collection = 'shops',
      --   id = Owner
      -- }, function(success, results)
      --   if not success then
      --     return;
      --   end
      --   local items = {}
      --   for k, v in pairs(Config.ShopItemSets[results[1].shop_itemset]) do
      --     items[tostring(k)] = { Slot = k, Label = itemsDatabase[v].label, Image = itemsDatabase[v].image, Count = 50,
      --       Name = v, invType = 11, MetaData = {}, Owner = tostring(Owner), Price = itemsDatabase[v].price }
      --   end
      --   cb({
      --     inventory = items,
      --     owner = Owner,
      --     invType = Type
      --   })

      -- end)
    else
      Database.Game:find({
        collection = 'user_inventory',
        query = {
          owner = Owner,
          invType = Type
        }
      }, function(success, results)
        if not success then return end

        local data = {}
        for k, v in ipairs(results) do
          v.label = SHARED_ITEMS[v.id].label
          v.description = SHARED_ITEMS[v.id].description
          v.weight = SHARED_ITEMS[v.id].weight
          data[tostring(v.slot)] = v
        end

        cb({
          inventory = data,
          owner = Owner,
          invType = Type
        })
      end)
    end
  end,

  --# UPDATE #--

  UpdateSlot = function(self, id, owner, slot, invType, cb)
    Database.Game:updateOne({
      collection = 'user_inventory',
      query = {
        _id = id
      },
      update = {
        ['$set'] = {
          owner = owner,
          slot = slot,
          invType = invType
        }
      }
    }, function(success, results)
      if not success then return end

      if cb ~= nil then
        cb(results > 0)
      end
    end)
  end,

  --# UTILS #--

  MoveSlot = function(self, ownerFrom, ownerTo, slotFrom, slotTo, invTypeFrom, invTypeTo, cb)
    Inventory:GetSlot(ownerFrom, slotFrom, invTypeFrom, function(slot)
      Inventory:UpdateSlot(slot._id, ownerTo, slotTo, invTypeTo, cb)
    end)
  end,

  SwapSlots = function(self, ownerFrom, ownerTo, SlotFrom, SlotTo, invTypeFrom, invTypeTo, cb)
    Inventory:GetSlot(ownerFrom, SlotFrom, invTypeFrom, function(slotFrom)
      Inventory:GetSlot(ownerTo, SlotTo, invTypeTo, function(slotTo)
        Inventory:UpdateSlot(slotFrom._id, ownerTo, SlotTo, invTypeTo, function(success)
          if success then
            Inventory:UpdateSlot(slotTo._id, ownerFrom, SlotFrom, invTypeFrom, function(success)
              cb(success)
            end)
          end
        end)
      end)
    end)
  end,

  IsValidItem = function(self, itemId)
    return SHARED_ITEMS[itemId] ~= nil
  end,

  --# DROP ZONES #--

  ManageDropzone = function(self, dropzoneIdent, cb)
    Database.Game:find({
      collection = 'user_inventory',
      query = {
        owner = dropzoneIdent,
        invType = 10
      }
    }, function(success, results)
      if not success then return end

      if #results > 0 then
        Database.Game:findOne({
          collection = 'dropzones',
          query = {
            randomIdent = dropzoneIdent
          }
        }, function(success2, dzresults)
          if not success2 then return end

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
          if not success then return end

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
      if not success then return end

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
      query = {}
    }, function(success, result)
      if not success then
        cb(nil)
        return;
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
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['bs_base']:RegisterComponent('Inventory', INVENTORY)
end)

RegisterServerEvent('Inventory:Server:RequestSecondaryInventory')
AddEventHandler('Inventory:Server:RequestSecondaryInventory', function(inv)
  local src = source
  Inventory:OpenSecondary(src, inv.invType, inv.owner)
end)

RegisterServerEvent('Inventory:Server:CreateNewDropzone')
AddEventHandler('Inventory:Server:CreateNewDropzone', function()
  local src = source
  local player = GetPlayerPed(src)
  local pCoords = GetEntityCoords(player)

  local dropzoneCoords = {
    ['x'] = pCoords.x,
    ['y'] = pCoords.y,
    ['z'] = pCoords.z
  }

  Inventory:CreateDropzone(dropzoneCoords, function(id)
    if id ~= nil and id > 0 then
      Inventory:OpenSecondary(src, 10, id)
    end
  end)
end)

RegisterServerEvent('Inventory:Server:OpenShop')
AddEventHandler('Inventory:Server:OpenShop', function(shopId)
  local src = source
  if shopId and shopId > 0 then
    Inventory:OpenSecondary(src, 11, shopId)
  end
end)

function CalculateInventoryWeight(items)
  local weight = 0

  for _, item in pairs(items) do
    if item.quantity > 1 then
      weight = weight + item.quantity * item.weight
    else
      weight = weight + item.weight
    end
  end

  return weight
end
