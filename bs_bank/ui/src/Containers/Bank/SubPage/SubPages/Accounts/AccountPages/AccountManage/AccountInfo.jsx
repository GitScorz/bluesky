import React, { useState } from 'react';
import { makeStyles } from '@material-ui/core';
import AccountPanel from './AccountPanel';
import Button from '@material-ui/core/Button';
import LinearProgress from '@material-ui/core/LinearProgress';
import Modal from '../../../../../../../Components/Modal/Modal';
import Nui from '../../../../../../../util/Nui';
import { store } from '../../../../../../../Index';

const useStyles = makeStyles(theme => ({
  text: {
    marginTop: 2,
    marginBottom: 2,
    color: theme.palette.secondary.contrastText,

  },
  currency: {
    color: theme.palette.success.dark,
  },
  warn: {
    color: theme.palette.error.dark,
  },
}));

const AccountInfo = ({ acc }) => {

  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const classes = useStyles();
  const handleClose = () => {
    setOpen(false);

    setTimeout(() => {
      setLoading(false);
    }, 300);
  };

  const handleCancel = async () => {
    const payload = {
      AccountNumber: acc.AccountNumber,
    };
    setLoading(true);
    await Nui.send('CloseAccount', payload);
    setLoading(false);
    handleClose();
    store.dispatch({ type: 'ACCOUNTS_RESET_PAGE' });
  };
  return (
    <>
      <AccountPanel
        title="Info" desc="Information about this bank account" height={215}
      >

        <p className={classes.text}>Name: {acc.Name}</p>
        <p className={classes.text}>Number: <span style={{ userSelect: 'text' }}>{acc.AccountNumber}</span></p>
        <p className={classes.text}>Type of account: {acc.type ? 'Joint' : 'Private'}</p>
        <p
          className={classes.text}>Money: <span
          className={classes.currency}>${acc.Amount.toLocaleString('en-US', { minimumFractionDigits: 2 })}</span>
        </p>
        <p><Button className={classes.warn} onClick={() => setOpen(true)}>Close Account</Button></p>
      </AccountPanel>
      <Modal
        open={open}
        title={'Close Account'}
        desc={'Close this Account'}
        onClose={handleClose}
        actions={<>
          <Button onClick={handleCancel} size="small" className="error">Close Account</Button>
          <Button onClick={handleClose} size="small">CANCEL</Button>
        </>}
      >
        {loading && <div className={classes.loading}><LinearProgress/></div>}
        <div
          style={{
            position: 'absolute',
            left: '50%',
            top: '50%',
            textAlign: 'center',
            transform: 'translate(-50%, -50%)',
          }}
        >
          <p className={classes.warn}>This will permanently disable the use of this account</p>
          <p className={classes.warn}>All Money in the account will be lost</p>
        </div>
      </Modal>
    </>
  );
};

export default AccountInfo;
