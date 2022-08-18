local defaultSettings = {
  wallpaper = 'https://imgur.com/Lm8aAxI.png',
  brand = 'android',
  notifications = true,
}

AddEventHandler('Phone:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Fetch = exports['bs_base']:FetchComponent('Fetch')
  Database = exports['bs_base']:FetchComponent('Database')
  Callbacks = exports['bs_base']:FetchComponent('Callbacks')
  Logger = exports['bs_base']:FetchComponent('Logger')
  Utils = exports['bs_base']:FetchComponent('Utils')
  Chat = exports['bs_base']:FetchComponent('Chat')
  Phone = exports['bs_base']:FetchComponent('Phone')
  Middleware = exports['bs_base']:FetchComponent('Middleware')
  Wallet = exports['bs_base']:FetchComponent('Wallet')
end

AddEventHandler('Core:Shared:Ready', function()
  exports['bs_base']:RequestDependencies('Phone', {
    'Fetch',
    'Database',
    'Callbacks',
    'Logger',
    'Utils',
    'Chat',
    'Phone',
    'Middleware',
    'Wallet',
  }, function(error)
    if #error > 0 then return end
    RetrieveComponents()
    TriggerEvent('Phone:Server:RegisterCallbacks')
  end)
end)

RegisterServerEvent('Characters:Server:Spawn')
AddEventHandler('Characters:Server:Spawn', function()
  local char = Fetch:Source(source):GetData('Character')
  local phoneSettings = char:GetData('PhoneSettings')
  local cash = 0

  if not phoneSettings then char:SetData('PhoneSettings', defaultSettings) end

  Wallet:Get(char, function(wallet)
    if wallet then
      cash = wallet.cash
    end
  end)

  local src = char:GetData('Source')
  TriggerClientEvent('Phone:Client:Settings', src, char:GetData('PhoneSettings'))
  TriggerClientEvent('Phone:Client:SetData', src, {
    sid = src,
    cid = char:GetData('ID'),
    phoneNumber = char:GetData('Phone'),
    wallpaper = phoneSettings.wallpaper,
    brand = phoneSettings.brand,
    notifications = phoneSettings.notifications,
    hasDriverLicense = true,
    cash = cash,
    bank = 0,
    name = {
      first = char:GetData('First'),
      last = char:GetData('Last')
    },
    aliases = {
      email = ('%s_%s@blue.sky'):format(char:GetData('First'):lower(), char:GetData('Last'):lower()),
      twitter = char:GetData('Twitter')
    }
  })
end)


AddEventHandler('Phone:Server:RegisterCallbacks', function()
  Callbacks:RegisterServerCallback('Phone:Settings:Update', function(source, data, cb)
    local src = source
    local char = Fetch:Source(src):GetData('Character')
    local phoneSettings = char:GetData('PhoneSettings')

    phoneSettings[data.type] = data.value
    char:SetData('PhoneSettings', phoneSettings)
  end)
end)
