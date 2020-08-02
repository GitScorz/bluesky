import React, { useState } from 'react';
import { makeStyles } from '@material-ui/core';
import { PeopleAlt, Person } from '@material-ui/icons';
import { store } from '../../../../../../../Index';
import Button from '@material-ui/core/Button';

const useStyles = makeStyles(theme => ({
  account: {
    width: '35%',
    height: '70%',
    marginTop: '5%',
    marginLeft: '5%',
    background: theme.palette.secondary.main,
    willChange: 'background',
    transition: 'background 400ms',
    borderRadius: 5,
    boxShadow: '0px 0px 12px -2px rgba(0,0,0,0.3)',

    '&:hover': {
      cursor: 'pointer',
      background: 'rgba(255, 255, 255, 0.01)',
    },
  },

  info: {
    marginLeft: '5%',
    width: '90%',
    height: '80%',

    '& h3': {
      color: theme.palette.primary.main,
      fontWeight: 400,
      fontSize: 19,
      marginBottom: 0,
    },

    '& p': {
      fontSize: 12,
      fontWeight: 100,
      marginTop: 3,
      color: theme.palette.secondary.contrastText,
    },

    '& hr': {
      width: '100%',
      borderColor: 'rgba(200, 200, 200, 0.04)',
      borderWidth: 0.5,
      borderStyle: 'solid',
      marginTop: 3,
    },

    '& h2': {
      fontWeight: 400,
      color: theme.palette.success.dark,
      marginTop: 24,
    },
  },

  backIcon: {
    color: 'rgba(255, 255, 255, 0.0075)',
    position: 'absolute',
    top: -80,
    fontSize: 100,
  },
  cancelButton: {
    position: 'absolute',
    marginLeft: '5%',
    bottom: '5%',
    color: theme.palette.error.dark,
  },
}));

const AccountItem = ({ acc }) => {

  const classes = useStyles();

  const handleClick = () => store.dispatch({ type: 'ACCOUNTS_SELECTED', payload: acc });

  return (
    <div className={classes.account} onClick={handleClick}>
      <div className={classes.info}>
        <h3>{acc.Name}</h3>
        <p>{acc.AccountNumber}</p>
        <hr/>
        <h2>${acc.Amount.toLocaleString('en-US', { minimumFractionDigits: 2 })}</h2>
      </div>

      <div style={{ position: 'relative' }}>
        {
          acc.type ? (
            <PeopleAlt className={classes.backIcon} style={{ right: 8 }}/>
          ) : (
            <Person className={classes.backIcon} style={{ right: 0 }}/>
          )
        }
      </div>
    </div>
  );
};

export { useStyles as AccountItemStyle };
export default AccountItem;
