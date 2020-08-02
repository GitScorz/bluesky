import React from 'react';
import Nui from '../../util/Nui';
import { makeStyles, Grid } from '@material-ui/core';

const useStyles = makeStyles(theme => ({
  div: {
    width: "100%",
    height: 42,
    fontSize: 13,
    fontWeight: 500,
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
    lineHeight: 'normal',
    '&:hover': {
      background: '#3e414847',
      border: '2px solid #3e4148',
    }
  },
  left: {
      display: 'inline-block',
      width: '50%',
      textAlign: 'left',
      paddingLeft: 10
  },
  right: {
      display: 'inline-block',
      width: '50%',
      textAlign: 'right',
      paddingRight: 10
  }
}));

const Button = (props) => {
  const classes = useStyles();

  const onClick = () => {
    Nui.send('FrontEndSound', {sound: 'SELECT'});
    Nui.send('Selected', {
        id: props.data.id
    });
  };

  return (
    <div className={classes.div} onClick={onClick}>
      <Grid container>
          <Grid item xs={2}>
            {props.data.options.secondaryLabel}
          </Grid>
          <Grid item xs={8}>
            {props.data.label}
          </Grid>
          <Grid item xs={2}></Grid>
      </Grid>
    </div>
  );
}

export default Button;