import React, { useState, useEffect } from 'react';
import { connect, useSelector } from 'react-redux';
import { library } from '@fortawesome/fontawesome-svg-core';
import { far } from '@fortawesome/pro-regular-svg-icons';
import { fas } from '@fortawesome/pro-solid-svg-icons';
import { fal } from '@fortawesome/pro-light-svg-icons';
import { fad } from '@fortawesome/pro-duotone-svg-icons';
import { fab } from '@fortawesome/free-brands-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Fade, makeStyles, Badge } from '@material-ui/core';
import LinearProgress from '@material-ui/core/LinearProgress';

const useStyles = makeStyles(theme => ({
  status: {
    position: 'absolute',
    bottom: '1%',
    right: 20,
    margin: 'auto',
    fontSize: 30,
    width: 'fit-content',
    maxWidth: '5%',
    minWidth: '5%',
    textAlign: 'center',
    filter: 'drop-shadow(0 0 2px #000000)',
    whiteSpace: 'nowrap',
    overflow: 'hidden',
    '& svg': {
      margin: -20,
    },
  },
  redColor: {
    color: '#c75050',
  },
  activeColor: {
    color: '#d8c14f',
  },
  status50: {
    color: '#d8c14f',
  },
  status25: {
    color: theme.palette.error.main,
  },
  status10Static: {
    color: theme.palette.error.main,
  },
  status0Static: {
    color: theme.palette.text.main,
    opacity: 0.25,
  },
  statIcon: {
    display: 'inline-block',
  },
  levelName: {
    marginTop: '0px',
    fontSize: '9px',
    lineHeight: '9px',
    paddingTop: '0px'
  },
  fuckingLevelName: {
    padding: 0,
    margin: 0
  }
}));

library.add(far, fab, fas, fal, fad );

export default connect()((props) => {
  const classes = useStyles();
  const hidden = useSelector(state => state.app.hidden);
  const currentlyTalking = useSelector(state => state.app.currentlyTalking);
  const currentlyRadio = useSelector(state => state.app.currentlyRadio);
  const currentlyCall = useSelector(state => state.app.currentlyCall);
  const currentRadioChannel = useSelector(state => state.app.currentRadioChannel);
  const currentRadioChannelName = useSelector(state => state.app.currentRadioChannelName);
  const currentCallChan = useSelector(state => state.app.currentCallChan);
  const currentRange = useSelector(state => state.app.currentRange);

  let icon;
  let style; 

  if(!currentlyTalking) {
    icon = <FontAwesomeIcon className={classes.redColor} icon="microphone-alt-slash" />
  } else {
    if(currentlyTalking && !currentlyRadio && !currentlyCall) {
      icon = <FontAwesomeIcon className={classes.activeColor} icon="microphone-alt" />
    } else if(currentlyTalking && currentlyRadio && !currentlyCall) {
      icon = <FontAwesomeIcon className={classes.activeColor} icon="walkie-talkie" />
    } else {
      icon = <FontAwesomeIcon className={classes.activeColor} icon="phone-volume" />
    }
  }

  const [progress, setProgress] = useState(0);
  let range = 0
  let levelName;
  let labelName;
  if (currentRange <= 0) { range = 0; levelName = 'None'; } else if (currentRange == 1) { range = 25; levelName = 'Whispering'; } else if (currentRange == 2) { range = 50; levelName = 'Normal'; } else { range = 100; levelName = 'Shouting';};

  if(currentlyTalking && currentlyRadio && !currentlyCall) {
    labelName = currentRadioChannelName
  } 
  else if(currentlyTalking && currentlyRadio && currentlyCall) {
    labelName = "On Call";
  }
  else {
    labelName = levelName;
  }

  return (<Fade in={!hidden}>
      <div className={classes.status}>
        {icon}
        <div className={classes.fuckingLevelName}>
        <span className={classes.levelName}>{labelName}</span>
        </div>
        <LinearProgress variant="determinate" value={range} />
      </div>
      </Fade>)
  ;
});
