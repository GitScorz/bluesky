import { atom } from "recoil";
import { DisplayTime, ModalParams, PhoneContact, PhoneData } from "../../../types/phone";
import { DefaultContacts, DefaultPhoneData } from "../utils/constants";

export const modalState = {
  open: atom<boolean>({
    key: "modalState.open",
    default: false,
  }),

  // params: atom<ModalParams>({
  //   key: "modalState.params",
  //   default: {
  //     id: "",
  //     label: "",
  //     expected: "none",
  //     input: "",
  //     minLength: 0,
  //     maxLength: 0,
  //     icon: undefined,
  //   },
  // }),
}

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

export const contactsState = {
  contacts: atom<PhoneContact[]>({
    key: 'contactsState.contacts',
    default: DefaultContacts
  }),
}