AddEventHandler('Wallet:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Database = exports['bs_base']:FetchComponent('Database')
  Logger = exports['bs_base']:FetchComponent('Logger')
  Callbacks = exports['bs_base']:FetchComponent('Callbacks')
  Wallet = exports['bs_base']:FetchComponent('Wallet')
  CurrencyConfig = exports['bs_base']:FetchComponent('Config').Currency
  UI = exports['bs_base']:FetchComponent('UI')
end

AddEventHandler('Core:Shared:Ready', function()
  exports['bs_base']:RequestDependencies('Wallet', {
    'Database',
    'Logger',
    'Callbacks',
    'Wallet',
    'Config',
    'UI'
  }, function(error)
    if #error > 0 then
      return
    end -- Do something to handle if not all dependencies loaded
    RetrieveComponents()
    RegisterCallbacks()
  end)
end)

function RegisterCallbacks()
  Callbacks:RegisterServerCallback('Wallet:GetCash', function(source, data, cb)
    local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
    local char = player:GetData('Character')
    Wallet:Get(char, function(wallet)
      cb(wallet.Cash)
    end)
  end)
end

WALLET = {
  Create = function(self, cId)
    Database.Game:insertOne({
      collection = 'wallets',
      document = {
        Char = cId,
        Cash = Config.InitialCash
      }
    }, function(success, results) end)
  end,

  Get = function(self, char, cb)
    Database.Game:findOne({
      collection = 'wallets',
      query = {
        Char = char:GetData('ID')
      }
    }, function(success, results)
      if not success then return end
      if #results > 0 then
        local _data = results[1]
        _data.Modify = function(self, count)
          Database.Game:updateOne({
            collection = 'wallets',
            query = {
              Char = results[1].Char
            },
            update = {
              ["$inc"] = {
                Cash = count
              }
            }
          })
        end
        cb(_data)
      else
        Logger:Error('Wallet', "Looking for non-existent Wallet")
        cb(nil)
      end
    end)
  end,

  Give = function(self, char, cash)
    Wallet:Get(char, function(wallet)
      if wallet then
        UI.Balance:UpdateCash(char:GetData('Source'), wallet.Cash, cash)
        wallet:Modify(cash)
      end
    end)
  end,

  Remove = function(self, char, cash)
    Wallet:Get(char, function(wallet)
      if wallet then
        UI.Balance:UpdateCash(char:GetData('Source'), wallet.Cash, -cash)
        wallet:Modify(-cash)
      end
    end)
  end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['bs_base']:RegisterComponent('Wallet', WALLET)
end)

AddEventHandler('Characters:Server:CharacterCreated', function(cId)
  Database.Game:findOne({
    collection = 'wallets',
    query = {
      Char = cId
    }
  }, function(success, results)
    if not success then return end
    if #results == 0 then
      Wallet:Create(cId)
    end
  end)
end)

RegisterServerEvent('Wallet:Server:GiveCash')
AddEventHandler('Wallet:Server:GiveCash', function(cash)
  local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
  local char = player:GetData('Character')
  Wallet:Give(char, cash)
end)

RegisterServerEvent('Wallet:Server:RemoveCash')
AddEventHandler('Wallet:Server:RemoveCash', function(cash)
  local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
  local char = player:GetData('Character')
  Wallet:Remove(char, cash)
end)
