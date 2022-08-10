import { useState } from 'react';
import { debugData } from '../utils/debugData';
import { useNuiEvent } from '../hooks/useNuiEvent';
import Fade from '@mui/material/Fade';
import './App.css';
import Inventory from './inventory';

debugData([
  {
    action: 'openInventory',
    data: true,
  },
]);

export default function App() {
  const [visible, setVisible] = useState(false);

  useNuiEvent('openInventory', (toggle: boolean) => {
    setVisible(toggle);
  });

  return (
    <Fade in={visible}>
      <div>
        <Inventory />
      </div>
    </Fade>
  );
}
