interface InventoryState {
  player: PlayerState;
  secondary: PlayerState;
  equipment: EquipmentState;
  showSecondary: boolean;
  hover: boolean;
  hoverOrigin: null;
  contextItem: null;
  splitItem: null;
}

interface PlayerState {
  size: number;
  invType: number;
  name: string;
  inventory: any[];
  owner: number;
}

interface EquipmentState {
  inventory: any[];
}

enum ACTIONS {
  SET_PLAYER = 'SET_PLAYER',
  SET_SECONDARY = 'SET_SECONDARY',
  SET_EQUIPMENT = 'SET_EQUIPMENT',
}

enum INVENTORY_EVENTS {
  INVENTORY_OPEN = 'inventory:open',
  INVENTORY_CLOSE = 'inventory:close',
}