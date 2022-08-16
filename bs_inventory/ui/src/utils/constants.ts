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
