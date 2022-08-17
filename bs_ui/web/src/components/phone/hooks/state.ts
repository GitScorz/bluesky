import { atom } from "recoil";
import { DisplayTime, PhoneData } from "../../../types/phone";
import { DefaultPhoneData } from "../utils/constants";

export const phoneState = {
  visibility: atom<boolean>({
    key: 'phoneState.visibility',
    default: false,
  }),

  sounds: atom<boolean>({
    key: 'phoneState.sounds',
    default: true,
  }),

  phoneTime: atom<DisplayTime>({
    key: 'phoneState.phoneTime',
    default: {
      hour: "00",
      minute: "00",
    },
  }),
  
  phoneData: atom<PhoneData>({
    key: 'phoneState.phoneData',
    default: DefaultPhoneData,
  }),
}