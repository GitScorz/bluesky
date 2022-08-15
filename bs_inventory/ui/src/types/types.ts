export interface ISlot {
  invItems: Item[];
  slots: number;
}

export interface InventoryState {
  owner: string;
  name: string;
  weight: number;
  maxWeight: number;
  size: number;
  invType: number;
  inventory: Item[];
}

export interface Item {
  id: string;
  owner: string;
  label: string;
  description?: string;
  slot: number;
  weight: number;
  quantity: number;
  invType: number;
  // creationDate: number;
  metaData: object;
}

export interface ItemNotification {
  id: string;
  label: string;
  text: string;
  quantity: number;
}

export interface PropSlot {
  index: number;
  item?: Item;
}

export enum INVENTORY_EVENTS {
  OPEN = 'inventory:open',
  CLOSE = 'inventory:close',
  SHOW_NOTIFICATION = 'inventory:showNotification',
  UPDATE_PLAYER_INVENTORY = 'inventory:updatePlayerInventory',
  UPDATE_SECONDARY_INVENTORY = 'inventory:updateSecondaryInventory',
  SEND_CLIENT_NOTIFY = 'inventory:sendClientNotify',
  USE_ITEM = 'inventory:useItem',
}

export interface ServerPromiseResp<T = undefined> {
  errorMsg?: string;
  status?: 'ok' | 'error';
  data: T;
}