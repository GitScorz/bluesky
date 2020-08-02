import React, { Fragment, useEffect, useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/core';

import { Loader } from '../../components/UIComponents';
import Creator from '../Creator';
import Shop from '../Shop/Shop';

const useStyles = makeStyles(theme => ({
  wrapper: {
    '&::before': {
      content: '" "',
      background: theme.palette.secondary.main,
      height: 25,
      position: 'absolute',
      transform: 'rotate(1deg)',
      zIndex: -1,
      width: '100%',
      margin: '0 auto',
      left: 0,
      right: 0,
      marginTop: -25,
    },
    background: theme.palette.secondary.main,
    maxHeight: 800,
    width: '35%',
    position: 'absolute',
    right: '1%',
    top: 0,
    bottom: 0,
    margin: 'auto',
    textAlign: 'center',
    fontSize: 30,
    color: theme.palette.text.main,
    zIndex: 1000,
    padding: 20,
  },
}));

export default connect()((props) => {
  const classes = useStyles();
  const hidden = useSelector(state => state.app.hidden);
  const state = useSelector(state => state.app.state);
  const loading = useSelector(state => state.app.loading);
  const [display, setDisplay] = useState(<Fragment/>);

  useEffect(() => {
    switch (state) {
      case 'CREATOR':
        setDisplay(<Creator/>);
        break;
      case 'SHOP':
        setDisplay(<Shop/>);
        break;
      default:
        setDisplay(<Fragment/>);
        break;
    }
  }, [state]);

  return (
    <div className="App" hidden={hidden}>
      <div className={classes.wrapper}>{loading ? <Loader/> : display}</div>
    </div>
  );
});
