import React from 'react';
import { makeStyles } from '@material-ui/core';
import { useSelector } from 'react-redux';

import AccountManage from '../Bank/SubPage/SubPages/Accounts/AccountPages/AccountManage/AccountManage';


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
  const currSubPage = useSelector(state => state.ATM.currentSubPage);

  return (
    <div className={classes.container}>
      {
        (() => {
          switch (currSubPage) {
            case 0: {
              return <AccountManage/>;
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
