import React from 'react';
import { makeStyles } from '@material-ui/core';
import { useSelector } from 'react-redux';

import AccountPages from './SubPages/Accounts/AccountPages/AccountPages';
import CardPages from './SubPages/Cards/CardPages';
import LoansPages from './SubPages/Loans/LoansPages';


const useStyles = makeStyles(theme => ({
  container: {
    position: 'absolute',
    top: '0%',
    left: '20%',
    width: '100%',
    height: '100%',
    overflow: 'auto',
  },
}));

const SubPage = () => {

  const classes = useStyles();
  const currSubPage = useSelector(state => state.Bank.currentSubPage);

  return (
    <div className={classes.container}>
      {
        (() => {
          switch (currSubPage) {
            case 0: {
              return <AccountPages/>;
            }
            case 1: {
              return <CardPages/>;
            }
            case 2: {
              return <LoansPages/>;
            }

            default:
              return null;
          }
        })()
      }
    </div>
  );
};

export default SubPage;
