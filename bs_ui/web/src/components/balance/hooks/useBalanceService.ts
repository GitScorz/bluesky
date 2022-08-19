import { useSetRecoilState } from "recoil"
import { useNuiEvent } from "../../../hooks/useNuiEvent"
import { BALANCE_EVENTS, CashState } from "../../../types/balance"
import { debugData } from "../../../utils/debugData";
import { balanceState } from "./state";

export const useBalanceService = () => {
  const setCashState = useSetRecoilState(balanceState.cashState);
  const setAddState = useSetRecoilState(balanceState.add);
  const setRemoveState = useSetRecoilState(balanceState.remove);

  useNuiEvent(BALANCE_EVENTS.UPDATE_CASH, (data: CashState) => {
    const { currentCash, toUpdate } = data;

    if (toUpdate < 0) {
      setRemoveState({ visible: true, cash: toUpdate });
    } else {
      setAddState({ visible: true, cash: toUpdate });
    }

    setCashState({ visible: true, cash: currentCash });
    setTimeout(() => {
      setCashState({ visible: false, cash: currentCash });
      setAddState({ visible: false, cash: toUpdate });
      setRemoveState({ visible: false, cash: toUpdate });
    }, 5000);
  });

  useNuiEvent(BALANCE_EVENTS.SHOW_CASH, (cash: number) => {
    setCashState({ visible: true, cash: cash });

    setTimeout(() => {
      setCashState({ visible: false, cash: cash });
    }, 5000);
  });
}

debugData([
  {
    action: BALANCE_EVENTS.SHOW_CASH,
    data: 100
  },
])