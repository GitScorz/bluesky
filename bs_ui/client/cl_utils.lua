AddEventHandler('UI:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Logger = exports['bs_base']:FetchComponent('Logger')
  Callbacks = exports['bs_base']:FetchComponent('Callbacks')
end

AddEventHandler('Core:Shared:Ready', function()
  exports['bs_base']:RequestDependencies('UI', {
    'Logger',
    'Callbacks',
  }, function(error)  
    if #error > 0 then return; end
    RetrieveComponents()
  end)
end)