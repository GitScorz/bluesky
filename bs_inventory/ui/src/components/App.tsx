import './App.css';
import Inventory from './inventory';
import { useInventoryService } from './hooks/useInventoryService';
import { isEnvBrowser } from '../utils/misc';

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
    </>
  );
}
