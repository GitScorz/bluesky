import { Item } from "../types/types";

export function GetOpenSlot(inventory: Item[], slots: number) {
  for (let i = 1; i <= inventory.length; i++) {
    let item = inventory[i]
    if (i !== item.slot) {
      return i;
    }
  }

  return inventory.length + 1
}