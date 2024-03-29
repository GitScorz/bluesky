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
    background: '#3aaaf980',
    border: '2px solid #3aaaf9',
    color: '#ffffff',
    marginBottom: 5,
    '&:hover': {
      background: '#3aaaf92e',
      border: '2px solid #3aaaf9',
    },
  },
}));

const SubMenu = props => {
  const classes = useStyles();
  const onClick = () => {
    if (!props.data.options.disabled) {
      Nui.send('FrontEndSound', { sound: 'SELECT' });
      Nui.send('MenuOpen', {
        id: props.data.id,
      });
    }
  };

  return (
    <div className={classes.div} onClick={onClick}>
      {props.data.label}
    </div>
  );
};

export default SubMenu;
