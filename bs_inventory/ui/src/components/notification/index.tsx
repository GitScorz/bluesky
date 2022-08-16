import Fade from '@mui/material/Fade';
import { useState } from 'react';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { INVENTORY_EVENTS, ItemNotification } from '../../types/types';
import { InjectDebugData } from '../../utils/debugData';
import './notification.styles.css';

const initialState = {
  id: '',
  label: '',
  text: '',
  quantity: 1,
};

export default function Notification() {
  const [visible, setVisible] = useState(false);
  const [itemData, setItemData] = useState<ItemNotification>(initialState);

  const setNotifyTimer = () => {
    setVisible(true);
    setTimeout(() => {
      setVisible(false);
    }, 1750);
  };

  useNuiEvent(INVENTORY_EVENTS.SHOW_NOTIFICATION, (data: ItemNotification) => {
    setItemData(data);
    setNotifyTimer();
  });

  return (
    <Fade in={visible}>
      <div className="notify-wrapper">
        <div className="notify-body">
          <div className="notify-header">
            {itemData.text} {itemData.quantity}x
          </div>
          <div className="item-name">{itemData.label}</div>
          <img
            src={`images/${itemData.id}.png`}
            alt={itemData.label}
            className="item-image"
          />
        </div>
      </div>
    </Fade>
  );
}

InjectDebugData<ItemNotification>([
  {
    action: INVENTORY_EVENTS.SHOW_NOTIFICATION,
    data: {
      id: 'mobilephone',
      label: 'Mobile Phone',
      text: 'Received',
      quantity: 1,
    },
  },
]);
