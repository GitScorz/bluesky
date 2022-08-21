import { Fade } from "@mui/material";
import { useMemo } from "react";
import { useRecoilValue } from "recoil";
import { statusState, vehicleState } from "./hooks/state";
import { useHudService } from "./hooks/useHudService";
import Player from "./player";
import Vehicle from "./vehicle";

export default function Hud() {
  useHudService();

  const statusVisible = useRecoilValue(statusState.visibility);
  const status = useRecoilValue(statusState.status);

  const vehicleVisible = useRecoilValue(vehicleState.visibility);
  const vehicle = useRecoilValue(vehicleState.vehicle);

  return useMemo(
    () => (
      <>
        <Fade timeout={{ enter: 200, exit: 200 }} in={statusVisible}>
          <div className="hud-container">
            <Player {...status} />
          </div>
        </Fade>
        <Fade timeout={{ enter: 200, exit: 200 }} in={vehicleVisible}>
          <div className="vehicle-container">
            <Vehicle {...vehicle} />
          </div>
        </Fade>
      </>
    ),
    [statusVisible, status, vehicleVisible, vehicle]
  );
}
