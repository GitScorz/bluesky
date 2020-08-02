import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/core';
import { ArrowBack } from '@material-ui/icons';
import Masonry from 'react-masonry-css';

import { store } from '../../../../../../../Index';
import AccountInfo from './AccountInfo';
import AccountMoneyActions from './AccountMoneyActions';
import AccountHistory from './AccountHistory';

const useStyles = makeStyles(theme => ({
  container: {
    width: '75%',
    height: '95%',
    marginLeft: '2.1%',
    marginTop: '1.25%',
    //background: "#F00",
  },

  hr: {
    width: '100%',
    borderColor: 'rgba(200, 200, 200, 0.04)',
    borderWidth: 0.5,
    borderStyle: 'solid',
    marginTop: 6,
  },

  header: {
    height: '5%',
    marginTop: 12 * 1.375,

    '& h2': {
      color: theme.palette.primary.main,
      fontWeight: 500,
      width: '90%',
      height: '100%',
      paddingBottom: 0,
      marginBottom: 0,
      marginTop: 0,
      float: 'left',
    },

    '& div': {
      width: '10%',
      marginLeft: '90%',
      height: '5.25%',
      fontSize: 18,

      '& svg': {
        float: 'left',
        color: theme.palette.primary.main,
        paddingTop: 2,
      },

      '& p': {
        margin: 0,
        paddingLeft: 24 * 1.2,
        transition: 'color 300ms',
      },

      '&:hover': {
        cursor: 'pointer',

        '& > p': {
          color: theme.palette.primary.main,
        },
      },
    },
  },

  content: {
    width: '100%',
    height: '93.75%',
    overflow: 'auto',
  },

  masonry: {
    display: 'flex',
    width: 'auto',
    marginLeft: -30,

    '& .masonry-column': {
      paddingLeft: 30,
    },
  },
}));

const AccountManage = () => {

  const classes = useStyles();

  const acc = useSelector(state => state.Accounts.selectedAccount);
  const page = useSelector(state => state.App.page);

  const goBack = () => store.dispatch({ type: 'ACCOUNTS_SET_PAGE', payload: 0 });

  return (
    <div className={classes.container}>

      <div className={classes.header}>
        <h2>{acc.Name}</h2>
        {page === 0 && <div onClick={goBack}>
          <ArrowBack/>
          <p>Back</p>
        </div>}
      </div>

      <hr className={classes.hr}/>

      <div className={classes.content}> {/* historik, withdraw/deposit, "members",  */}
        <Masonry className={classes.masonry} columnClassName="masonry-column">
          <AccountInfo acc={acc}/>
          <AccountMoneyActions acc={acc}/>
          <AccountHistory acc={acc}/>
        </Masonry>
      </div>
    </div>
  );
};

export default AccountManage;
