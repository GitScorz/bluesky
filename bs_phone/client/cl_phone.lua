local _loggedIn = false

AddEventHandler('Phone:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['bs_base']:FetchComponent('Callbacks')
  Logger = exports['bs_base']:FetchComponent('Logger')
  Phone = exports['bs_base']:FetchComponent('Phone')
  UI = exports['bs_base']:FetchComponent('UI')
end

AddEventHandler('Core:Shared:Ready', function()
  exports['bs_base']:RequestDependencies('Phone', {
    'Callbacks',
    'Logger',
    'Phone',
    'UI',
  }, function(error)
    if #error > 0 then return end -- Do something to handle if not all dependencies loaded
    RetrieveComponents()
  end)
end)