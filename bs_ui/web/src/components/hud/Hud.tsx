import { useEffect, useState } from 'react';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { isEnvBrowser } from '../../utils/misc';
import Player from './Player/Player';
import Vehicle from './Vehicle/Vehicle';

export default function Hud() {
  const [visible, setVisible] = useState(false);

  // Default values for the HUD
  const [status, setStatus] = useState<UI.Status.HudProps>({ 
    voice: 0, 
    health: 0,
    armor: 0, 
    hunger: 0, 
    thirst: 0 
  });

  useEffect(() => {
    if (isEnvBrowser()) {
      setVisible(true);

      // Set the HUD to the browser values
      setStatus({
        voice: 70,
        health: 100,
        armor: 75,
        hunger: 50,
        thirst: 50,
      });
    }
  }, [visible, status]);
  
  useNuiEvent('hud:status:visible', (shouldShow: boolean) => {
    setVisible(shouldShow);
  });

  useNuiEvent('hud:status:update', (data: UI.Status.UpdateData) => {
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
    <div className="hud-wrapper" style={{ visibility: visible ? 'visible' : 'hidden' }}>
      <Player {...status} />
      <Vehicle />
    </div>
  );
}