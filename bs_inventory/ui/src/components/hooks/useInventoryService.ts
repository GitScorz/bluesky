import { useSetRecoilState } from "recoil";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { InjectDebugData } from "../../utils/debugData";
import { INVENTORY_EVENTS } from "../types/types";
import { inventoryState } from "./state";

export const useInventoryService = () => {
  const setVisibility = useSetRecoilState(inventoryState.visibility);
  useNuiEvent(INVENTORY_EVENTS.OPEN, setVisibility);
}

InjectDebugData([
  {
    action: INVENTORY_EVENTS.OPEN,
    data: true,
  },
]);