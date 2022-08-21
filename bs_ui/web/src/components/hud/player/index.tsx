import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import "./player.styles.css";
import {
  faHeart,
  faShieldHalved,
  faDroplet,
  faHeadset,
  faMicrophone,
  faBurger,
  faSkull,
} from "@fortawesome/free-solid-svg-icons";
import { useCallback, useMemo } from "react";
import { PlayerHudProps } from "../../../types/hud";
import { buildStyles, CircularProgressbar } from "react-circular-progressbar";
import { useRecoilValue } from "recoil";
import { statusState } from "../hooks/state";

export default function Player({
  voice,
  health,
  armor,
  hunger,
  thirst,
}: PlayerHudProps) {
  const talkingStatus = useRecoilValue(statusState.talkingStatus);
  const onRadio = useRecoilValue(statusState.onRadio);

  const foregroundRed = useCallback((value: number, defaultColor: string) => {
    return value > 30 ? defaultColor : "rgba(255, 0, 0, 255)";
  }, []);

  const backgroundRed = useCallback((value: number, defaultColor: string) => {
    return value > 30 ? defaultColor : "rgba(255, 0, 0, 0.4)";
  }, []);

  const voiceForeground = useCallback(
    (defaultColor: string) => {
      let color = defaultColor;

      if (talkingStatus.talking && !talkingStatus.usingRadio) {
        color = "rgba(255, 255, 0, 255)";
      } else if (talkingStatus.talking && talkingStatus.usingRadio) {
        color = "rgba(216, 66, 96, 255)";
      }

      return color;
    },
    [talkingStatus]
  );

  const voiceBackground = useCallback(
    (defaultColor: string) => {
      let color = defaultColor;

      if (talkingStatus.talking && !talkingStatus.usingRadio) {
        color = "rgba(255, 255, 0, 0.4)";
      } else if (talkingStatus.talking && talkingStatus.usingRadio) {
        color = "rgba(216, 66, 96, 0.4)";
      }

      return color;
    },
    [talkingStatus]
  );

  return useMemo(
    () => (
      <>
        <div className="hud-wrapper">
          <div className="circle" id="voice">
            <CircularProgressbar
              value={voice}
              maxValue={100}
              styles={buildStyles({
                trailColor: voiceBackground("rgba(255, 255, 255, 0.4)"),
                pathColor: voiceForeground("rgb(255, 255, 255)"),
                pathTransitionDuration: 0.5,
              })}
              strokeWidth={13}
            />
            <div className="circle-icon">
              <FontAwesomeIcon
                className="hud-icon"
                icon={onRadio ? faHeadset : faMicrophone}
              />
            </div>
          </div>
          <div className="circle" id="health">
            <CircularProgressbar
              value={health}
              maxValue={100}
              styles={buildStyles({
                trailColor: backgroundRed(health, "rgba(59, 160, 122, 0.4)"),
                pathColor: foregroundRed(health, "rgb(59, 160, 122)"),
                pathTransitionDuration: 2,
              })}
              strokeWidth={13}
            />
            <div className="circle-icon">
              <FontAwesomeIcon
                className="hud-icon"
                icon={health !== 0 ? faHeart : faSkull}
              />
            </div>
          </div>
          <div className="circle" id="armor">
            <CircularProgressbar
              value={armor}
              maxValue={100}
              styles={buildStyles({
                trailColor: backgroundRed(armor, "rgba(27, 101, 181, 0.4)"),
                pathColor: foregroundRed(armor, "rgb(27, 101, 181)"),
                pathTransitionDuration: 2,
              })}
              strokeWidth={13}
            />
            <div className="circle-icon">
              <FontAwesomeIcon className="hud-icon" icon={faShieldHalved} />
            </div>
          </div>
          <div className="circle" id="hunger">
            <CircularProgressbar
              value={hunger}
              maxValue={100}
              styles={buildStyles({
                trailColor: backgroundRed(hunger, "rgba(255, 118, 10, 0.4)"),
                pathColor: foregroundRed(hunger, "rgba(255, 118, 10)"),
                pathTransitionDuration: 2,
              })}
              strokeWidth={13}
            />
            <div className="circle-icon">
              <FontAwesomeIcon className="hud-icon" icon={faBurger} />
            </div>
          </div>
          <div className="circle" id="thirst">
            <CircularProgressbar
              value={thirst}
              maxValue={100}
              styles={buildStyles({
                trailColor: backgroundRed(thirst, "rgba(13, 121, 180, 0.4)"),
                pathColor: foregroundRed(thirst, "rgba(13, 121, 180)"),
                pathTransitionDuration: 2,
              })}
              strokeWidth={13}
            />
            <div className="circle-icon">
              <FontAwesomeIcon className="hud-icon" icon={faDroplet} />
            </div>
          </div>
        </div>
      </>
    ),
    [
      voice,
      health,
      armor,
      hunger,
      thirst,
      onRadio,
      voiceBackground,
      voiceForeground,
      backgroundRed,
      foregroundRed,
    ]
  );
}
