AddEventHandler('Status:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Fetch = exports['bs_base']:FetchComponent('Fetch')
  Chat = exports['bs_base']:FetchComponent('Chat')
  Inventory = exports['bs_base']:FetchComponent('Inventory')
  RegisterChatCommands()
  registerUsables()
end

AddEventHandler('Core:Shared:Ready', function()
  exports['bs_base']:RequestDependencies('Status', {
    'Fetch',
    'Chat',
    'Inventory',
  }, function(error)
    if #error > 0 then return end -- Do something to handle if not all dependencies loaded
    RetrieveComponents()
    registerUsables()
  end)
end)

function RegisterChatCommands()
  Chat:RegisterCommand('freq', function(source, args, rawCommand)
    local frequnecy = args[1]
    TriggerClientEvent('Radio:Client:ChangeFrequency', source, frequnecy)
  end, {
    help = 'Change your radio frequency',
    params = {
      {
        name = 'frequency',
        help = 'Frequency you want to set',
      },
    },
  }, 1)
end

function registerUsables()
  Inventory.Items:RegisterUse('radio', 'Radio', function(source, item)
    local player = Fetch:Source(source)
    local char = player:GetData('Character')
    TriggerClientEvent('Radio:Client:OpenRadio', source)
  end)
end
