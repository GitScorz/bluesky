import { Fade } from "@mui/material";
import { useEffect, useState } from "react"
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { isEnvBrowser } from "../../utils/misc";
import './Balance.css';

export default function Balance() {
  const [cashVisible, setCashVisible] = useState(false);
  const [bankVisible, setBankVisible] = useState(false);

  const [cash, setCash] = useState(0);
  const [bank, setBank] = useState(0);

  const setVisibleTimeCash = () => {
    setCashVisible(true);
    setTimeout(() => {
      setCashVisible(false);
    }, 5000);
  }

  const setVisibleTimeBank = () => {
    setBankVisible(true);
    setTimeout(() => {
      setBankVisible(false);
    }, 5000);
  }

  useEffect(() => {
    if (isEnvBrowser()) {
      setVisibleTimeCash();
      setVisibleTimeBank();
    }
  }, []);
  
  useNuiEvent('hud:balance:updateCash', (data: UI.Balance.BalanceTypes) => {
    setCash(data.cash);
  });

  useNuiEvent('hud:balance:updateBank', (data: UI.Balance.BalanceTypes) => {
    setBank(data.bank);
  });
  
  useNuiEvent('hud:balance:setBankVisible', (shouldShow: boolean) => {
    setVisibleTimeBank();
  });

  useNuiEvent('hud:balance:setCashVisible', (shouldShow: boolean) => {
    setVisibleTimeCash();
  });

  return (
    <div className="balance-container" style={{ fontFamily: "Pricedown" }}>
      <Fade timeout={{ enter: 500, exit: 500 }} in={bankVisible}>
        <div className={`"bank-container`} style={{ opacity: `${bankVisible ? "1" : "0"}` }}>
          <div className="bank-balance">$ <span className="money">{bank}</span></div>
        </div>
      </Fade>
      
      <Fade timeout={{ enter: 500, exit: 500 }} in={cashVisible}>
        <div className={`cash-container`} style={{ opacity: `${cashVisible ? "1" : "0"}`}}>
          <div className="cash-balance">$ <span className="money">{cash}</span></div>
        </div>
      </Fade>
    </div>
  )
}