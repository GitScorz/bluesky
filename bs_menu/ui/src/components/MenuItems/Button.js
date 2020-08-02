/* eslint-disable jsx-a11y/no-static-element-interactions */
/* eslint-disable jsx-a11y/click-events-have-key-events */
/* eslint-disable react/prop-types */
import React from 'react';
import { makeStyles } from '@material-ui/core';
import Nui from '../../util/Nui';

const useStyles = makeStyles(() => ({
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
  success: {
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
    marginBottom: 5,
    '&:hover:not(.disabled)': {
      background: '#38b58f59',
      border: '2px solid #38b58f',
    },
  },
}));

const Button = props => {
  const classes = useStyles();

  const onClick = () => {
    if (!props.data.options.disabled) {
      Nui.send('FrontEndSound', { sound: 'SELECT' });
      Nui.send('Selected', {
        id: props.data.id,
      });
    }
  };

  const cssClass = props.data.options.disabled
    ? `${(props.data.options.success ? classes.success : classes.div)} disabled`
    : (props.data.options.success ? classes.success : classes.div);
  const style = props.data.options.disabled ? { opacity: 0.5 } : {};

  return (
    <div className={cssClass} style={style} onClick={onClick}>
      {props.data.label}
    </div>
  );
};

export default Button;
