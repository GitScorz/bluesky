import './PhoneHeader.css';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { useState } from 'react'
import { useNuiEvent } from '../../../../hooks/useNuiEvent';
import { faSignal, faSun, faUnlock, faWifi } from "@fortawesome/free-solid-svg-icons";
import { Tooltip } from '@mui/material';

export default function PhoneHeader() {
  const [time, setTime] = useState("00:00");
  const [connected, setConnected] = useState(false);
  const [phoneData, setPhoneData] = useState<UI.Phone.PhoneData>({
    serverId: 1,
  });

  useNuiEvent('hud:phone:updateTime', (time: UI.Phone.DisplayTime) => {
    console.log(time)
    setTime(`${time.hour}:${time.minute}`);
  });

  useNuiEvent('hud:phone:loadPhoneData', function(data: UI.Phone.PhoneData) {
    setPhoneData(data);
  });

  return (
    <div className="phone-header">
      <div className="phone-header-info">
        <div style={{ position: "relative", width: "50%", left: "10px" }}>{time}</div>
        <div># {phoneData?.serverId}</div>
      </div>
      <div className="phone-header-icons">
        <FontAwesomeIcon icon={faSun} />
        <FontAwesomeIcon style={{ color: "#607c8a" }} icon={faUnlock} />
        <Tooltip title="Connect" placement="top" arrow>
          <FontAwesomeIcon id="phone-signal" icon={connected ? faWifi : faSignal} />
        </Tooltip>
      </div>
    </div>
  )
}
