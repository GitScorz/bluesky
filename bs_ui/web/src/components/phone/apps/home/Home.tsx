import './Home.css';
import { Tooltip } from "@mui/material";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faBookBookmark, faCircleInfo } from "@fortawesome/free-solid-svg-icons";
import { Link } from "react-router-dom";
import { PhoneStrings } from '../../config/config';

// Basically the phone app's home page.
export default function Home() {
  return (
    <>
      <div className="phone-apps-wrapper">
        <Tooltip title={PhoneStrings.APP_DETAILS} placement="top" arrow>
          <div className="phone-apps-details">
            <Link to={"/details"}>
              <div className="phone-apps-icon">
                <FontAwesomeIcon icon={faCircleInfo} />
              </div>
            </Link>
          </div>
        </Tooltip>
        <Tooltip title={PhoneStrings.APP_CONTACTS} placement="top" arrow>
          <div className="phone-apps-contacts">
            <Link to={"/contacts"}>
              <div className="phone-apps-icon">
                <FontAwesomeIcon icon={faBookBookmark} />
              </div>
            </Link>
          </div>
        </Tooltip>
      </div>
    </>
  )
}