RegisterCommand("+phoneopen", function(src, cmd, raw)
  Phone:Open()
end, false)

function RegisterKeybinds()
  Keybinds:Register("Phone", "Open phone.", "+phoneopen", "-phoneopen", "keyboard", 'P')
end

function RegisterPeekZones()
  local payphones = {
    1158960338,
    1511539537,
    1281992692,
    -429560270,
    -1559354806,
    -78626473,
    295857659,
    -2103798695,
    -870868698,
    -1126237515,
    506770882
  }

  Peek:AddTargetModel(payphones, {
    options = {
      {
        label = "Call Someone",
        icon = "phone-volume",
        event = "Phone:Client:Call",
      },
    },
    job = { "all" },
    distance = 1.0
  })
end
