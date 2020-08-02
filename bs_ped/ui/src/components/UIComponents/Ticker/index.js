/* eslint-disable no-console */
/* eslint-disable jsx-a11y/no-static-element-interactions */
/* eslint-disable jsx-a11y/click-events-have-key-events */
/* eslint-disable react/prop-types */
import React from 'react';
import { connect } from 'react-redux';
import { makeStyles, TextField } from '@material-ui/core';

import { ArrowBackIos, ArrowForwardIos } from '@material-ui/icons';
import Nui from '../../../util/Nui';

const useStyles = makeStyles(theme => ({
  div: {
    width: '100%',
    fontSize: 13,
    fontWeight: 500,
    textAlign: 'center',
    textDecoration: 'none',
    textShadow: 'none',
    whiteSpace: 'nowrap',
    display: 'inline-block',
    verticalAlign: 'middle',
    borderRadius: 3,
    transition: '0.1s all linear',
    userSelect: 'none',
    color: '#ffffff',
    marginBottom: 5,
    lineHeight: '38px',
  },
  slider: {
    display: 'block',
    position: 'relative',
    top: '25%',
  },
  action: {
    height: 80,
    lineHeight: '100px',
    '&:hover': {
      filter: 'brightness(0.6)',
      transition: 'filter ease-in 0.15s',
    },
  },
  actionDisabled: {
    height: 80,
    lineHeight: '100px',
  },
  textField: {
    width: 25,
    '& input': {
      textAlign: 'center',
      color: theme.palette.primary.main,
    },
    '& input::-webkit-clear-button, & input::-webkit-outer-spin-button, & input::-webkit-inner-spin-button': {
      display: 'none',
    },
  },
  wrapper: {
    display: 'grid',
    gridGap: 0,
    gridTemplateColumns: '20% 60% 20%',
    gridTemplateRows: '40px 40px',
  },
}));

export default connect()(props => {
  const classes = useStyles();

  const onLeft = () => {
    if (props.disabled) return;

    Nui.send('FrontEndSound', { sound: 'UPDOWN' });
    props.dispatch(props.event(props.current - 1 < 0 ? props.max : props.current - 1, props.data));
  };

  const onRight = () => {
    if (props.disabled) return;

    Nui.send('FrontEndSound', { sound: 'UPDOWN' });
    props.dispatch(props.event(props.current + 1 > props.max ? 0 : props.current + 1, props.data));
  };

  const updateIndex = event => {
    try {
      let v = parseInt(event.target.value, 10);

      if (!props.disabled) {
        if (event.target.value > props.max) {
          v = props.max;
        } else if (event.target.value < props.min) {
          v = props.min;
        }
        Nui.send('FrontEndSound', { sound: 'UPDOWN' });
        props.dispatch(props.event(v, props.data));
      }
    } catch (err) {
      console.log(err);
    }
  };


  const cssClass = props.disabled
    ? `${classes.div} disabled`
    : classes.div;
  const style = props.disabled ? { opacity: 0.5 } : {};

  return (
    <div className={cssClass} style={style}>
      <div className={classes.wrapper}>
        <div style={{ gridColumn: 2, gridRow: 1 }}>{props.label}</div>
        <div
          className={
            props.disabled || props.current === 0
              ? classes.actionDisabled
              : classes.action
          }
          onClick={onLeft}
          style={{ gridColumn: 1, gridRow: '1 / 2' }}
        >
          <ArrowBackIos/>
        </div>
        <div style={{ gridColumn: 2, gridRow: 2 }}>
          <TextField
            value={props.current}
            className={classes.textField}
            onChange={updateIndex}
            disabled={props.disabled}
            type="number"
            pattern="[0-9]*"
            inputProps={{
              min: props.min,
              max: props.max,
              step: 1,
            }}
          />{' '}
          / {props.max}
        </div>
        <div
          className={
            props.disabled || props.current === props.max
              ? classes.actionDisabled
              : classes.action
          }
          onClick={onRight}
          style={{ gridColumn: 3, gridRow: '1 / 2' }}
        >
          <ArrowForwardIos/>
        </div>
      </div>
    </div>
  );
});
