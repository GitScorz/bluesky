/* eslint-disable react/prop-types */
/* eslint-disable global-require */
/* eslint-disable react/no-danger */
import React, { useState, useEffect } from 'react';
import { useSelector } from 'react-redux';
import { makeStyles, Fade } from '@material-ui/core';
import ReactHtmlParser from 'react-html-parser';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import {
  faExclamationTriangle as SeatBelt,
  faTachometerAlt as Cruise,
  faGasPump as Fuel,
} from '@fortawesome/free-solid-svg-icons';

const useStyles = makeStyles(theme => ({
  wrapper: {
    position: 'absolute',
    bottom: '5.5%',
    left: 0,
    right: 0,
    margin: 'auto',
    width: 'fit-content',
    filter: 'drop-shadow(0 0 2px #000000)',
    fontSize: 30,
    color: theme.palette.text.main,
    textAlign: 'center',
  },
  speed: {},
  speedText: {
    fontSize: 50,
    color: theme.palette.primary.main,
    display: 'inline-block',
    width: 98,
  },
  speedTextOff: {
    fontSize: 50,
    color: theme.palette.error.main,
    display: 'inline-block',
    width: 98,
  },
  fillerZero: {
    color: theme.palette.text.main,
  },
  speedMeasure: {
    fontSize: 25,
    color: theme.palette.text.dark,
  },
  icons: {
    display: 'grid',
    gridGap: 0,
    gridTemplateColumns: '30% 30% 30%',
    justifyContent: 'center',
  },
  seatbeltIcon: {
    margin: '0 15px',
    fontSize: 25,
    color: theme.palette.error.main,
    animation: '$flash linear 1s infinite',
  },
  cruiseIcon: {
    margin: '0 15px',
    fontSize: 25,
    color: theme.palette.error.dark,
  },
  fuel100: {
    margin: '0 15px',
    fontSize: 25,
    color: theme.palette.error.dark,
  },
  fuel75: {
    margin: '0 15px',
    fontSize: 25,
    color: theme.palette.error.light,
  },
  fuel50: {
    margin: '0 15px',
    fontSize: 25,
    color: '#d8c14f',
  },
  fuel25: {
    margin: '0 15px',
    fontSize: 25,
    color: theme.palette.error.main,
  },
  fuel10: {
    margin: '0 15px',
    fontSize: 25,
    color: theme.palette.error.main,
    animation: '$flash linear 1s infinite',
  },
  fuel0: {
    margin: '0 15px',
    fontSize: 25,
    color: theme.palette.text.main,
    animation: '$flash linear 0.5s infinite',
  },
  '@keyframes flash': {
    '0%': {
      opacity: 1,
    },
    '50%': {
      opacity: 0.1,
    },
    '100%': {
      opacity: 1,
    },
  },
}));

export default () => {
  const classes = useStyles();
  const showing = useSelector(state => state.vehicle.showing);
  const ignition = useSelector(state => state.vehicle.ignition);
  const speed = useSelector(state => state.vehicle.speed);
  const speedMeasure = useSelector(state => state.vehicle.speedMeasure);
  const seatbelt = useSelector(state => state.vehicle.seatbelt);
  const seatbeltHide = useSelector(state => state.vehicle.seatbeltHide);
  const cruise = useSelector(state => state.vehicle.cruise);
  const fuel = useSelector(state => state.vehicle.fuel);
  const fuelHide = useSelector(state => state.vehicle.fuelHide);
  const [fuelCss, setFuelCss] = useState(classes.fuelDanger);
  const [speedStr, setSpeedStr] = useState(speed.toString());

  useEffect(() => {
    if (fuel <= 0) {
      setFuelCss(classes.fuel0);
    } else if (fuel <= 75 && fuel > 50) {
      setFuelCss(classes.fuel75);
    } else if (fuel <= 50 && fuel > 25) {
      setFuelCss(classes.fuel50);
    } else if (fuel <= 25 && fuel > 10) {
      setFuelCss(classes.fuel25);
    } else if (fuel <= 10 && fuel > 0) {
      setFuelCss(classes.fuel10);
    } else {
      setFuelCss(classes.fuel100);
    }
  }, [fuel]);

  useEffect(() => {
    if (speed === 0) {
      setSpeedStr(`<span class=${classes.fillerZero}>000</span>`);
    } else if (speed < 10) {
      setSpeedStr(
        `<span class=${classes.fillerZero}>00</span>${speed.toString()}`,
      );
    } else if (speed < 100) {
      setSpeedStr(
        `<span class=${classes.fillerZero}>0</span>${speed.toString()}`,
      );
    } else {
      setSpeedStr(speed.toString());
    }
  }, [speed]);

  return (
    <Fade in={showing}>
      <div className={classes.wrapper}>
        <Fade in={ignition}>
          <div className={classes.icons}>
            <Fade in={!seatbelt && !seatbeltHide}>
              <FontAwesomeIcon
                className={classes.seatbeltIcon}
                style={{ gridColumn: 1 }}
                icon={SeatBelt}
              />
            </Fade>
            <Fade in={showing}>
              <FontAwesomeIcon
                className={fuelCss}
                style={{ gridColumn: 2 }}
                icon={Fuel}
              />
            </Fade>
            <Fade in={cruise}>
              <FontAwesomeIcon
                className={classes.cruiseIcon}
                style={{ gridColumn: 3 }}
                icon={Cruise}
              />
            </Fade>
          </div>
        </Fade>
        <div className={classes.speed}>
          {ignition ? (
            <div>
              <span className={classes.speedText}>
                {ReactHtmlParser(speedStr)}
              </span>
              <span className={classes.speedMeasure}>{speedMeasure}</span>
            </div>
          ) : (
            <span className={classes.speedTextOff}>OFF</span>
          )}
        </div>
      </div>
    </Fade>
  );
};
