import React from 'react';
import { useSelector } from 'react-redux';

import AccountSelect from './AccountSelect/AccountSelect';
import AccountManage from './AccountManage/AccountManage';

const AccountPages = () => {

  const page = useSelector(state => state.Accounts.page);

  return (
    <>
      {page ? <AccountManage/> : <AccountSelect/>}
    </>
  );
};

export default AccountPages;
