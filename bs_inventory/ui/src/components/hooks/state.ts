import { atom, selector } from 'recoil';
import { fetchNui } from '../../utils/fetchNui';
import { buildRespObj } from '../../utils/misc';
import { InventoryState, INVENTORY_EVENTS, ServerPromiseResp } from '../../types/types';
import { InventoryData, SecondInventoryData } from '../../utils/constants';

export const inventoryState = {
  visibility: atom<boolean>({
    key: 'inventoryState.visibility',	
    default: false,
  }),

  notificationVisibility: atom<boolean>({
    key: 'inventoryState.notificationVisibility',
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
}