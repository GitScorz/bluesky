import { useSetRecoilState } from "recoil";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { InjectDebugData } from "../../utils/debugData";
import { INVENTORY_EVENTS } from "../../types/types";
import { inventoryState } from "./state";

export const useInventoryService = () => {
  const setVisibility = useSetRecoilState(inventoryState.visibility);
  const setNotificationVisibility = useSetRecoilState(inventoryState.notificationVisibility);

  useNuiEvent(INVENTORY_EVENTS.OPEN, setVisibility);
  useNuiEvent(INVENTORY_EVENTS.SHOW_NOTIFICATION, setNotificationVisibility);
}

InjectDebugData([
  {
    action: INVENTORY_EVENTS.OPEN,
    data: true,
  },
  {
    action: INVENTORY_EVENTS.SHOW_NOTIFICATION,
    data: false,
  },
]);