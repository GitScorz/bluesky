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

    const timeId = setTimeout(() => {
      setCashVisible(false);
      setBankVisible(false);
    }, 7000);

    return () => {
      clearTimeout(timeId);
    }
  }, []);
  
  useNuiEvent('hud:balance:setCash', (data: UI.Balance.BalanceType) => {
    setCash(data.cash);
  });

  useNuiEvent('hud:balance:setBank', (data: UI.Balance.BalanceType) => {
    setBank(data.bank);
  });
  
  useNuiEvent('hud:balance:setBankVisible', (shouldShow: boolean) => {
    setBankVisible(shouldShow);
  });

  useNuiEvent('hud:balance:setCashVisible', (shouldShow: boolean) => {
    setCashVisible(shouldShow);
  });

  return (
    <div className="balance-wrapper" style={{ fontFamily: "Pricedown" }}>
      <div className="bank-container" style={{ visibility: bankVisible ? "visible" : "hidden" }}>
        <div className="bank-balance">$ <span className="money">{bank}</span></div>
      </div>
      <div className="cash-container" style={{ visibility: cashVisible ? "visible" : "hidden" }}>
        <div className="cash-balance">$ <span className="money">{cash}</span></div>
      </div>
    </div>
  )
}