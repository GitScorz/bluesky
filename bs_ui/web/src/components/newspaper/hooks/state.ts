import { atom } from "recoil";

export const newspaperState = {
  visible: atom<boolean>({
    key: "newspaperState.visible",
    default: false,
  }),
}