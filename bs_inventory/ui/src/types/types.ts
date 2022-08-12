export interface ISlot {
  invItems: Item[];
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
  description?: string;
  slot: number;
  weight: number;
  quantity: number;
  creationDate: number;
  data: any;
}

export interface PropSlot {
  index: number;
  item?: Item;
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