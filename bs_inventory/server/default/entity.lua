local _ran = false

function DEFAULT_ENTITY_DATA()
  if _ran then return end

  _ran = true
  Default:Add('entitytypes', 1592332156, {
    {
      id = 1,
      slots = 50,
      name = 'Player'
    },
    {
      id = 2,
      slots = 30,
      name = 'Stash'
    },
    {
      id = 3,
      slots = 6,
      name = 'Trunk'
    },
    {
      id = 4,
      slots = 10,
      name = 'Player Trunk'
    },
    {
      id = 5,
      slots = 5,
      name = 'Glovebox'
    },
    {
      id = 6,
      slots = 8,
      name = 'Player Glovebox'
    },
    {
      id = 7,
      slots = 8,
      name = 'Armory'
    },
    {
      id = 8,
      slots = 30,
      name = 'Police Evidence'
    },
    {
      id = 9,
      slots = 500,
      name = 'Police Trash'
    },
    {
      id = 10,
      slots = 35,
      name = 'Ground'
    },
    {
      id = 11,
      slots = 30,
      name = 'Shop'
    },
    {
      id = 12,
      slots = 30,
      name = 'Crafting Station'
    },
    {
      id = 13,
      slots = 30,
      name = 'Property Storage Tier 1'
    },
    {
      id = 14,
      slots = 50,
      name = 'Property Storage Tier 2'
    },
    {
      id = 15,
      slots = 80,
      name = 'Property Storage Tier 3'
    },
    {
      id = 16,
      slots = 50,
      name = 'Trash Container'
    },
    {
      id = 17,
      slots = 400,
      name = 'Shipping Container'
    },
    {
      id = 18,
      slots = 800,
      name = 'Warehouse'
    },
  })
end
