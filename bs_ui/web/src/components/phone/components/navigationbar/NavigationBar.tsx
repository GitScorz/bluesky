import { faInternetExplorer } from '@fortawesome/free-brands-svg-icons';
import { faCircle } from '@fortawesome/free-regular-svg-icons';
import { faBell, faCamera, faRepeat } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Tooltip } from '@mui/material';
import { Link } from 'react-router-dom';
import { PhoneStrings } from '../../config/config';
import './NavigationBar.css';

export default function NavigationBar() {
  return (
    <div className="phone-navigation-bar">
      <div className="phone-navigation-info">
      <Tooltip title={PhoneStrings.NAVIGATION_NOTIFICATION} placement="top" arrow>
          <FontAwesomeIcon icon={faBell} />
        </Tooltip>
        <Tooltip title={PhoneStrings.NAVIGATION_CAMERA} placement="top" arrow>
          <FontAwesomeIcon icon={faCamera} />
        </Tooltip>
        <Tooltip title={PhoneStrings.NAVIGATION_HOME} placement="top" arrow>
          <Link to="/">
            <FontAwesomeIcon icon={faCircle} style={{ fontSize: "1.5rem" }} />
          </Link>
        </Tooltip>
        <Tooltip title={PhoneStrings.NAVIGATION_SWITCH} placement="top" arrow>
          <FontAwesomeIcon icon={faRepeat} />
        </Tooltip>
        <Tooltip title={PhoneStrings.NAVIGATION_BROWSER} placement="top" arrow>
          <FontAwesomeIcon icon={faInternetExplorer} />
        </Tooltip>
      </div>
    </div>
  )
}
