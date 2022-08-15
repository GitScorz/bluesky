import { InventoryState, Item } from "../types/types";

// This is for browser testing.
export const InventoryData: InventoryState = {
  owner: "player",
  name: "Player",
  size: 50,
  weight: 10,
  maxWeight: 250,
  invType: 1,
  inventory: [
    {
      label: "Bread",
      id: "bread",
      description: "A loaf of bread",
      slot: 1,
      weight: 1,
      quantity: 2,
      owner: "player",
      metaData: {},
      invType: 1,
      // creationDate: 1,
    },
    {
      label: "Water",
      id: "water",
      description: "A bottle of water",
      weight: 1,
      quantity: 5,
      slot: 2,
      owner: "player",
      metaData: {},
      invType: 1,
      // creationDate: 1,
    },
  ],
}

export const SecondInventoryData: InventoryState = {
  owner: "ground",
  name: "Ground",
  size: 35,
  invType: 10,
  weight: 100,
  maxWeight: 1000,
  inventory: [
    {
      label: "Bread",
      id: "bread",
      owner: "ground",
      description: "A loaf of motherfucking bread dfsd yufgdsy fgsdyu gsdyu fgsuid fghsdiu ghfsug ufdy ghdf ghuyghyu",
      slot: 3,
      weight: 5,
      quantity: 1,
      invType: 10,
      // creationDate: 1,
      metaData: {},
    },
  ]
}

export const DefaultHoveredItem: Item = {
  label: "",
  id: "",
  owner: "",
  description: "",
  slot: 0,
  weight: 0,
  quantity: 0,
  invType: 0,
  // creationDate: 1,
  metaData: {},
}