import "./App.css";
import Hud from "./hud";
import Balance from "./balance";
import Interaction from "./interaction";
import Phone from "./phone";
import Radio from "./radio";
import { isEnvBrowser } from "../utils/misc";
import { ThemeProvider } from "@mui/material";
import Theme from "./Theme";

export default function App() {
  return (
    <ThemeProvider theme={Theme}>
      <div className="nui-wrapper">
        <div
          style={{
            position: "absolute",
            visibility: isEnvBrowser() ? "visible" : "hidden",
            backgroundColor: "rgb(144, 180, 212)",
            width: "100%",
            height: "100%",
          }}
        />
        <Hud />
        <Balance />
        <Interaction />
        <Phone />
        <Radio />
      </div>
    </ThemeProvider>
  );
}
