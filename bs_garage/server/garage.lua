Database = nil
Callbacks = nil
Logger = nil
Garage = nil
Chat = nil
Wallet = nil

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['bs_base']:RegisterComponent('Garage', GARAGE)
end)

AddEventHandler('Garage:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Database = exports['bs_base']:FetchComponent('Database')
  Callbacks = exports['bs_base']:FetchComponent('Callbacks')
  Logger = exports['bs_base']:FetchComponent('Logger')
  Garage = exports['bs_base']:FetchComponent('Garage')
  Chat = exports['bs_base']:FetchComponent('Chat')
  Wallet = exports['bs_base']:FetchComponent('Wallet')
  RegisterChatCommands()
end

AddEventHandler('Core:Shared:Ready', function()
  exports['bs_base']:RequestDependencies('Garage', {
    'Database',
    'Callbacks',
    'Logger',
    'Garage',
    'Chat',
    'Wallet',
  }, function(error)
    if #error > 0 then return end -- Do something to handle if not all dependencies loaded
    RetrieveComponents()
    RegisterCallbacks()
  end)
end)

function RegisterChatCommands()
  Chat:RegisterCommand('savecar', function(source, args, rawCommand)
    TriggerClientEvent('Garage:SaveCar', source)
  end, {
    help = 'Save the current vehicle'
  })
end

function RegisterCallbacks()
  Callbacks:RegisterServerCallback('Garage:CreateVehicle', function(source, data, cb)
    local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
    local char = player:GetData('Character')
    Garage.Vehicle:Create(data.plate, char:GetData('ID'), data.props, cb)
  end)

  Callbacks:RegisterServerCallback('Garage:StoreVehicle', function(source, data, cb)
    Garage.Vehicle:Store(data.plate, data.location, data.damage, cb)
  end)

  Callbacks:RegisterServerCallback('Garage:ReleaseVehicle', function(source, data, cb)
    Garage.Vehicle:Release(data.plate, cb)
  end)

  Callbacks:RegisterServerCallback('Garage:GetVehicle', function(source, data, cb)
    Garage.Vehicle:Get(data.plate, cb)
  end)

  Callbacks:RegisterServerCallback('Garage:DeleteVehicle', function(source, data, cb)
    Garage.Vehicle:Delete(data.plate, cb)
  end)

  Callbacks:RegisterServerCallback('Garage:GetVehicleForLocation', function(source, data, cb)
    local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
    local char = player:GetData('Character')
    Garage.Garage:GetVehicleForLocation(data.location, char:GetData('ID'), cb)
  end)
  Callbacks:RegisterServerCallback('Garage:GetAllVehicles', function(source, data, cb)
    local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
    local char = player:GetData('Character')
    Garage.Garage:GetAllVehicles(char:GetData('ID'), cb)
  end)

  Callbacks:RegisterServerCallback('Garage:Recall', function(source, data, cb)
    local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
    local char = player:GetData('Character')
    Wallet:Get(char, function(wallet)
      if wallet ~= nil then
        if wallet.Cash >= Config.RecallPrice then
          Garage.Vehicle:Recall(data.plate, data.location, function(success)
            if success then
              wallet:Modify(-Config.RecallPrice)
            end
            cb(success)
          end)
        end
      end
      cb(false)
    end)

  end)
end

GARAGE = {
  Garage = {
    GetVehicleForLocation = function(self, location, owner, cb)
      Database.Game:find({
        collection = 'vehicles',
        query = {
          Location = location,
          Owner = owner,
          Enabled = true
        }
      }, function(success, results)
        if not success then
          return
        end
        if cb ~= nil then
          cb(results)
        end
      end)
    end,
    GetAllVehicles = function(self, owner, cb)
      Database.Game:find({
        collection = 'vehicles',
        query = {
          Owner = owner,
          Enabled = true
        }
      }, function(success, results)
        if not success then
          print('Failed')
          return
        end
        if cb ~= nil then
          cb(results)
        end
      end)
    end
  },
  Vehicle = {
    Store = function(self, plate, location, damage, cb)
      Database.Game:updateOne({
        collection = 'vehicles',
        query = {
          Plate = plate
        },
        update = {
          ['$set'] = {
            Location = location,
            State = 0,
            Damage = damage
          }
        }
      }, function(success, results)
        if not success then
          return
        end
        cb(results > 0)
      end)
    end,
    Release = function(self, plate, cb)
      Database.Game:updateOne({
        collection = 'vehicles',
        query = {
          Plate = plate
        },
        update = {
          ['$set'] = {
            Location = "Out",
            State = 1
          }
        }
      }, function(success, results)
        if not success then
          return
        end
        cb(results > 0)
      end)
    end,
    Recall = function(self, plate, location, cb)
      Database.Game:updateOne({
        collection = 'vehicles',
        query = {
          Plate = plate
        },
        update = {
          ['$set'] = {
            Location = location,
            State = 0
          }
        }
      }, function(success, results)
        if not success then
          return
        end
        cb(results > 0)
      end)
    end,
    Get = function(self, plate, cb)
      Database.Game:findOne({
        collection = 'vehicles',
        query = {
          Plate = plate
        }
      }, function(success, results)
        if not success then
          return
        end
        if #results == 0 then
          Logger:Error('Garage', 'Attempted to find non-existed vehicle with plate ' .. plate)
          if cb ~= nil then
            cb(nil)
          end
          return
        end
        if cb ~= nil then
          cb(results[1])
        end
      end)
    end,
    Create = function(self, plate, owner, props, cb)
      local doc = {
        Plate = plate,
        Owner = owner,
        State = 1,
        Location = "Out",
        Enabled = true,
        Properties = props,
        Damage = {}
      }
      Database.Game:insertOne({
        collection = 'vehicles',
        document = doc
      }, function(success, results)
        if not success then
          return
        end
        if cb ~= nil then
          cb(results > 0)
        end
      end)
    end,
    Delete = function(self, plate, cb)
      Database.Game:findOne({
        collection = 'vehicles',
        query = {
          Plate = plate,
        }
      }, function(success, results)
        if not success then
          return
        end
        if #results == 0 then
          Logger:Error('Garage', 'Plate ' .. plate .. ' Does Not Exists')
          return
        end
        Database.Game:updateOne({
          collection = 'vehicles',
          query = {
            Plate = plate,
          },
          update = {
            ['$set'] = {
              Enabled = false
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
      end)
    end
  }
}
