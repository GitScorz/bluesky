import { useEffect, useState } from "react";
import { isEnvBrowser } from "../../utils/misc";

export default function Notification() {
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    if (isEnvBrowser()) {
      setVisible(true);
    }
  }, [visible]);

  return (
    <div className='notification-wrapper' style={{ visibility: visible ? "visible" : "hidden" }}>
      
    </div>
  )
}