import { atom } from "recoil";
import { PeekData } from "../../../types/peek";

export const peekState = {
  visibile: atom<boolean>({
    key: "peekState.visible",
    default: false
  }),

  data: atom<PeekData[]>({
    key: "peekState.data",
    default: []
  }),
}