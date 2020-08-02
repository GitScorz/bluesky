import React from 'react';
import { fade, makeStyles } from '@material-ui/core';

import AccountPanel from './AccountPanel';

const useStyles = makeStyles(theme => ({
  container: {
    width: '100%',
    height: '95%',
  },

  header: {
    width: '100%',
    height: '27.5%',
    margin: 0,

    '& > div:first-child': {
      marginBottom: '5%',
    },
  },

  headerItem: {
    width: '100%',
    height: '40%',

    '& div': {
      height: '100%',
      width: '17.5%',
      background: fade(theme.palette.success.main, 0.25),
      borderRadius: 5,
      float: 'left',

      '&.error': {
        background: fade(theme.palette.error.main, 0.25),

        '& .MuiSvgIcon-root': {
          color: fade(theme.palette.error.main, 0.75),
        },
      },

      '& .MuiSvgIcon-root': {
        color: fade(theme.palette.success.main, 0.75),
        display: 'block',
        height: '100%',
        width: '55%',
        margin: 'auto',
      },
    },

    '& p': {
      fontSize: 12,
      color: theme.palette.secondary.contrastText,
      marginLeft: '20%',
      marginBottom: 0,
      marginTop: '3%',
    },

    '& h2': {
      fontSize: 16,
      marginLeft: '20%',
      marginTop: '2%',
      fontWeight: 400,
      color: fade(theme.palette.success.main, 0.75),

      '&.error': {
        color: fade(theme.palette.error.main, 0.75),
      },
    },
  },

  content: {
    width: '100%',
    height: '71%',
    overflow: 'auto',
  },

  item: {
    width: '100%',
    height: '12.5%',
    marginBottom: 4,

    '& h3': { // Title
      color: theme.palette.secondary.contrastText,
      fontWeight: 500,
      fontSize: 16,
      marginBottom: 0,
      marginTop: 0,
    },

    '& h2': { // Amount
      fontWeight: 400,
      fontSize: 16,
      marginTop: -8,
      marginBottom: 0,
      textAlign: 'end',

      color: fade(theme.palette.success.main, 0.75),

      '&.error': {
        color: fade(theme.palette.error.main, 0.75),
      },
    },

    '& p': { // Time/Date
      color: fade(theme.palette.secondary.contrastText, 0.75),
      fontWeight: 400,
      marginBottom: 0,
      marginTop: -15,
      fontSize: 10,
    },
  },

  hr: {
    width: '100%',
    borderColor: 'rgba(200, 200, 200, 0.04)',
    borderWidth: 0.5,
    borderStyle: 'solid',
    marginTop: 8,
  },
}));

const AccountHistory = ({ acc }) => {

  const classes = useStyles();

  return (
    <AccountPanel
      width={300} height={280}
      title="History" desc="Transaction Logs"
    >
      <div className={classes.container}>
        {/*
        <div className={classes.header}>
         <div className={classes.headerItem}>
            <div>
              <AddRounded/>
            </div>

            <p>Income</p>
            <h2>${acc.History.filter(history => history.type == 1).reduce((total, { Amount }) => {
              return total + Amount;
            }, 0).toLocaleString('en-US', { minimumFractionDigits: 2 })}</h2>
          </div>
          <div className={classes.headerItem}>
            <div className="error">
              <RemoveRounded/>
            </div>

            <p>Spending</p>
            <h2 className="error">
              ${acc.History.filter(history => history.type == 0).reduce((total, { Amount }) => {
              return total + Amount;
            }, 0).toLocaleString('en-US', { minimumFractionDigits: 2 })}
            </h2>
          </div>
        </div>*/}

        <div className={classes.content}>
          {
            acc.History.map(history => (
              <div key={history.title + history.type + history.Amount + history.time + Math.random()}>
                <div className={classes.item}>
                  <h3>{history.Title}</h3>
                  <h2 className={history.type ? '' : 'error'}>
                    {history.type ? '+' : '-'} ${history.Amount.toLocaleString('en-US', { minimumFractionDigits: 2 })}
                  </h2>
                  <i><p>{history.Time}</p></i>
                </div>
                <hr className={classes.hr}/>
              </div>
            ))
          }
        </div>
      </div>
    </AccountPanel>
  );
};

export default AccountHistory;
