import { useRecoilState } from 'recoil';
import { inventoryState } from '../hooks/state';
import './inventory.styles.css';
import Fade from '@mui/material/Fade';
import { fetchNui } from '../../utils/fetchNui';
import { INVENTORY_EVENTS } from '../types/types';
import { useEffect } from 'react';

export default function Inventory() {
  const [visibility, setVisibility] = useRecoilState(inventoryState.visibility);

  useEffect(() => {
    const handleKeyEvent = (event: KeyboardEventInit) => {
      if (event.key === 'Escape') {
        handleClose();
      }
    };

    window.addEventListener('keyup', handleKeyEvent);
  }, []);

  const handleClose = () => {
    setVisibility(false);
    fetchNui(INVENTORY_EVENTS.CLOSE);
  };

  return (
    <Fade in={visibility}>
      <div className="inventory-wrapper">
        <div className="inventory-container-wrapper">
          <div className="inventory-container" id="main">
            <div className="inventory-container-header">
              <h1>Player</h1>
              <div className="inventory-header-weight">100/250</div>
            </div>
          </div>
          <div className="inventory-options">
            <div className="inventory-options-container">
              <input
                className="option"
                type="number"
                id="move-amount"
                max="9999"
                min="0"
                placeholder="Amount"
              />
              <button className="option" id="use-btn">
                Use
              </button>
              <button className="option" id="close-btn" onClick={handleClose}>
                Close
              </button>
            </div>
          </div>
          <div className="inventory-container" id="secondary">
            <div className="inventory-container-header">
              <h1>Ground</h1>
              <div className="inventory-header-weight">50/1000</div>
            </div>
          </div>
        </div>
      </div>
    </Fade>
  );
}
