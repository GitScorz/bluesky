import './App.css';

import Hud from './hud/Hud';
import Balance from './balance/Balance';
import Interaction from './interaction/Interaction';
import Phone from './phone/Phone';
import Radio from './radio/Radio';

export default function App() {
  return (
    <div className="nui-wrapper">
      <Hud />
      <Balance />
      <Interaction />
      <Phone /> 
      <Radio />
    </div>
  );
}