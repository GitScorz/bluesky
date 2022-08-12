export interface ISlot {
  slot: number;
  invName: string;
  hotkeys: boolean;
}

export interface InventoryState {
  label: string;
  weight: number;
  maxWeight: number;
  items: Item[];
}

export interface SecondInventoryState extends InventoryState {
  id: string;
}

export interface Item {
  label: string;
  id: string;
  slot: number;
  creationDate: number;
  data: any;
}

export enum INVENTORY_EVENTS {
  OPEN = 'inventory:open',
  CLOSE = 'inventory:close',
  SHOW_NOTIFICATION = 'inventory:showNotification',
  GET_PLAYER_INVENTORY = 'inventory:getPlayerInventory',
  GET_SECOND_INVENTORY = 'inventory:getSecondInventory',
}

export interface ServerPromiseResp<T = undefined> {
  errorMsg?: string;
  status?: 'ok' | 'error';
  data: T;
}