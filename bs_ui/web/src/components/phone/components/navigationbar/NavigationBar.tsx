import { faCircle } from '@fortawesome/free-regular-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Tooltip } from '@mui/material';
import { Link } from 'react-router-dom';
import './NavigationBar.css';

export default function NavigationBar() {
  return (
    <div className="phone-navigation-bar">
      <div className="phone-navigation-info">
        <Tooltip title="Home" placement="top" arrow>
          <Link to="/">
            <FontAwesomeIcon icon={faCircle} />
          </Link>
        </Tooltip>
      </div>
    </div>
  )
}
