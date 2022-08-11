export interface InventoryState {
  player: PlayerState;
  secondary: PlayerState;
  equipment: EquipmentState;
  showSecondary: boolean;
  hover: boolean;
  hoverOrigin: null;
  contextItem: null;
  splitItem: null;
}

export interface PlayerState {
  size: number;
  invType: number;
  name: string;
  inventory: any[];
  owner: number;
}

export interface EquipmentState {
  inventory: any[];
}

export enum ACTIONS {
  SET_PLAYER = 'SET_PLAYER',
  SET_SECONDARY = 'SET_SECONDARY',
  SET_EQUIPMENT = 'SET_EQUIPMENT',
}

export enum INVENTORY_EVENTS {
  OPEN = 'inventory:open',
  CLOSE = 'inventory:close',
}