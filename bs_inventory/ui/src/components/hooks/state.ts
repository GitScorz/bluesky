import { atom, selector } from 'recoil';
import { fetchNui } from '../../utils/fetchNui';
import { buildRespObj } from '../../utils/misc';
import { InventoryState, INVENTORY_EVENTS, SecondInventoryState, ServerPromiseResp } from '../../types/types';
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
    default: selector({
      key: 'playerInventoryDefault',
      get: async ({ get }) => {
        const resp = await fetchNui<ServerPromiseResp<InventoryState>>(
          INVENTORY_EVENTS.GET_PLAYER_INVENTORY,
          {},
          buildRespObj(InventoryData)
        );

        const data = resp.data;

        return data;
      }
    }),
  }),

  secondInventory: atom<SecondInventoryState>({
    key: 'inventoryState.secondInventory',
    default: selector({
      key: 'secondInventoryDefault',
      get: async ({ get }) => {
        const resp = await fetchNui<ServerPromiseResp<SecondInventoryState>>(
          INVENTORY_EVENTS.GET_SECOND_INVENTORY,
          {},
          buildRespObj(SecondInventoryData)
        );

        const data = resp.data;

        return data;
      }
    }),
  }),
}