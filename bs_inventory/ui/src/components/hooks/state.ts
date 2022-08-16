import { atom } from 'recoil';
import { InventoryState, Item, SlotHovered } from '../../types/types';
import { InventoryData, SecondInventoryData } from '../../utils/constants';

export const inventoryState = {
  visibility: atom<boolean>({
    key: 'inventoryState.visibility',	
    default: false,
  }),

  playerInventory: atom<InventoryState>({
    key: 'inventoryState.playerInventory',
    default: InventoryData,
  }),

  secondInventory: atom<InventoryState>({
    key: 'inventoryState.secondInventory',
    default: SecondInventoryData,
  }),

  hoverItem: atom<Item | undefined>({
    key: 'inventoryState.hoverItem',
    default: {
      owner: '',
      slot: 1,
      id: '',
      label: '',
      description: '',
      invType: 1,
      quantity: 0,
      weight: 0,
      metaData: {},
    },
  }),

  hoveredSlot: atom<SlotHovered>({
    key: 'inventoryState.hoveredOrigin',
    default: {
      slot: 0,
      invType: 0,
      owner: '',
    },
  }),

  moveAmount: atom<string>({
    key: 'inventoryState.moveAmount',
    default: '',
  }),
}