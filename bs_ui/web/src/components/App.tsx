import './App.css';
import Hud from './hud/Hud';
import Balance from './balance/Balance';
import Interaction from './interaction/Interaction';
import Phone from './phone/Phone';
import Radio from './radio/Radio';
import { isEnvBrowser } from '../utils/misc';
import { ThemeProvider } from '@mui/material';
import Theme from './Theme';

export default function App() {
  return (
    <ThemeProvider theme={Theme}>
      <div className="nui-wrapper">
        <div style={{ 
          position: "absolute",
          visibility: isEnvBrowser() ? "visible" : "hidden", 
          backgroundColor: "rgb(144, 180, 212)", 
          width: "100%", 
          height: "100%",
        }}></div>
        <Hud />
        <Balance />
        <Interaction />
        <Phone /> 
        <Radio />
      </div>
    </ThemeProvider>
  );
}