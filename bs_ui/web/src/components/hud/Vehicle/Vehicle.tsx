import { faGasPump, faUserSlash } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { CircularProgressbar } from 'react-circular-progressbar';
import './Vehicle.css';

export default function Vehicle(props: UI.Vehicle.HudProps) {
  const { fuel, seatbelt, speed } = props;

  const calcFuelColor = (value: number) => {
    if (value < 30) {
      return '#ff0000';
    }

    return "#fff";
  }

  return (
    <div className="hud-vehicle">
      <div className="hud-vehicle-speedometer">
        <CircularProgressbar
          value={speed}
          maxValue={300}
          circleRatio={0.65}
          styles={{
            trail: {
              transform: "rotate(-140deg)",
              transformOrigin: "center center",
              stroke: "rgba(255, 255, 255, 0.4)",
            },
            path: {
              transform: "rotate(-140deg)",
              transformOrigin: "center center",
              stroke: "#fff",
            },
          }}
          strokeWidth={10}
        />
        <div className="speedometer-text">
          <span id="speed-text">{speed}</span>
          <span id="metric-text">mph</span>
        </div>
      </div>

      <div className="hud-vehicle-fuel">
        <CircularProgressbar
          value={fuel}
          maxValue={100}
          circleRatio={0.65}
          styles={{
            trail: {
              transform: "rotate(-120deg)",
              transformOrigin: "center center",
              stroke: "rgba(255, 255, 255, 0.4)",
            },
            path: {
              transform: "rotate(-120deg)",
              transformOrigin: "center center",
              stroke: calcFuelColor(fuel),
            },
          }}
          strokeWidth={10}
        />
        <div className="fuel-icon">
          <FontAwesomeIcon icon={faGasPump} />
        </div>

      </div>

      {!seatbelt && (
        <div className="hud-vehicle-seatbelt">
          <FontAwesomeIcon icon={faUserSlash} />
        </div> 
      )}
    </div>
  )
}
