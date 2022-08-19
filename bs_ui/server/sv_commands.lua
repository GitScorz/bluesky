AddEventHandler('UI:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Fetch = exports['bs_base']:FetchComponent('Fetch')
  Logger = exports['bs_base']:FetchComponent('Logger')
  Callbacks = exports['bs_base']:FetchComponent('Callbacks')
  Chat = exports['bs_base']:FetchComponent('Chat')
  Wallet = exports['bs_base']:FetchComponent('Wallet')
end

AddEventHandler('Core:Shared:Ready', function()
  exports['bs_base']:RequestDependencies('UI', {
    'Fetch',
    'Logger',
    'Callbacks',
    'Chat',
    'Wallet',
  }, function(error)
    if #error > 0 then return end -- Do something to handle if not all dependencies loaded
    RetrieveComponents()
    RegisterChatCommands()
  end)
end)

function RegisterChatCommands()
  Chat:RegisterCommand('hud', function(source, args, rawCommand)
    TriggerClientEvent('UI:Client:ChangeHudState', source)
  end, {
    help = 'Turns on/off the HUD.',
  }, 0)

  Chat:RegisterCommand('cash', function(source, args, rawCommand)
    local char = Fetch:Source(source):GetData('Character')
    local src = char:GetData('Source')

    Wallet:Get(char, function(wallet)
      if wallet then
        TriggerClientEvent('UI:Client:ShowCash', src, wallet.Cash)
      end
    end)
  end, {
    help = 'Show your current cash.',
  }, 0)
end
