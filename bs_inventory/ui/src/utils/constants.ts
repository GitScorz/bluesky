import { InventoryState, SecondInventoryState } from "../types/types";

// This is for browser testing.
export const InventoryData: InventoryState = {
  label: "Player",
  weight: 10,
  maxWeight: 250,
  items: [
    {
      label: "Bread",
      id: "bread",
      description: "A loaf of bread",
      slot: 1,
      weight: 1,
      quantity: 2,
      creationDate: 1,
      data: {},
    },
    {
      label: "Water",
      id: "water",
      description: "A bottle of water",
      weight: 1,
      quantity: 5,
      slot: 2,
      creationDate: 1,
      data: {},
    },
  ],
}

export const SecondInventoryData: SecondInventoryState = {
  id: "ground",
  label: "Ground",
  weight: 100,
  maxWeight: 1000,
  items: [
    {
      label: "Bread",
      id: "bread",
      description: "A loaf of motherfucking bread dfsd yufgdsy fgsdyu gsdyu fgsuid fghsdiu ghfsug ufdy ghdf ghuyghyu",
      slot: 3,
      weight: 5,
      quantity: 1,
      creationDate: 1,
      data: {},
    },
  ]
}