RegisterCommand("+phoneopen", function(src, cmd, raw)
  Phone:Open()
end, false)

function RegisterKeybinds()
  Keybinds:Register("Phone", "Open phone.", "+phoneopen", "-phoneopen", "keyboard", 'P')
end
