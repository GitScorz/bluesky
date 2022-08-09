import { Slide, Tooltip } from "@mui/material";
import { useEffect, useState } from "react";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { debugData } from "../../utils/debugData";
import { fetchNui } from "../../utils/fetchNui";
import './index.style.css';

debugData([
  {
    action: 'hud:radio:toggle',
    data: true
  }
])

export default function Radio() {
  const [visible, setVisible] = useState(false);
  const [power, setPower] = useState(false);
  const [frequency, setFrequency] = useState("");

  useEffect(() => {
    const handleKeyEvent = (event: KeyboardEventInit) => {
      if (event.key === "Escape") {
        setVisible(false);
        fetchNui('hud:radio:close');
      }
    };

    window.addEventListener('keyup', handleKeyEvent);
  }, []);

  useNuiEvent("hud:radio:toggle", (toggle: boolean) => {
    setVisible(toggle);
  });

  const handlePower = () => {
    fetchNui('hud:radio:setPower', !power);
    setPower(!power);
  }

  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    event.preventDefault();
    const freq = event.target.value;

    if (Number(freq) > 999) {
      setFrequency("999");
      return;
    }

    setFrequency(event.target.value);
  }

  return (
    <Slide direction="up" timeout={{ enter: 400, exit: 500 }} in={visible}>
      <div className="radio-container">
        <div className="radio-frame">
          <Tooltip title={`Switch ${power ? "Off" : "On" }`} placement="left" arrow>
            <div className="radio-power" onClick={handlePower} />
          </Tooltip>

          <div className="radio-freq">
            <input 
              id="radio-freq-input"
              type="number"
              min={1}
              max={999}
              step=".1"
              disabled={!power}
              placeholder={`${!power ? "" : "100.0+" }`}
              onChange={handleChange}
              value={!power ? "" : frequency}
              onKeyDown={(e) => {
                if (e.key === "Enter") {
                  fetchNui('hud:radio:setFrequency', Number(e.target.value));
                }
              }}
            />
          </div>
        </div>
      </div>
    </Slide>
  )
}