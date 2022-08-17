import { InventoryState } from "../types/types";

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
      label: "Heart Stopper",
      id: "heartstopper",
      description: "A heart stopper.",
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
  name: "Shop",
  size: 35,
  invType: 11,
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
      invType: 11,
      // creationDate: 1,
      metaData: {},
    },
  ]
}
