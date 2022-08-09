import "./PhoneHeader.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useState } from "react";
import { useNuiEvent } from "../../../../hooks/useNuiEvent";
import {
  faSignal,
  faSun,
  faUnlock,
  faWifi,
} from "@fortawesome/free-solid-svg-icons";
import { Tooltip } from "@mui/material";
import { PhoneStrings } from "../../config/config";
import { debugData } from "../../../../utils/debugData";

debugData<UI.Phone.PhoneData>([
  {
    action: "hud:phone:updatePhoneData",
    data: {
      sid: 1,
      cid: "scorz@blue.sky",
      aliases: {
        email: "scorz@blues.sky",
        twitter: "@Scorz_Dev",
      },
      name: {
        first: "Scorz",
        last: "Blue",
      },
      phoneNumber: "6284567891",
      cash: 0,
      bank: 0,
      hasDriverLicense: true,
    },
  },
]);

export default function PhoneHeader() {
  const [time, setTime] = useState("00:00");
  const [connected, setConnected] = useState(false);
  const [phoneData, setPhoneData] = useState<UI.Phone.PhoneData>({
    sid: 1,
    cid: "scorz@blue.sky",
    aliases: {
      email: "scorz@blues.sky",
      twitter: "@Scorz_Dev",
    },
    name: {
      first: "Scorz",
      last: "Blue",
    },
    phoneNumber: "6284567891",
    cash: 0,
    bank: 0,
    hasDriverLicense: true,
  });

  useNuiEvent("hud:phone:updateTime", (time: UI.Phone.DisplayTime) => {
    setTime(`${time.hour}:${time.minute}`);
  });

  useNuiEvent("hud:phone:updatePhoneData", (data: UI.Phone.PhoneData) => {
    setPhoneData(data);
  });

  return (
    <div className="phone-header">
      <div className="phone-header-info">
        <div style={{ position: "relative", width: "50%", left: "10px" }}>
          {time}
        </div>
        <div># {phoneData?.sid}</div>
      </div>
      <div className="phone-header-icons">
        <FontAwesomeIcon icon={faSun} />
        <FontAwesomeIcon style={{ color: "#607c8a" }} icon={faUnlock} />
        <Tooltip title={PhoneStrings.HEADER_CONNECT} placement="top" arrow>
          <FontAwesomeIcon
            id="phone-signal"
            icon={connected ? faWifi : faSignal}
          />
        </Tooltip>
      </div>
    </div>
  );
}
