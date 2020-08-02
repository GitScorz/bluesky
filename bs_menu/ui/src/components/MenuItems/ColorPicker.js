/* eslint-disable react/prop-types */
import React, { useState } from 'react';
import { makeStyles, Fade } from '@material-ui/core';
import { ChromePicker } from 'react-color';
import Nui from '../../util/Nui';

const useStyles = makeStyles(theme => ({
  div: {
    width: '100%',
    height: 42,
    fontSize: 13,
    fontWeight: 500,
    textAlign: 'center',
    textDecoration: 'none',
    textShadow: 'none',
    whiteSpace: 'nowrap',
    display: 'inline-block',
    verticalAlign: 'middle',
    padding: '10px 20px',
    borderRadius: 3,
    border: '1px solid rgba(0,0,0,0.1)',
    transition: '0.1s all linear',
    userSelect: 'none',
    background: '#3e4148a3',
    border: '2px solid #3e4148',
    color: '#ffffff',
    marginBottom: 5,
    '&:hover:not(.disabled)': {
      background: '#3e414847',
      border: '2px solid #3e4148',
    },
  },
  popover: {
    width: '100%',
    minHeight: 84,
    zIndex: 999,
    position: 'absolute',
    left: 0,
  },
  cover: {
    position: 'fixed',
    top: '0px',
    right: '0px',
    bottom: '0px',
    left: '0px',
    zIndex: -1,
    background: 'rgba(0, 0, 0, 0.5)',
  },
  save: {
    width: '100%',
    height: 42,
    fontSize: 13,
    fontWeight: 500,
    textAlign: 'center',
    textDecoration: 'none',
    textShadow: 'none',
    whiteSpace: 'nowrap',
    display: 'inline-block',
    verticalAlign: 'middle',
    padding: '10px 20px',
    borderRadius: 3,
    transition: '0.1s all linear',
    userSelect: 'none',
    background: '#38b58fab',
    border: '2px solid #38b58f',
    color: '#ffffff',
    marginTop: 5,
    '&:hover': {
      background: '#38b58f59',
      border: '2px solid #38b58f',
    },
  },
  picker: {
    background: `${theme.palette.secondary.dark} !important`,
    boxShadow: 'none !important',
    color: theme.palette.text.dark,
  },
  wrapper: {
    '&::before': {
      content: '" "',
      background: theme.palette.secondary.dark,
      height: 25,
      position: 'absolute',
      transform: 'rotate(-1deg)',
      zIndex: -1,
      width: '100%',
      margin: '0 auto',
      left: 0,
      right: 0,
      marginTop: -25,
      boxShadow: '0 5px 15px #000000',
    },
    padding: 10,
    background: theme.palette.secondary.dark,
    zIndex: 999,
    boxShadow: '0 15px 15px #000000',
    left: 0,
    color: theme.palette.text.dark,
  },
}));

const ColorPicker = props => {
  const classes = useStyles();
  const [showPicker, setShowPicker] = useState(false);
  const [currColor, setCurrColor] = useState(props.data.options.current);
  const [tColor, setTColor] = useState(currColor);

  const onClick = () => {
    if (!props.data.options.disabled) {
      setShowPicker(!showPicker);
    }
  };

  const onChange = (color, event) => {
    if (!props.data.options.disabled) {
      setTColor(color.rgb);
    }
  };

  const onSave = () => {
    if (!props.data.options.disabled) {
      setCurrColor(tColor);
      Nui.send('Selected', {
        id: props.data.id,
        data: { color: tColor },
      });
      onClick();
    }
  };

  const cssClass = props.data.options.disabled
    ? `${classes.div} disabled`
    : classes.div;
  const style = props.data.options.disabled
    ? {
      opacity: 0.5,
      background: `rgb(${currColor.r}, ${currColor.g}, ${currColor.b}`,
      }
    : { background: `rgb(${currColor.r}, ${currColor.g}, ${currColor.b}` };

  return (
    <div>
      <div className={cssClass} style={style} onClick={onClick}>
        <span style={{ textShadow: '2px 2px #000' }}>
          Select Color : rgb({currColor.r}, {currColor.g}, {currColor.b})
        </span>
      </div>
      <Fade in={showPicker}>
        <div className={classes.popover}>
          <div className={classes.cover} onClick={onClick} />
          <div className={classes.wrapper}>
            <ChromePicker
              color={tColor}
              disableAlpha
              onChange={onChange}
              width="100%"
              className={classes.picker}
            />
            <div className={classes.save} onClick={onSave}>
              Save
            </div>
          </div>
        </div>
      </Fade>
    </div>
  );
};

export default ColorPicker;
