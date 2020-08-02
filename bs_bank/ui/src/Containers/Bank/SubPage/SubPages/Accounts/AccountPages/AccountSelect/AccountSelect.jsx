import React from 'react';
import { makeStyles } from '@material-ui/core';
import { useSelector } from 'react-redux';

import AccountItem from './AccountItem';
import AccountCreate from './AccountCreate';

const useStyles = makeStyles(theme => ({
  accounts: {
    width: '80%',
    height: '100%',
    overflow: 'hidden',
  },

  title: {
    marginLeft: 24,
    color: theme.palette.primary.main,
    fontWeight: 500,
    paddingBottom: 0,
    marginBottom: 0,
  },

  hr: {
    width: '93.75%',
    borderColor: 'rgba(200, 200, 200, 0.04)',
    borderWidth: 0.5,
    borderStyle: 'solid',
    marginLeft: 24,
    marginTop: 6,
  },

  section: {
    display: 'flex',
    flexFlow: 'row wrap',
    alignContent: 'flex-start',
    width: '97.5%',
    height: '37.5%',
    overflow: 'auto',

    '& > div:nth-child(2n + 1)': {
      marginLeft: '12.5%',
    },
  },
}));

const AccountSelect = () => {

  const classes = useStyles();

  const accounts = useSelector(state => state.Accounts.list);

  return (
    <>
      <div className={classes.accounts}>
        <h2 className={classes.title}>Private Accounts</h2>
        <hr className={classes.hr}/>
        <div className={classes.section}>
          {
            accounts.filter(acc => acc.type === 0).map(account =>
              <AccountItem acc={account} key={account.AccountNumber}/>,
            )
          }
          <AccountCreate type={0}/>
        </div>

        <h2 className={classes.title}>Joint Accounts</h2>
        <hr className={classes.hr}/>
        <div className={classes.section}>
          {
            accounts.filter(acc => acc.type === 1).map(account =>
              <AccountItem acc={account} key={account.number}/>,
            )
          }
          <AccountCreate type={1}/>
        </div>

      </div>
    </>
  );
};

export default AccountSelect;
