import { useSetRecoilState } from "recoil";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { InjectDebugData } from "../../utils/debugData";
import { INVENTORY_EVENTS } from "../../types/types";
import { inventoryState } from "./state";
import { InventoryData, SecondInventoryData } from "../../utils/constants";

export const useInventoryService = () => {
  const setVisibility = useSetRecoilState(inventoryState.visibility);
  const setPlayerInventory = useSetRecoilState(inventoryState.playerInventory);
  const setSecondInventory = useSetRecoilState(inventoryState.secondInventory);

  useNuiEvent(INVENTORY_EVENTS.OPEN, setVisibility);
  useNuiEvent(INVENTORY_EVENTS.UPDATE_PLAYER_INVENTORY, setPlayerInventory);
  useNuiEvent(INVENTORY_EVENTS.UPDATE_SECONDARY_INVENTORY, setSecondInventory);
}

InjectDebugData<any>([
  {
    action: INVENTORY_EVENTS.OPEN,
    data: false,
  },
  {
    action: INVENTORY_EVENTS.UPDATE_PLAYER_INVENTORY,
    data: InventoryData,
  },
  {
    action: INVENTORY_EVENTS.UPDATE_SECONDARY_INVENTORY,
    data: SecondInventoryData,
  },
]);