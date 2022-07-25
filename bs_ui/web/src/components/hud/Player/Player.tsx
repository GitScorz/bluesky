import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { CircularProgress } from '@mui/material'
import { Box } from '@mui/system'
import './Player.css'
import { faHeart, faShieldHalved, faBurger, faDroplet, faMicrophone } from '@fortawesome/free-solid-svg-icons';
import { SizeProp } from '@fortawesome/fontawesome-svg-core';

export default function Player(props: UI.Status.HudProps) {
  const thickSize = 6.5;
  const size = 53;
  const iconSize: SizeProp = "lg";

  return (
    <div className="hud-player">
      <Box sx={{ position: "relative", display: "inline-flex" }}>
        <CircularProgress variant="determinate" value={props.voice} thickness={thickSize} size={size} className="foreground" sx={{ color: "rgba(255,255,255,255)" }} />
        <CircularProgress variant="determinate" value={100} thickness={thickSize} size={size} className="background" sx={{ color: "rgba(255,255,255,0.5)" }} />
        <FontAwesomeIcon className="hud-icon" icon={faMicrophone} size={iconSize} />
      </Box>

      <Box sx={{ position: "relative", display: "inline-flex" }}>
        <CircularProgress variant="determinate" value={props.health} thickness={thickSize} size={size} className="foreground" sx={{ color: "rgba(59,160,122,255)" }} />
        <CircularProgress variant="determinate" value={100} thickness={thickSize} size={size} className="background" sx={{ color: "rgba(59,160,122,0.5)" }} />
        <FontAwesomeIcon className="hud-icon" icon={faHeart} size={iconSize} />
      </Box>

      <Box sx={{ position: "relative", display: "inline-flex" }}>
        <CircularProgress variant="determinate" value={props.armor} thickness={thickSize} size={size} className="foreground" sx={{ color: "rgba(27,101,181,255)" }} />
        <CircularProgress variant="determinate" value={100} thickness={thickSize} size={size} className="background" sx={{ color: "rgba(27,101,181,0.5)" }} />
        <FontAwesomeIcon className="hud-icon" icon={faShieldHalved} size={iconSize} />
      </Box>

      <Box sx={{ position: "relative", display: "inline-flex" }}>
        <CircularProgress variant="determinate" value={props.hunger} thickness={thickSize} size={size} className="foreground" sx={{ color: "rgba(255,118,10,255)" }} />
        <CircularProgress variant="determinate" value={100} thickness={thickSize} size={size} className="background" sx={{ color: "rgba(255,118,10,0.5)" }} />
        <FontAwesomeIcon className="hud-icon" icon={faBurger} size={iconSize} />
      </Box>

      <Box sx={{ position: "relative", display: "inline-flex" }}>
        <CircularProgress variant="determinate" value={props.thirst} thickness={thickSize} size={size} className="foreground" sx={{ color: "rgba(13,121,180,255)" }} />
        <CircularProgress variant="determinate" value={100} thickness={thickSize} size={size} className="background" sx={{ color: "rgba(13,121,180,0.5)" }} />
        <FontAwesomeIcon className="hud-icon" icon={faDroplet} size={iconSize} />
      </Box>
    </div>
  )
}