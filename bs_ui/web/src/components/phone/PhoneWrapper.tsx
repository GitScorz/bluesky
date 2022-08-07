import { Slide } from "@mui/material";
import { useEffect, useState } from "react"
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { debugData } from "../../utils/debugData";
import { fetchNui } from "../../utils/fetchNui";
import './index.style.css';

debugData([
  {
    action: 'hud:phone:toggle',
    data: false,
  }
])

export default function PhoneWrapper({ children }: any) {
  const [visible, setVisible] = useState(false);
  const [notificationActive, setNotificationActive] = useState(false);

  useEffect(() => {
    const handleKeyEvent = (event: KeyboardEventInit) => {
      if (event.key === "Escape") {
        setVisible(false);
        fetchNui('hud:phone:close');
      }
    };

    window.addEventListener('keyup', handleKeyEvent);
  }, []);

  useNuiEvent('hud:phone:toggle', (toggle: boolean) => {
    setVisible(toggle);
    fetchNui('hud:phone:isNotificationActive').then((active) => {
      setNotificationActive(active);
    });
  });

  return (
    <Slide direction='up' timeout={{ enter: 600, exit: 500 }} in={visible}>
      <div className="phone-wrapper" style={{ bottom: notificationActive ? "-540px" : "10px" }}>
        <div className="phone-container" style={{
          backgroundImage: "url(media/frames/android.png)"
        }} />
        <div className="phone-background" style={{ background: "linear-gradient(15deg, rgba(113,149,177,1) 0%, rgba(189,221,226,1) 100%)" }}>
          {children}
        </div>
      </div>
    </Slide>
  )
}