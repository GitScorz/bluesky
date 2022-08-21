import { useSetRecoilState } from "recoil"
import { useNuiEvent } from "../../../hooks/useNuiEvent"
import { NEWSPAPER_EVENTS } from "../../../types/newspaper"
import { debugData } from "../../../utils/debugData"
import { newspaperState } from "./state"

export const useNewspaperService = () => {
  const setVisibility = useSetRecoilState(newspaperState.visible)

  useNuiEvent(NEWSPAPER_EVENTS.TOGGLE, setVisibility)
}

debugData([
  {
    action: NEWSPAPER_EVENTS.TOGGLE,
    data: false,
  },
])