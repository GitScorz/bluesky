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
      slot: 1,
      creationDate: 1,
      data: {},
    },
    {
      label: "Water",
      id: "water",
      slot: 2,
      creationDate: 1,
      data: {},
    },
  ],
}

export const SecondInventoryData: SecondInventoryState = {
  id: "ground",
  label: "Ground",
  weight: 5,
  maxWeight: 250,
  items: [
    {
      label: "Bread",
      id: "bread",
      slot: 3,
      creationDate: 1,
      data: {},
    },
  ]
}