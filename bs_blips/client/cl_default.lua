DefaultBlips = {
  {
    id = "richmanhotel",
    name = "The Richman Hotel",
    coords = vector3(-1276.91, 310.76, 65.51),
    sprite = 475,
    colour = 16,
    scale = 0.8
  },
}

function RegisterDefaultBlips()
  for k, v in ipairs(DefaultBlips) do
    Blips:Add(v.id, v.name, v.coords, v.sprite, v.colour, v.scale)
  end
end
