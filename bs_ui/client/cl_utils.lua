AddEventHandler('UI:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Logger = exports['bs_base']:FetchComponent('Logger')
  Callbacks = exports['bs_base']:FetchComponent('Callbacks')
  Phone = exports['bs_base']:FetchComponent('Phone')
  Notification = exports['bs_base']:FetchComponent('Notification')
  Voip = exports['bs_base']:FetchComponent('Voip')
  Radio = exports['bs_base']:FetchComponent('Radio')
  Peek = exports['bs_base']:FetchComponent('Peek')
end

AddEventHandler('Core:Shared:Ready', function()
  exports['bs_base']:RequestDependencies('UI', {
    'Logger',
    'Callbacks',
    'Phone',
    'Notification',
    'Voip',
    'Radio',
    'Peek',
  }, function(error)
    if #error > 0 then return; end
    RetrieveComponents()
  end)
end)
