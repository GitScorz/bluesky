AddEventHandler('Phone:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['bs_base']:FetchComponent('Callbacks')
  Logger = exports['bs_base']:FetchComponent('Logger')
  UI = exports['bs_base']:FetchComponent('UI')
  Keybinds = exports['bs_base']:FetchComponent('Keybinds')
  Peek = exports['bs_base']:FetchComponent('Peek')
  RegisterKeybinds()
  RegisterPeekZones()
end

AddEventHandler('Core:Shared:Ready', function()
  exports['bs_base']:RequestDependencies('Phone', {
    'Callbacks',
    'Logger',
    'UI',
    'Keybinds',
    'Peek'
  }, function(error)
    if #error > 0 then return end
    RetrieveComponents()
  end)
end)
