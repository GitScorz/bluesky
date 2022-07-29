import { Slide } from '@mui/material';
import { useEffect, useState } from 'react'
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { isEnvBrowser } from '../../utils/misc';
import './Interaction.css';

export default function Interaction() {
  const [visible, setVisible] = useState(false);
  const [interactionData, setInteractionData] = useState<UI.Interaction.Data>({ action: "", colorType: "default" });

  useEffect(() => {
    if (isEnvBrowser()) {
      setVisible(false);
      setInteractionData(oldData => ({ ...oldData, action: "Parking", colorType: "default" }));
    }
  }, []);

  useNuiEvent('hud:action:showInteraction', (data: UI.Interaction.Data) => {
    setVisible(true);
    setInteractionData(oldData => ({ ...oldData, ...data }));
  });

  useNuiEvent('hud:action:hideInteraction', () => {
    setVisible(false);
  });
  
  const getColor = (type: string) => {
    switch (type) {
      case 'error':
        return '#ff0000';
      case 'success':
        return '#8cff82';
      case 'default':
        return '#1e1f24';
      default:
        return '#1e1f24';
    }
  }

  return (
    <Slide direction='right' timeout={{ enter: 600, exit: 500 }} in={visible}>
      <div className='action-container' style={{ backgroundColor: getColor(interactionData.colorType) }}>
        <div className='action-text'>{interactionData.action}</div>
      </div>
    </Slide>
  )
}
