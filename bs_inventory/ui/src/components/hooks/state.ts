import { atom } from 'recoil';

export const inventoryState = {
  visibility: atom<boolean>({
    key: 'inventoryState.visibility',	
    default: false,
  }),
  notificationVisibility: atom<boolean>({
    key: 'inventoryState.notificationVisibility',
    default: false,
  }),
}