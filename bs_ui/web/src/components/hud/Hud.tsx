import { useEffect, useState } from 'react';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { isEnvBrowser } from '../../utils/misc';
import Player from './Player/Player';
import Vehicle from './Vehicle/Vehicle';

export default function Hud() {
  const [visible, setVisible] = useState(false);

  // Default values for the HUD
  const [status, setStatus] = useState<UI.Status.HudProps>({ voice: 70, health: 50, armor: 10, hunger: 50, thirst: 50 });

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
  }, [visible]);
  
  useNuiEvent('hud:status:visible', (shouldShow: boolean) => {
    setVisible(shouldShow);
  });

  useNuiEvent('hud:status:update', (data: UI.Status.HudProps) => {
    setStatus({ 
      voice: data.voice,
      health: data.health, 
      armor: data.armor, 
      thirst: data.thirst, 
      hunger: data.hunger 
    });
  });

  return (
    <div className="hud-wrapper" style={{ visibility: visible ? 'visible' : 'hidden' }}>
      <Player {...status} />
      <Vehicle />
    </div>
  );
}