import { Slide } from "@mui/material";
import { useEffect, useState } from "react";
import { isEnvBrowser } from "../../utils/misc";

export default function Radio() {
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    if (isEnvBrowser()) {
      setVisible(true);
    }
  }, []);

  return (
    <Slide direction="up">
      <div className='radio-container'>

      </div>
    </Slide>
  )
}