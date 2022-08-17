import "./Details.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faAddressCard,
  faCircleCheck,
  faMobileAndroid,
  faPiggyBank,
  faWallet,
  faXmarkCircle,
} from "@fortawesome/free-solid-svg-icons";
import { Tooltip } from "@mui/material";
import { PHONE_STRINGS } from "../../config/config";
import { FormatPhoneNumber } from "../../utils/utils";
import { useRecoilState } from "recoil";
import { phoneState } from "../../hooks/state";

export default function Details() {
  const [phoneData] = useRecoilState(phoneState.phoneData);

  // Format the cash and bank values
  const formatter = new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: "USD",
  });

  // Sorry being a noob i am still learning React, I can make this better later...
  return (
    <div className="details-wrapper">
      <div className="details-account">
        <div className="details-info">
          <div className="details-server-info">
            <div id="details-server-icon">
              <Tooltip title={PHONE_STRINGS.CIVILIAN_ID} placement="top" arrow>
                <FontAwesomeIcon icon={faAddressCard} />
              </Tooltip>
            </div>
            <div id="details-server-text">{phoneData.sid}</div>
          </div>

          <div className="details-server-info">
            <div id="details-server-icon">
              <Tooltip title={PHONE_STRINGS.PHONE_NUMBER} placement="top" arrow>
                <FontAwesomeIcon icon={faMobileAndroid} />
              </Tooltip>
            </div>
            <div id="details-server-text">
              {FormatPhoneNumber(phoneData.phoneNumber)}
            </div>
          </div>

          <div className="details-server-info">
            <div id="details-server-icon">
              <Tooltip title={PHONE_STRINGS.WALLET} placement="top" arrow>
                <FontAwesomeIcon icon={faWallet} style={{ color: "#95ef79" }} />
              </Tooltip>
            </div>
            <div id="details-server-text">
              {formatter.format(phoneData.cash)}
            </div>
          </div>

          <div className="details-server-info">
            <div id="details-server-icon">
              <Tooltip title={PHONE_STRINGS.BANK} placement="top" arrow>
                <FontAwesomeIcon
                  icon={faPiggyBank}
                  style={{ color: "#60a9fc" }}
                />
              </Tooltip>
            </div>
            <div id="details-server-text">
              {formatter.format(phoneData.bank)}
            </div>
          </div>
        </div>

        <div className="details-licenses">
          <div id="licenses-title">Licenses</div>
          <div className="details-licenses-list">
            <div className="details-licenses-info">
              <div id="details-licenses-name">Driving License</div>
              <Tooltip
                title={
                  phoneData.hasDriverLicense
                    ? PHONE_STRINGS.GOT_LICENSE
                    : PHONE_STRINGS.NO_LICENSE
                }
                placement="top"
                arrow
              >
                <FontAwesomeIcon
                  icon={
                    phoneData.hasDriverLicense ? faCircleCheck : faXmarkCircle
                  }
                  style={{
                    color: phoneData.hasDriverLicense ? "#95ef79" : "#750b0b",
                  }}
                />
              </Tooltip>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
