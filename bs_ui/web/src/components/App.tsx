import './App.css';

import Hud from './hud/Hud';
import Balance from './balance/Balance';
import Action from './action/Action';
import Phone from './phone/Phone';
import Radio from './radio/Radio';

export default function App() {
  return (
    <div className="nui-wrapper">
      <Hud />
      <Balance />
      <Action />
      <Phone /> 
      <Radio />
    </div>
  );
}