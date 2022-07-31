import './Details.css';
import { useState } from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faAddressCard, faCircleCheck, faMobileAndroid, faPiggyBank, faWallet, faXmarkCircle } from '@fortawesome/free-solid-svg-icons';
import { Tooltip } from '@mui/material';
import { fetchNui } from '../../../../utils/fetchNui';
import { PhoneStrings } from '../../config/config';

export default function Details() {
  const [phoneData, setPhoneData] = useState<UI.Phone.PhoneData>({
    serverId: 1,
    phoneNumber: '123456789',
    cash: 0,
    bank: 0,
    hasDriverLicense: true,
  });

  fetchNui('hud:phone:getPhoneData').then((data: UI.Phone.PhoneData) => {
    setPhoneData(data);
  });

  // Format the cash and bank values
  const formatter = new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
  });

  // Sorry being a noob i am still learning React, I can make this better later...
  return (
    <div className="details-wrapper">
      <div className="details-account">
        <div className="details-info">
          <div className="details-server-info">
            <Tooltip title={PhoneStrings.CIVILIAN_ID} placement='top' arrow>
              <FontAwesomeIcon icon={faAddressCard} />
            </Tooltip>
            <div id="details-server-text">{phoneData?.serverId}</div>
          </div>

          <div className="details-server-info">
            <Tooltip title={PhoneStrings.PHONE_NUMBER} placement='top' arrow>
              <FontAwesomeIcon icon={faMobileAndroid} />
            </Tooltip>
            <div id="details-server-text">{phoneData?.phoneNumber}</div>
          </div>

          <div className="details-server-info">
            <Tooltip title={PhoneStrings.WALLET} placement='top' arrow>
              <FontAwesomeIcon icon={faWallet} style={{ color: "#78c72e" }} />
            </Tooltip>
            <div id="details-server-text">{formatter.format(phoneData.cash)}</div>
          </div>

          <div className="details-server-info">
            <Tooltip title={PhoneStrings.BANK} placement='top' arrow>
              <FontAwesomeIcon icon={faPiggyBank} style={{ color: "#60a9fc" }} />
            </Tooltip>
            <div id="details-server-text">{formatter.format(phoneData.bank)}</div>
          </div>
        </div>

        { /* /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// */ }
        { /* /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// */ }
        { /* /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// */ }
        { /* /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// */ }
        { /* /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// */ }
        { /* /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// */ }

        <div className="details-licenses">
          <div id="licenses-title">Licenses</div>
          <div className="details-licenses-list">
            <div className='details-licenses-info'>
              <div id="details-licenses-name">Driving License</div>
              <Tooltip title={phoneData?.hasDriverLicense ? "I got it" : "I don't need it"} placement='top' arrow>
                <FontAwesomeIcon 
                  icon={phoneData?.hasDriverLicense ? faCircleCheck : faXmarkCircle } 
                  style={{ 
                    color: phoneData?.hasDriverLicense ? "#729b4b" : "#750b0b"
                  }}
                />
              </Tooltip>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}