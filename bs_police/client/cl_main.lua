POLICE = {

}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['bs_base']:RegisterComponent('Police', POLICE)
end)

function RegisterPeekZones()

  Peek:AddBoxZone("SignInOff", vector3(441.01, -980.12, 30.69), 0.8, 0.8, {
    name = "SignInOff",
    heading = 70,
    --debugPoly=true,
    minZ = 30.89,
    maxZ = 31.09
  }, {
    options = {
      {
        icon = "circle",
        label = "Sign In",
        event = "Police:Sign",
      },
    },
    job = { "all" },
    distance = 2
  })
end
