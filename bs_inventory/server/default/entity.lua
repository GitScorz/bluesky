local _ran = false

function DEFAULT_ENTITY_DATA()
  if _ran then return end

  _ran = true
  Default:Add('entitytypes', 1592332156, {
    {
      id = 1,
      slots = 50,
      name = 'Player',
      maxWeight = Config.MaxWeight,
    },
    {
      id = 2,
      slots = 30,
      name = 'Stash',
      maxWeight = 300,
    },
    {
      id = 3,
      slots = 6,
      name = 'Trunk',
      maxWeight = 200, -- Make a system that allows get trunk weight by vehicle
    },
    {
      id = 4,
      slots = 10,
      name = 'Player Trunk',
      maxWeight = 200, -- Make a system that allows get trunk weight by vehicle
    },
    {
      id = 5,
      slots = 5,
      name = 'Glovebox',
      maxWeight = 30,
    },
    {
      id = 6,
      slots = 8,
      name = 'Player Glovebox',
      maxWeight = 30,
    },
    {
      id = 7,
      slots = 8,
      name = 'Armory',
      maxWeight = 700,
    },
    {
      id = 8,
      slots = 30,
      name = 'Police Evidence',
      maxWeight = 500,
    },
    {
      id = 9,
      slots = 500,
      name = 'Police Trash',
      maxWeight = 700,
    },
    {
      id = 10,
      slots = 35,
      name = 'Ground',
      maxWeight = 1000,
    },
    {
      id = 11,
      slots = 30,
      name = 'Shop',
      maxWeight = 400,
    },
    {
      id = 12,
      slots = 30,
      name = 'Crafting Station',
      maxWeight = 300,
    },
    {
      id = 13,
      slots = 30,
      name = 'Property Storage Tier 1',
      maxWeight = 500,
    },
    {
      id = 14,
      slots = 50,
      name = 'Property Storage Tier 2',
      maxWeight = 600,
    },
    {
      id = 15,
      slots = 80,
      name = 'Property Storage Tier 3',
      maxWeight = 700,
    },
    {
      id = 16,
      slots = 50,
      name = 'Trash Container',
      maxWeight = 700,
    },
    {
      id = 17,
      slots = 400,
      name = 'Shipping Container',
      maxWeight = 700,
    },
    {
      id = 18,
      slots = 800,
      name = 'Warehouse',
      maxWeight = 1000,
    },
  })
end
