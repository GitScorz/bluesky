import { useSetRecoilState } from "recoil";
import { useNuiEvent } from "../../../hooks/useNuiEvent";
import { PHONE_EVENTS } from "../../../types/phone";
import { debugData } from "../../../utils/debugData";
import { DefaultPhoneData, DefaultPhoneTime } from "../utils/constants";
import { phoneState } from "./state";

export const usePhoneService = () => {
  const setVisibility = useSetRecoilState(phoneState.visibility);
  const setPhoneTime = useSetRecoilState(phoneState.phoneTime);
  const setPhoneData = useSetRecoilState(phoneState.phoneData);

  useNuiEvent(PHONE_EVENTS.OPEN, setVisibility);
  useNuiEvent(PHONE_EVENTS.UPDATE_PHONE_TIME, setPhoneTime);
  useNuiEvent(PHONE_EVENTS.UPDATE_PHONE_DATA, setPhoneData);
}

debugData<any>([
  {
    action: PHONE_EVENTS.OPEN,
    data: true,
  },
  {
    
    action: PHONE_EVENTS.UPDATE_PHONE_TIME,
    data: DefaultPhoneTime,
  },
  {
    action: PHONE_EVENTS.UPDATE_PHONE_DATA,
    data: DefaultPhoneData,
  },
]);