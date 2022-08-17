import { useRecoilState } from 'recoil';
import { inventoryState } from '../hooks/state';
import './inventory.styles.css';
import { Fade } from '@mui/material';
import { fetchNui } from '../../utils/fetchNui';
import { DragSource, INVENTORY_EVENTS } from '../../types/types';
import { useEffect } from 'react';
import Header from './components/header';
import Slots from './components/grid';
import ItemInfo from './components/iteminfo';
import { useDrop } from 'react-dnd';

export default function Inventory() {
  const [visibility, setVisibility] = useRecoilState(inventoryState.visibility);

  const [moveAmount, setMoveAmount] = useRecoilState(inventoryState.moveAmount);

  const [playerInventory] = useRecoilState(inventoryState.playerInventory);
  const [secondInventory] = useRecoilState(inventoryState.secondInventory);

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
    const amount = event.target.value;

    if (Number(amount) > 9999) {
      setMoveAmount('9999');
      return;
    }

    setMoveAmount(amount);
  };

  const playerSlots = {
    invItems: playerInventory.inventory,
    size: playerInventory.size,
    invType: playerInventory.invType,
    owner: playerInventory.owner,
  };

  const secondarySlots = {
    invItems: secondInventory.inventory,
    size: secondInventory.size,
    invType: secondInventory.invType,
    owner: secondInventory.owner,
  };

  const [, use] = useDrop(
    () => ({
      accept: 'SLOT',
      drop: (item: DragSource) => {
        fetchNui(INVENTORY_EVENTS.USE_ITEM, {
          owner: item.item.owner,
          slot: item.slot,
          invType: item.item.invType,
        });
      },
    }),
    [],
  );

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
              invType={playerInventory.invType}
            />
            <Slots {...playerSlots} />
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
            <button id="use-btn" ref={use}>
              Use
            </button>
            <button onClick={handleClose}>Close</button>
          </div>
          <div id="secondaryInv" className="inventory-box">
            <Header
              invName={secondInventory.name}
              weight={secondInventory.weight}
              maxWeight={secondInventory.maxWeight}
              invType={secondInventory.invType}
            />
            <Slots {...secondarySlots} />
          </div>
        </div>
      </div>
    </Fade>
  );
}
