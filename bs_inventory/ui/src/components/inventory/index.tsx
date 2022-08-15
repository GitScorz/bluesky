import { useRecoilState } from 'recoil';
import { inventoryState } from '../hooks/state';
import './inventory.styles.css';
import { Fade } from '@mui/material';
import { fetchNui } from '../../utils/fetchNui';
import { INVENTORY_EVENTS } from '../../types/types';
import { useEffect, useState } from 'react';
import Header from './components/header';
import Slots from './components/slots';
import ItemInfo from './components/iteminfo';

export default function Inventory() {
  const [moveAmount, setMoveAmount] = useState('');
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
  };

  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    event.preventDefault();
    const amt = event.target.value;

    if (Number(amt) > 9999) {
      setMoveAmount('9999');
      return;
    }

    setMoveAmount(event.target.value);
  };

  return (
    <Fade in={visibility}>
      <div className="inventory-wrapper">
        <ItemInfo />
        <div className="inventory-container">
          <div id="mainInv" className="inventory-box">
            <Header
              invName={playerInventory.name}
              weight={playerInventory.weight}
              maxWeight={playerInventory.maxWeight}
            />
            <Slots
              invItems={playerInventory.inventory}
              slots={playerInventory.size}
            />
          </div>
          <div className="inventory-actions">
            <input
              className="option"
              type="number"
              id="move-amount"
              max="9999"
              min="0"
              value={moveAmount}
              onChange={handleChange}
              placeholder="Amount"
            />
            <button id="use-btn">Use</button>
            <button onClick={handleClose}>Close</button>
          </div>
          <div id="secondaryInv" className="inventory-box">
            <Header
              invName={secondInventory.name}
              weight={secondInventory.weight}
              maxWeight={secondInventory.maxWeight}
            />
            <Slots
              invItems={secondInventory.inventory}
              slots={secondInventory.size}
            />
          </div>
        </div>
      </div>
    </Fade>
  );
}
