import { useRecoilState } from 'recoil';
import { inventoryState } from '../hooks/state';
import './inventory.styles.css';
import Fade from '@mui/material/Fade';
import { fetchNui } from '../../utils/fetchNui';
import { INVENTORY_EVENTS } from '../../types/types';
import { useEffect } from 'react';
import Header from './components/header';

export default function Inventory() {
  const [visibility, setVisibility] = useRecoilState(inventoryState.visibility);
  const [playerInventory, setPlayerInventory] = useRecoilState(
    inventoryState.playerInventory,
  );

  const [secondInventory, setSecondInventory] = useRecoilState(
    inventoryState.secondInventory,
  );

  useEffect(() => {
    const handleKeyEvent = (event: KeyboardEventInit) => {
      if (event.key === 'Escape') {
        handleClose();
      }
    };

    window.addEventListener('keyup', handleKeyEvent);
  });

  const handleClose = () => {
    setVisibility(false);
    fetchNui(INVENTORY_EVENTS.CLOSE);

    const clearData = {
      label: '',
      weight: 0,
      maxWeight: 0,
      items: [],
    };

    setPlayerInventory({
      ...clearData,
    });

    setSecondInventory({
      id: '',
      ...clearData,
    });
  };

  return (
    <Fade in={visibility}>
      <div className="inventory-wrapper">
        <div className="inventory-container">
          <div id="mainInv" className="inventory-box">
            <Header
              invName={'Player'}
              weight={playerInventory.weight}
              maxWeight={playerInventory.maxWeight}
            />
          </div>
          <div className="inventory-actions">
            <input
              className="option"
              type="number"
              id="move-amount"
              max="9999"
              min="0"
              placeholder="Amount"
            />
            <button id="use-btn">Use</button>
            <button onClick={handleClose}>Close</button>
          </div>
          <div id="secondaryInv" className="inventory-box">
            <Header
              invName={secondInventory.label}
              weight={secondInventory.weight}
              maxWeight={secondInventory.maxWeight}
            />
          </div>
        </div>
      </div>
    </Fade>
  );
}
