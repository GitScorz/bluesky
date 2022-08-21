CreateThread(function()
  Peek:AddBoxZone("Test", vector3(-1289.43, 307.84, 65.89), 0.8, 0.8, {
    name = "test",
    heading = 280,
    --debugPoly=true,
    minZ = 62.89,
    maxZ = 66.89
  }, {
    options = {
      {
        event = "peek:pee",
        icon = "fa-water",
        label = "Pee",
      },
    },
    job = { "police" },
    distance = 3
  })
end)
