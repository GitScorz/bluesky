import { Slide } from '@mui/material';
import { useEffect, useState } from 'react'
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { isEnvBrowser } from '../../utils/misc';
import './Action.css';

export default function Action() {
  const [visible, setVisible] = useState(false);
  const [actionData, setActionData] = useState({ action: '', colorType: '' });

  useEffect(() => {
    if (isEnvBrowser()) {
      setVisible(true);
      setActionData(oldData => ({ ...oldData, action: '[E] Open', colorType: 'success' }));
    }
  }, []);

  useNuiEvent('hud:action:showInteraction', (data: UI.Action.ActionData) => {
    setVisible(true);
    setActionData(oldData => ({ ...oldData, ...data }));
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
    <Slide direction='right' timeout={{ enter: 500, exit: 500 }} in={visible}>
      <div className='action-container' style={{ backgroundColor: getColor(actionData.colorType) }}>
        <div className='action-text'>{actionData.action}</div>
      </div>
    </Slide>
  )
}
