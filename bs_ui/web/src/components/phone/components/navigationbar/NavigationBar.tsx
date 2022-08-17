import { faInternetExplorer } from "@fortawesome/free-brands-svg-icons";
import { faCircle } from "@fortawesome/free-regular-svg-icons";
import {
  faArrowsRotate,
  faBell,
  faBellSlash,
  faCamera,
} from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { Tooltip } from "@mui/material";
import { useMemo } from "react";
import { Link } from "react-router-dom";
import { useRecoilState } from "recoil";
import { PHONE_STRINGS } from "../../config/config";
import { phoneState } from "../../hooks/state";
import "./NavigationBar.css";

export default function NavigationBar() {
  const [sounds, setSounds] = useRecoilState(phoneState.sounds);

  return useMemo(
    () => (
      <div className="phone-navigation-bar">
        <div className="phone-navigation-info">
          <Tooltip
            title={PHONE_STRINGS.NAVIGATION_NOTIFICATION}
            placement="top"
            arrow
          >
            <FontAwesomeIcon
              icon={sounds ? faBell : faBellSlash}
              onClick={() => setSounds(!sounds)}
            />
          </Tooltip>
          <Tooltip
            title={PHONE_STRINGS.NAVIGATION_CAMERA}
            placement="top"
            arrow
          >
            <FontAwesomeIcon icon={faCamera} />
          </Tooltip>
          <Tooltip title={PHONE_STRINGS.NAVIGATION_HOME} placement="top" arrow>
            <Link to="/">
              <FontAwesomeIcon icon={faCircle} style={{ fontSize: "1.5rem" }} />
            </Link>
          </Tooltip>
          <Tooltip
            title={PHONE_STRINGS.NAVIGATION_SWITCH}
            placement="top"
            arrow
          >
            <FontAwesomeIcon icon={faArrowsRotate} />
          </Tooltip>
          <Tooltip
            title={PHONE_STRINGS.NAVIGATION_BROWSER}
            placement="top"
            arrow
          >
            <FontAwesomeIcon icon={faInternetExplorer} />
          </Tooltip>
        </div>
      </div>
    ),
    [sounds, setSounds]
  );
}
