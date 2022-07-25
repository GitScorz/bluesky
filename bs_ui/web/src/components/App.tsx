import React from 'react';
import './App.css'
import { debugData } from "../utils/debugData";

import Hud from './hud/Hud';
import Balance from './balance/Balance';
import Phone from './phone/Phone';
import Radio from './radio/Radio';

// This will set the NUI to visible if we are developing in browser
debugData([
  {
    action: 'setVisible',
    data: true,
  }
]);

const App: React.FC = () => {
  return (
    <div className="nui-wrapper">
      <Hud />
      <Balance />
      <Phone /> 
      <Radio />
    </div>
  );
}

export default App;
