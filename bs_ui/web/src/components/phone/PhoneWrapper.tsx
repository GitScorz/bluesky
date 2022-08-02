import { Slide } from "@mui/material";
import { useEffect, useState } from "react"
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { debugData } from "../../utils/debugData";
import { fetchNui } from "../../utils/fetchNui";
import './Phone.css';
import { useNavigate } from "react-router-dom";

debugData([
  {
    action: 'hud:phone:toggle',
    data: true,
  }
])

export default function PhoneWrapper({ children }: any) {
  const [visible, setVisible] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    const handleKeyEvent = (event: KeyboardEventInit) => {
      if (event.key === "Escape") {
        fetchNui('hud:phone:close');
        setVisible(false);
        navigate('/');
      }
    };

    window.addEventListener('keyup', handleKeyEvent);
  });

  useNuiEvent<boolean>('hud:phone:toggle', (visible) => {
    setVisible(visible); 
  });

  return (
    <Slide direction='up' timeout={{ enter: 600, exit: 500 }} in={visible}>
      <div className="phone-wrapper">
        <div className="phone-container" style={{
          backgroundImage: "url(media/frames/android.png"
        }} />
        <div className="phone-background" style={{ background: "linear-gradient(15deg, rgba(113,149,177,1) 0%, rgba(189,221,226,1) 100%)" }}>
          {children}
        </div>
      </div>
    </Slide>
  )
}