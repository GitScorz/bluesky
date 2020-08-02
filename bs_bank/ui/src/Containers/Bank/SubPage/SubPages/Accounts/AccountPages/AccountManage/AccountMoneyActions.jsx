import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import { Button, FormControl, FormGroup, Input, InputAdornment, InputLabel, makeStyles } from '@material-ui/core';

import AccountPanel from './AccountPanel';
import { store } from '../../../../../../../Index';
import Nui from '../../../../../../../util/Nui';
import Modal from '../../../../../../../Components/Modal/Modal';
import LinearProgress from '@material-ui/core/LinearProgress';

const useStyles = makeStyles(theme => ({
  p: {
    marginTop: 2,
    marginBottom: 2,
    color: theme.palette.secondary.contrastText,

    '& span': {
      color: theme.palette.success.dark,
    },
  },

  button: {
    marginTop: '4%',
    textTransform: 'none',
    color: theme.palette.primary.main,
  },
}));

const AccountMoneyActions = ({ acc }) => {

  const self = useSelector(state => state.App.selfData);

  const classes = useStyles();

  const [amount, setAmount] = React.useState(0);

  const handleChange = (e) => {
    if (e.target.value < 0 || isNaN(e.target.value)) return;
    setAmount(e.target.value);
  };

  const handleWithdraw = async () => {
    if (acc.Amount >= amount && amount > 0) {
      const newHistory = {
        Title: `Withdrawal`,
        type: 0,
        Time: new Date(Date.now()).toDateString(),
        Amount: +amount,
      };

      store.dispatch({ type: 'SELF_SET_WALLET', payload: { cash: self.wallet + +amount } });
      store.dispatch({ type: 'ACCOUNT_WITHDRAW', payload: { acc, amount: +amount, history: newHistory } });
      await Nui.send('Withdraw', {
        AccountNumber: acc.AccountNumber,
        Amount: amount,
        History: newHistory,
      });
      handleClose();
      setAmount(0);
    }
  };

  const handleDeposit = async () => {
    if (self.wallet >= amount && amount > 0) {
      const newHistory = {
        Title: `Deposit`,
        type: 1,
        Time: new Date(Date.now()).toDateString(),
        Amount: +amount,
      };
      store.dispatch({ type: 'SELF_SET_WALLET', payload: { cash: self.wallet - +amount } });
      store.dispatch({
        type: 'ACCOUNT_DEPOSIT', payload: {
          acc, amount: +amount, history: newHistory,
        },
      });
      await Nui.send('Deposit', {
        AccountNumber: acc.AccountNumber,
        Amount: amount,
        History: newHistory,
      });
      handleClose();
      setAmount(0);
    }
  };
  const [open, setOpen] = React.useState(false);
  const [loading, setLoading] = useState(false);
  const [type, setType] = useState(null);
  const handleClose = () => {
    setOpen(false);

    setTimeout(() => {
      setLoading(false);
      setAmount(0);
    }, 300);
  };

  return (
    <AccountPanel
      height={200}
      title="Money" desc="Withdraw/Deposit"
    >
      <p className={classes.p}>Wallet: <span>${self.wallet.toLocaleString('en-US', { minimumFractionDigits: 2 })}</span>
      </p>
      <Button className={classes.button} onClick={() => {
        setType('Withdraw');
        setOpen(true);
      }} fullWidth>Withdraw</Button>
      <Button className={classes.button} onClick={() => {
        setType('Deposit');
        setOpen(true);
      }} fullWidth>Deposit</Button>

      <Modal
        title={type}
        open={open}
        onClose={handleClose} // backdrop pressed
        actions={<>
          <Button onClick={() => type === 'Deposit' ? handleDeposit() : handleWithdraw()} size="small"
                  className="success">{type}</Button>
          <Button onClick={handleClose} size="small" className="error">Cancel</Button>
        </>}
      >
        {loading && <div className={classes.loading}><LinearProgress/></div>}
        <div
          style={{
            position: 'absolute',
            left: '50%',
            top: '50%',
            transform: 'translate(-50%, -50%)',
          }}
        >
          <FormGroup className={classes.form}>
            <FormControl fullWidth style={{ marginTop: '4%' }}>
              <InputLabel htmlFor="amount">Amount</InputLabel>
              <Input
                id="amount"
                type="number"
                value={amount}
                onChange={handleChange}
                startAdornment={<InputAdornment position="start">$</InputAdornment>}
              />
            </FormControl>
          </FormGroup>
        </div>
      </Modal>
    </AccountPanel>
  );
};

export default AccountMoneyActions;
