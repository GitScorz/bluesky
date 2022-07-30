AddEventHandler('Phone:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['bs_base']:FetchComponent('Callbacks')
  Logger = exports['bs_base']:FetchComponent('Logger')
  UI = exports['bs_base']:FetchComponent('UI')
  Keybinds = exports['bs_base']:FetchComponent('Keybinds')
  RegisterKeybinds()
end

AddEventHandler('Core:Shared:Ready', function()
  exports['bs_base']:RequestDependencies('Phone', {
    'Callbacks',
    'Logger',
    'UI',
    'Keybinds',
  }, function(error)
    if #error > 0 then return end -- Do something to handle if not all dependencies loaded
    RetrieveComponents()
  end)
end)