import { Slide } from "@mui/material";
import { useEffect, useState } from "react"
import { isEnvBrowser } from "../../utils/misc";
import AppsWrapper from "./apps/AppsWrapper";
import './Phone.css'

export default function Phone() {
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    if (isEnvBrowser()) {
      setVisible(true);
    }
  }, []);

  return (
    <Slide direction='up' timeout={{ enter: 500, exit: 500 }} in={visible}>
      <div className="phone-container">
        
      </div>
    </Slide>
  )
}