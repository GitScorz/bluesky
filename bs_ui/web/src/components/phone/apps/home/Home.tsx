import "./Home.css";
import { Fade, Tooltip } from "@mui/material";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { Link } from "react-router-dom";
import { APPS } from "../../config/apps";
import { useMemo } from "react";

export default function Home() {
  return useMemo(
    () => (
      <>
        <Fade in={true} timeout={{ enter: 400 }}>
          <div className="phone-apps-wrapper">
            {APPS.map((app, index) => (
              <Tooltip title={app.label} key={index} placement="top" arrow>
                <div
                  style={{
                    width: "20%",
                    height: "10%",
                    borderRadius: "1.6vh",
                    ...app.style,
                  }}
                >
                  <Link to={app.rootPath}>
                    <div className="phone-apps-icon">
                      {app.icon && <FontAwesomeIcon icon={app.icon} />}
                      {app.image && (
                        <img
                          className="app-image"
                          src={app.image}
                          alt={app.label}
                        />
                      )}
                    </div>
                  </Link>
                </div>
              </Tooltip>
            ))}
          </div>
        </Fade>
      </>
    ),
    []
  );
}
