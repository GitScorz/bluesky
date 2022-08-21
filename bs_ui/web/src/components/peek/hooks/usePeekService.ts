import { useSetRecoilState } from "recoil";
import { useNuiEvent } from "../../../hooks/useNuiEvent";
import { PEEK_EVENTS } from "../../../types/peek";
import { debugData } from "../../../utils/debugData";
import { peekState } from "./state";

export const usePeekService = () => {
  const setVisibility = useSetRecoilState(peekState.visibile);
  const setPeekData = useSetRecoilState(peekState.data);

  useNuiEvent(PEEK_EVENTS.TOGGLE, (visible) => {
    setVisibility(visible);

    if (!visible) {
      setPeekData([]);
    }
  });

  useNuiEvent(PEEK_EVENTS.ENTER_TARGET, setPeekData);
  useNuiEvent(PEEK_EVENTS.LEAVE_TARGET, () => {
    setPeekData([]);
  });
}

debugData<any>([
  {
    action: PEEK_EVENTS.TOGGLE,
    data: false
  },
  {
    action: PEEK_EVENTS.ENTER_TARGET,
    data: [
      {
        icon: "user",
        label: "User",
        event: "peek:enterTarget"
      },
    ]
  },
])