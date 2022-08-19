import { Fade } from "@mui/material";
import { useRecoilValue } from "recoil";
import { balanceState } from "./hooks/state";
import { useBalanceService } from "./hooks/useBalanceService";
import "./balance.css";
import { useMemo } from "react";

export default function Balance() {
  useBalanceService();

  const cashState = useRecoilValue(balanceState.cashState);
  const addState = useRecoilValue(balanceState.add);
  const removeState = useRecoilValue(balanceState.remove);

  return useMemo(
    () => (
      <Fade timeout={{ enter: 100, exit: 200 }} in={cashState.visible}>
        <div className="balance-wrapper" style={{ fontFamily: "Pricedown" }}>
          <div className="containers">
            {addState && addState.visible && (
              <div className="add-container">
                <span>+</span>
                <span className="dollar-sign">$</span>
                <span className="money">
                  {addState.cash?.toString().substring(0)}
                </span>
              </div>
            )}

            {removeState && removeState.visible && (
              <>
                <div className="remove-container">
                  <span>-</span>
                  <span className="red">$</span>
                  <span className="money">
                    {removeState.cash?.toString().substring(1)}
                  </span>
                </div>
              </>
            )}

            <div className="cash-container">
              <span className="dollar-sign">$</span>
              <span className="money">{cashState.cash}</span>
            </div>
          </div>
        </div>
      </Fade>
    ),
    [cashState, addState, removeState]
  );
}
