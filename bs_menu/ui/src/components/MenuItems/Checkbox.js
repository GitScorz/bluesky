/* eslint-disable jsx-a11y/no-static-element-interactions */
/* eslint-disable jsx-a11y/click-events-have-key-events */
/* eslint-disable react/prop-types */
import React, { useState } from 'react';
import { makeStyles, Grid } from '@material-ui/core';
import { CheckBox, CheckBoxOutlineBlank } from '@material-ui/icons';
import Nui from '../../util/Nui';

const useStyles = makeStyles(() => ({
  div: {
    width: '100%',
    height: 42,
    fontSize: 13,
    fontWeight: 500,
    textDecoration: 'none',
    textShadow: 'none',
    whiteSpace: 'nowrap',
    display: 'inline-block',
    verticalAlign: 'middle',
    borderRadius: 3,
    transition: '0.1s all linear',
    userSelect: 'none',
    background: '#3e4148a3',
    border: '2px solid #3e4148',
    color: '#ffffff',
    marginBottom: 5,
    lineHeight: '42px',
    '&:hover': {
      background: '#3e414847',
      border: '2px solid #3e4148',
    },
  },
  left: {
    display: 'inline-block',
    width: '10%',
    marginTop: 3,
  },
  icon: {
    width: '0.75em',
    height: '100%',
    fontSize: '1.25rem',
  },
  right: {
    width: '90%',
    textAlign: 'center',
    float: 'right',
  },
}));

const Checkbox = props => {
  const classes = useStyles();
  const [selected, setSelected] = useState(props.data.selected);

  const onClick = () => {
    setSelected(!selected);
    Nui.send('FrontEndSound', { sound: 'SELECT' });
    Nui.send('Selected', {
      id: props.data.id,
      data: { selected: !selected },
    });
  };

  return (
    <div className={classes.div} onClick={onClick}>
      <Grid container>
        <Grid item xs={2}>
          {
            selected ?
              <CheckBox className={classes.icon} /> :
              <CheckBoxOutlineBlank className={classes.icon} />
          }
        </Grid>
        <Grid item xs={8}>
          <span>{props.data.label}</span>
        </Grid>
        <Grid item xs={2}></Grid>
      </Grid>
    </div>
  );
};

export default Checkbox;
