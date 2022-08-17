import "./PhoneHeader.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useMemo, useState } from "react";
import {
  faSignal,
  faSun,
  faUnlock,
  faWifi,
} from "@fortawesome/free-solid-svg-icons";
import { Tooltip } from "@mui/material";
import { PHONE_STRINGS } from "../../config/config";
import { useRecoilState } from "recoil";
import { phoneState } from "../../hooks/state";

export default function PhoneHeader() {
  const [connected] = useState(false); // TODO soon..
  const [phoneData] = useRecoilState(phoneState.phoneData);
  const [time] = useRecoilState(phoneState.phoneTime);

  return useMemo(
    () => (
      <>
        <div className="phone-header">
          <div className="phone-header-info">
            <div style={{ position: "relative", width: "50%", left: "10px" }}>
              <span>
                {time.hour}:{time.minute}
              </span>
            </div>
            <div># {phoneData.sid}</div>
          </div>
          <div className="phone-header-icons">
            <FontAwesomeIcon icon={faSun} />
            <FontAwesomeIcon style={{ color: "#607c8a" }} icon={faUnlock} />
            <Tooltip title={PHONE_STRINGS.HEADER_CONNECT} placement="top" arrow>
              <FontAwesomeIcon
                id="phone-signal"
                icon={connected ? faWifi : faSignal}
              />
            </Tooltip>
          </div>
        </div>
      </>
    ),
    [connected, time, phoneData]
  );
}
