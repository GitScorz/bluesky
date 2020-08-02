import React, { useState } from 'react';
import { connect, useSelector } from 'react-redux';
import {
  makeStyles,
  Slide,
  Tooltip,
  TextField,
  Input,
  Button,
  InputLabel,
} from '@material-ui/core';
import Typography from '@material-ui/core/Typography';
import SignalCellularAltIcon from '@material-ui/icons/SignalCellularAlt';
import BatteryCharging90Icon from '@material-ui/icons/BatteryCharging90';
import Nui from '../../util/Nui';

import radioImg from '../../radio.png';

const useStyles = makeStyles(theme => ({
  wrapper: {
    height: 600,
    width: 350,
    position: 'absolute',
    bottom: '0%',
    right: '2%',
    overflow: 'hidden',
  },
  radioImg: {
    zIndex: 100,
    background: `transparent no-repeat center`,
    height: '100%',
    width: '100%',
    position: 'absolute',
    pointerEvents: 'none',
  },
  radio: {
    height: '100%',
    width: '100%',
    padding: '36px 77px',
    overflow: 'hidden',
  },
  screen: {
    zIndex: 101,
    width: '55.5%',
    height: '31.2%',
    position: 'absolute',
    top: 384,
    overflow: 'hidden',
  },
  volumeUp: {
    zIndex: 101,
    position: 'absolute',
    top: 210,
    left: 150,
    height: '5%',
    width: '5%',
    cursor: 'pointer',
  },
  volumeDown: {
    zIndex: 101,
    position: 'absolute',
    top: 210,
    left: 177,
    height: '5%',
    width: '5%',
    cursor: 'pointer',
  },
  power: {
    zIndex: 101,
    position: 'absolute',
    top: 233,
    left: 265,
    height: '7%',
    width: '25%',
    cursor: 'pointer',
  },
  signalIcon: {
    float: 'right',
    paddingRight: 5,
  },
  batteryIcon: {
    float: 'left',
  },
  radioChannelNumber: {
    textAlign: 'center',
    width: '100%',
    lineHeight: '25px',
    height: 25,
  },
  inputScreen: {
    position: 'absolute',
    top: 25,
    left: 0,
    height: '100%',
    width: '84%',
    padding: '15px',
  },
  frequencyInput: {
    width: '100%',
    textAlign: 'center',
  },
  fuckingButton: {
    marginTop: '5px',
    textAlign: 'center',
  },
})); 

const volumeUp = e => {
  console.log('vol up');
  Nui.send('volumeUp', {}).then((res) => {
    props.dispatch({ type: 'SET_VOLUME', payload: { volume: -5 }}); /* change to res */
  });
};

const volumeDown = e => {
  console.log('vol down');
  Nui.send('volumeDown', {}).then((res) => {
    props.dispatch({ type: 'SET_VOLUME', payload: { volume: -5 }}); /* change to res */
  });
};

const PowerButton = e => {
  Nui.send('power', {});
};

export default connect()(props => {
  const classes = useStyles();
  const hidden = useSelector(state => state.app.hidden);
  const inputPropsFreq = { min: 1, max: 999, style: {textAlign: 'center'} };
  const whatever = useSelector(state => state.app.frequency);
  const [freq, setFreq] = useState(whatever);
  const freqName = useSelector(state => state.app.frequencyName);

  const makeSureItsFuckingRight = e => {
    if (event.target.value === '' || /^\d+$/.test(event.target.value)) {
      setFreq(event.target.value < 1000 ? (event.target.value > 0 ? event.target.value : 1) : 999);
    }
  };

  const onsubmit = e => {
    e.preventDefault();
    Nui.send('setChannel', {
      freq
    });
  };

  const clearInput = e => {
    setFreq('');
    Nui.send('clearChannel', {});
  }

  return (
    <Slide direction="up" in={!hidden} mountOnEnter unmountOnExit>
      <div className={classes.wrapper}>
        <img className={classes.radioImg} src={radioImg} />
        <div className={classes.radio}>
          <Tooltip title="Volume Up" aria-label="volup" placement="top">
            <div className={classes.volumeUp} onClick={volumeUp}></div>
          </Tooltip>
          <Tooltip title="Volume Down" aria-label="voldown" placement="top">
            <div className={classes.volumeDown} onClick={volumeDown}></div>
          </Tooltip>
          <Tooltip title="Power" aria-label="power" placement="top">
            <div className={classes.power} onClick={PowerButton}></div>
          </Tooltip>
          <div className={classes.screen}>
            <div className={classes.radioChannelNumber}>
              <BatteryCharging90Icon className={classes.batteryIcon} />
              {freqName === '' ? 'Radio' : `${freqName}`}
              <SignalCellularAltIcon className={classes.signalIcon} />
            </div>

            <div className={classes.inputScreen}>
                <TextField
                  id="frequency"
                  type="text"
                  value={freq === '' ? '' : freq}
                  pattern="[0-9]"
                  inputProps={inputPropsFreq}
                  className={classes.frequencyInput}
                  onChange={makeSureItsFuckingRight}
                  label="Frequency"
                />
                <Button
                  fullWidth
                  color="primary"
                  className={classes.fuckingButton}
                  onClick={onsubmit}
                >
                  Change
                </Button>
                <Button
                  fullWidth
                  color="primary"
                  className={classes.fuckingButton}
                  onClick={clearInput}
                >
                  Clear Channel
                </Button>
            </div>
          </div>
        </div>
      </div>
    </Slide>
  );
});
