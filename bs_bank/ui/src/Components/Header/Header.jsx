import React from 'react';
import { makeStyles } from '@material-ui/core';

const useStyles = makeStyles(theme => ({
  header: {
    marginTop: 36,
    height: 60,
    width: 180,
    margin: 'auto',

    '& img': {
      width: 36,
      borderRadius: 7,
      float: 'left',
    },

    '& h3': {
      fontWeight: '400',
      fontSize: 19,
      letterSpacing: 1.5,
      marginLeft: 0,
      paddingTop: 4,
    },
  },
}));

const Header = () => {

  const classes = useStyles();

  return (
    <div className={classes.header}>
      {/*<img src={bankIcon} alt="stfu"/>*/}
      <h3>Bank of React</h3>
    </div>
  );
};

export default Header;
