import { Fade } from "@mui/material";
import { useEffect, useState } from 'react';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { debugData } from "../../utils/debugData";
import { isEnvBrowser } from '../../utils/misc';
import Player from './Player/Player';
import Vehicle from './Vehicle/Vehicle';

debugData([
  {
    action: 'hud:status:visible',
    data: true, 
  },
  {
    action: 'hud:vehicle:visible',
    data: false,
  }
]);

export default function Hud() {
  const [visibleHud, setHudVisible] = useState(false);
  const [vehicleVisible, setVehicleVisible] = useState(false);

  // Default values for the HUD
  const [status, setStatus] = useState<UI.Status.HudProps>({ 
    voice: 70, 
    health: 0,
    armor: 0, 
    hunger: 0, 
    thirst: 0 
  });

  const [vehicleData, setVehicleData] = useState<UI.Vehicle.HudProps>({
    fuel: 0,
    seatbelt: false,
    speed: 0,
  });

  // End

  useEffect(() => {
    if (isEnvBrowser()) {
      // Set the HUD to the browser values
      setStatus({
        voice: 70,
        health: 40,
        armor: 40,
        hunger: 40,
        thirst: 40,
      });

      setVehicleData({
        speed: 150,
        fuel: 50,
        seatbelt: false,
      })
    }
  }, []);
  
  useNuiEvent('hud:status:visible', (shouldShow: boolean) => {
    setHudVisible(shouldShow);
  });

  useNuiEvent('hud:vehicle:visible', (shouldShow: boolean) => {
    setVehicleVisible(shouldShow);
  });

  useNuiEvent('hud:status:update', (data: UI.Status.Data) => {
    if (!visibleHud) return; // If the HUD is not visible, don't update it improve performance

    switch (data.id) {
      case 'voice':
        const voiceStates = [30,  70, 100];
        setStatus({ ...status, voice: voiceStates[data.value] });
        break;
      case 'health':
        setStatus({ ...status, health: data.value });
        break;
      case 'armor':
        setStatus({ ...status, armor: data.value });
        break;
      case 'hunger':
        setStatus({ ...status, hunger: data.value });
        break;
      case 'thirst':
        setStatus({ ...status, thirst: data.value });
        break;
      default:
        break;
    }
  });

  useNuiEvent('hud:vehicle:update', (data: UI.Vehicle.HudProps) => {
    if (!vehicleVisible) return;
    setVehicleData(data);
  });

  useNuiEvent('hud:status:reset', function() {
    setStatus({ 
      voice: 0,
      health: 0, 
      armor: 0, 
      thirst: 0, 
      hunger: 0 
    });
  });


  return (
    <div>
      <Fade timeout={{ enter: 200, exit: 200 }} in={visibleHud}>
        <div className="hud-container">
          <Player {...status} />
        </div>
      </Fade>
      <Fade timeout={{ enter: 200, exit: 200 }} in={vehicleVisible}>
        <div className="vehicle-container">
          <Vehicle {...vehicleData} />
        </div>
      </Fade>
    </div>
  );
}