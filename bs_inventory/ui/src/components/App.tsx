import Inventory from './inventory';
import Notification from './notification';
import './App.css';
import { isEnvBrowser } from '../utils/misc';
import { useInventoryService } from './hooks/useInventoryService';
// import HoverSlot from './inventory/components/slots/hoverslot';

export default function App() {
  // Register every service you want here.
  useInventoryService();

  return (
    <>
      <div
        className="ui-wrapper"
        style={{
          position: 'absolute',
          visibility: isEnvBrowser() ? 'visible' : 'hidden',
          backgroundColor: 'rgb(144, 180, 212)',
          width: '100%',
          height: '100%',
        }}
      />
      <Inventory />
      {/* <HoverSlot /> */}
      <Notification />
    </>
  );
}
