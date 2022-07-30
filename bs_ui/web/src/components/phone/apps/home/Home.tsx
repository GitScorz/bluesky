import './Home.css';
import { Tooltip } from "@mui/material";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faBookBookmark, faCircleInfo } from "@fortawesome/free-solid-svg-icons";
import { Link } from "react-router-dom";

// Basically the phone app's home page.
export default function Home() {
  return (
    <>
      <div className="phone-apps-wrapper">
        <Tooltip title="Details" placement="top" arrow>
          <div className="phone-apps-details">
            <div className="phone-apps-icon">
              <Link to={"/details"}>
                <FontAwesomeIcon icon={faCircleInfo} />
              </Link>
            </div>
          </div>
        </Tooltip>
        <Tooltip title="Contacts" placement="top" arrow>
          <div className="phone-apps-contacts">
            <div className="phone-apps-icon">
              <Link to={"/contacts"}>
                <FontAwesomeIcon icon={faBookBookmark} />
              </Link>
            </div>
          </div>
        </Tooltip>
      </div>
    </>
  )
}