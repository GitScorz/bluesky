import { atom } from 'recoil';

export const inventoryState = {
  visibility: atom<boolean>({
    key: 'inventoryState.visibility',	
    default: false,
  }),
}