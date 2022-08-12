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

    --# DROP ZONES #--
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
            collection = 'inventory',
            query = {
              invType = 10,
              Owner = dropzones[i].randomIdent
            }
          }, function(delsuccess, deleted)
            if not delsuccess then
              return;
            end

            Database.Game:deleteOne({
              collection = 'dropzones',
              query = {
                randomIdent = dropzones[i].randomIdent
              }
            }, function(successdr, dropdelete)
              if not successdr then
                return;
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
          return;
        end
        if deleted > 0 then
          Logger:Trace('Inventory', deleted .. ' Items have been collected from trash containers.', { console = true })
        end
      end)

    end)


    --# INVENTORY #--
    Database.Game:find({
      collection = 'items',
      query = {

      }
    }, function(success, results)
      if not success then
        return;
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
        return;
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
              Execute:Client(source, 'Notification', 'Error',
                'You can only give items with this command, try /giveweapon')
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
              Execute:Client(source, 'Notification', 'Error',
                'You can only give weapons with this command, try /giveitem')
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
