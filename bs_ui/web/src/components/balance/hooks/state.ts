import { atom } from "recoil";
import { CashVisible } from "../../../types/balance";

export const balanceState = {
  cashState: atom<CashVisible>({
    key: "balanceState.visible",
    default: {
      visible: false,
      cash: 0,
    },
  }),

  add: atom<CashVisible>({
    key: "balanceState.add",
    default: {
      visible: false,
      cash: 0,
    },
  }),

  remove: atom<CashVisible>({
    key: "balanceState.remove",
    default: {
      visible: false,
      cash: 0,
    },
  }),
}