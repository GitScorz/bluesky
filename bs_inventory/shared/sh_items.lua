-- If this reach more than 1000 lines it doesn't matter.

--- @class ITEM
--- @param label string
--- @param description string
--- @param weight number
--- @param price number
--- @param isStackable boolean

--- @type ITEM[]
SHARED_ITEMS = {}

SHARED_ITEMS["water"] = {
  label = "Water",
  description = "Sates Thirst",
  weight = 1,
  price = 10,
  isStackable = true,
}

SHARED_ITEMS["bread"] = {
  label = "Bread",
  description = "Sates Hunger",
  weight = 1,
  price = 10,
  isStackable = true,
}

SHARED_ITEMS["mobilephone"] = {
  label = "Mobile Phone",
  weight = 1,
  price = 400,
  isStackable = true,
}

SHARED_ITEMS["armor"] = {
  label = "Chest Armor",
  description = "Protects you from physical injury or damage.",
  weight = 40,
  price = 4000,
  isStackable = true,
}
