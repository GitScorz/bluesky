export enum BALANCE_EVENTS {
  SHOW_CASH = "balance:showCash",
  UPDATE_CASH = "balance:updateCash",
}

export interface CashVisible {
  visible: boolean;
  cash?: number;
}

export interface CashState {
  currentCash: number;
  toUpdate: number;
}