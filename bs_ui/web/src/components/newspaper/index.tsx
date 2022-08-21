import { Slide } from "@mui/material";
import { useEffect } from "react";
import { useRecoilState } from "recoil";
import { NEWSPAPER_EVENTS } from "../../types/newspaper";
import { fetchNui } from "../../utils/fetchNui";
import { NEWSPAPER_STRINGS } from "./config/config";
import { newspaperState } from "./hooks/state";
import { useNewspaperService } from "./hooks/useNewspaperService";
import "./newspaper.styles.css";

export default function Newspaper() {
  useNewspaperService();

  const [visible, setVisible] = useRecoilState(newspaperState.visible);

  useEffect(() => {
    const handleKeyEvent = (event: KeyboardEventInit) => {
      if (event.key === "Escape") {
        if (visible) {
          fetchNui(NEWSPAPER_EVENTS.CLOSE, false);
          setVisible(false);
        }
      }
    };

    window.addEventListener("keyup", handleKeyEvent);
  }, [visible, setVisible]);

  return (
    <Slide in={visible} direction="up" timeout={{ enter: 400, exit: 500 }}>
      <div className="newspaper-wrapper">
        <div className="newspaper-container">
          <img
            className="texture"
            draggable={false}
            src="media/textures/newspaper.jpg"
            alt="newspaper"
          />
          <div className="newspaper-header">
            <div className="header-content">
              <div className="header-title">
                <h1>{NEWSPAPER_STRINGS.HEADER_ONE_TITLE}</h1>
              </div>
              <div className="header-footer">
                <p>{NEWSPAPER_STRINGS.HEADER_ONE_FOOTER}</p>
              </div>
            </div>
            <div className="header-content">
              <div className="header-title">
                <h1>{NEWSPAPER_STRINGS.HEADER_TWO_TITLE}</h1>
              </div>
              <div className="header-footer">
                <p>{NEWSPAPER_STRINGS.HEADER_TWO_FOOTER}</p>
              </div>
            </div>
          </div>
          <div className="newspaper-body">
            <hr />
            <div className="newspaper-subheader">
              <div className="newspaper-subheader-title">
                <h1>{NEWSPAPER_STRINGS.NAME}</h1>
                <div className="newspaper-subheader-subtitle">
                  <h2>{NEWSPAPER_STRINGS.SUBNAME}</h2>
                </div>
              </div>
            </div>
            <hr />
            <div className="newspaper-main-article">
              <img
                draggable={false}
                className="main-article-img"
                src="media/main-article/article.jpg"
                alt="article"
              />
            </div>
          </div>
          <div className="newspaper-footer">
            <div className="footer-content">
              <h2>
                {NEWSPAPER_STRINGS.FOOTER_ONE} ⚪ {NEWSPAPER_STRINGS.FOOTER_TWO}
              </h2>
            </div>
          </div>
        </div>
      </div>
    </Slide>
  );
}
