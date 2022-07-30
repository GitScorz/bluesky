Logger = nil

AddEventHandler('Keybinds:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Logger = exports['bs_base']:FetchComponent('Logger')
  Keybinds = exports['bs_base']:FetchComponent('Keybinds')
end

AddEventHandler('Core:Shared:Ready', function()
  exports['bs_base']:RequestDependencies('Keybinds', {
    'Logger',
    'Keybinds'
  }, function(error)
    if #error > 0 then return end -- Do something to handle if not all dependencies loaded
    RetrieveComponents()
  end)
end)

KEYBINDS = {
  --- @param category string
  --- @param description string
  --- @param onKeyUpCommand string
  --- @param onKeyDownCommand string
  --- @param defaultKey any
  --- @param controller string
  Register = function(self, category, description, onKeyUpCommand, onKeyDownCommand, defaultKey, controller)
    if not controller then controller = "keyboard" end
    if not category then
      -- Logger:Warn("Keybinds", "No category provided for keymap, cancelling.")
      return
    end

    if not description then
      -- Logger:Warn("Keybinds", "No description provided for keymap, cancelling.")
      return
    end

    local desc = ("(%s) %s"):format(category, description)
    cmdStringDown = "+cmd_wrapper__" .. onKeyDownCommand
    cmdStringUp = "-cmd_wrapper__" .. onKeyDownCommand

    RegisterCommand(cmdStringDown, function()
      ExecuteCommand(onKeyDownCommand)
    end, false)

    RegisterCommand(cmdStringUp, function()
      ExecuteCommand(onKeyUpCommand)
    end, false)

    RegisterKeyMapping(cmdStringDown, desc, defaultKey, controller)
  end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['bs_base']:RegisterComponent('Keybinds', KEYBINDS)
end)

CreateThread(function()
	while true do
		DisableControlAction(1, 199, true)
		Wait(5)
	end
end)