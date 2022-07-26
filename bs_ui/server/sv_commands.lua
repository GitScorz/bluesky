AddEventHandler('UI:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Logger = exports['bs_base']:FetchComponent('Logger')
  Callbacks = exports['bs_base']:FetchComponent('Callbacks')
  Chat = exports['bs_base']:FetchComponent('Chat')
end

AddEventHandler('Core:Shared:Ready', function()
  exports['bs_base']:RequestDependencies('UI', {
    'Logger',
    'Callbacks',
    'Chat',
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
    help = 'Turns HUD on/off.',
  }, 0)

  Chat:RegisterCommand('bank', function(source, args, rawCommand)
    TriggerClientEvent('UI:Client:ShowBank', source)
  end, {
    help = 'Show your current bank balance.',
  }, 0)

  Chat:RegisterCommand('cash', function(source, args, rawCommand)
    TriggerClientEvent('UI:Client:ShowCash', source)
  end, {
    help = 'Show your current cash.',
  }, 0)
end