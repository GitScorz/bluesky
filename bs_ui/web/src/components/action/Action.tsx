import { Slide } from '@mui/material';
import { useEffect, useState } from 'react'
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { isEnvBrowser } from '../../utils/misc';
import './Action.css';

export default function Action() {
  const [visible, setVisible] = useState(false);
  const [text, setText] = useState('');

  useEffect(() => {
    if (isEnvBrowser()) {
      setVisible(true);
      setText('[E] Action');
    }
  }, []);

  useNuiEvent('hud:action:showAction', (data: UI.Action.ActionData) => {
    setVisible(true);
    setText(data.text);
  });
  
  return (
    <Slide direction='right' timeout={{ enter: 500, exit: 500 }} in={visible}>
      <div className='action-container'>
        <div className='action-text'>{text.toUpperCase()}</div>
      </div>
    </Slide>
  )
}
