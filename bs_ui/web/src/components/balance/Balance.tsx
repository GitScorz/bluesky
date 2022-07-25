import { useEffect, useState } from "react"
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { isEnvBrowser } from "../../utils/misc";
import './Balance.css';

export default function Balance() {
  const [cashVisible, setCashVisible] = useState(false);
  const [bankVisible, setBankVisible] = useState(false);

  const [cash, setCash] = useState(0);
  const [bank, setBank] = useState(0);

  useEffect(() => {
    if (isEnvBrowser()) {
      setCashVisible(true);
      setBankVisible(true);
    }
  }, [cashVisible, bankVisible]);
  
  useNuiEvent('hud:balance:setCash', (data: UI.Balance.BalanceType) => {
    setCash(data.cash);
  });

  useNuiEvent('hud:balance:setBank', (data: UI.Balance.BalanceType) => {
    setBank(data.bank);
  });

  return (
    <div className="balance-wrapper">
      <div className="bank-container" style={{ visibility: bankVisible ? "visible" : "hidden" }}>
        <div className="bank-balance">${bank}</div>
      </div>
      <div className="cash-container" style={{ visibility: cashVisible ? "visible" : "hidden" }}>
        <div className="cash-balance">${cash}</div>
      </div>
    </div>
  )
}