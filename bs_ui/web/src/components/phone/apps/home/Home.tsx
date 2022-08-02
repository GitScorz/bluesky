import './Home.css';
import { Tooltip } from "@mui/material";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faBookBookmark, faCircleInfo } from "@fortawesome/free-solid-svg-icons";
import { Link } from "react-router-dom";
import { PhoneStrings } from '../../config/config';
import { APPS } from '../../config/apps';

// Basically the phone app's home page.
export default function Home() {
  return (
    <>
      <div className="phone-apps-wrapper">
        {APPS.map((app, index) => (
          <Tooltip title={app.label} key={index} placement="top" arrow>
            <div 
              style={{
                width: "20%", 
                height: "10%", 
                borderRadius: "1.5vh", 
                ...app.style
              }}>
              <Link to={app.rootPath}>
                <div className="phone-apps-icon">
                  <FontAwesomeIcon icon={app.icon} />
                </div>
              </Link>
            </div>
          </Tooltip>
        ))}
      </div>
    </>
  )
}