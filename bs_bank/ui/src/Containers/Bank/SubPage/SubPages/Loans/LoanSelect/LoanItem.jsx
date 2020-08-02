import React, { useState } from 'react';
import { FormControl, FormGroup, Input, InputAdornment, InputLabel, makeStyles } from '@material-ui/core';
import { AttachMoney } from '@material-ui/icons';
import Button from '@material-ui/core/Button';
import Modal from '../../../../../../Components/Modal/Modal';
import Moment from 'react-moment';
import LinearProgress from '@material-ui/core/LinearProgress';
import { store } from '../../../../../../Index';
import Nui from '../../../../../../util/Nui';
import { useSelector } from 'react-redux';

const useStyles = makeStyles(theme => ({
  account: {
    width: '35%',
    height: '40%',
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
  warn: {
    color: theme.palette.error.dark,
  },
  success: {
    color: theme.palette.success.dark,
  },
  button: {
    position: 'absolute',
    left: '5%',
    bottom: '0',
    color: theme.palette.success.dark,
  },
  modal: {
    '& p': {
      fontSize: 12,
      fontWeight: 100,
      marginTop: 3,
      color: theme.palette.secondary.contrastText,
    },
  },
  p: {
    marginTop: 2,
    marginBottom: 2,
    color: theme.palette.secondary.contrastText,

    '& span': {
      color: theme.palette.success.dark,
    },
  },
}));

const LoanItem = ({ loan }) => {

  const classes = useStyles();
  const [open, setOpen] = useState(false);
  const [openPayNow, setOpenPayNow] = useState(false);
  const [loading, setLoading] = useState(false);
  const self = useSelector(state => state.App.selfData);

  const [amount, setAmount] = React.useState(0);
  const handleChange = (e) => {
    if (e.target.value < 0 || isNaN(e.target.value)) return;
    setAmount(e.target.value);
  };

  const handlePayment = async () => {
    if (self.wallet >= amount && amount > 0) {
      const payment = {
        Title: `Payment`,
        Time: new Date(Date.now()).toDateString(),
        Amount: +amount,
      };
      store.dispatch({ type: 'SELF_SET_WALLET', payload: { cash: self.wallet - amount } });
      store.dispatch({
        type: 'LOANS_PAYMENT', payload: {
          loan, amount: +amount, payment: payment,
        },
      });
      setLoading(true);
      await Nui.send('LoanPayment', {
        LoanNumber: loan.LoanNumber,
        Amount: amount,
        Payment: payment,
      });
      setLoading(false);
      setAmount(0);
      setOpenPayNow(false);
    }
  };

  return (
    <>
      <div className={classes.account} onClick={() => setOpen(true)}>
        <div className={classes.info}>
          <h3>{loan.LoanNumber}</h3>
          <p>Due Date: <Moment format="YYYY/MM/DD HH:mm">{loan.DueDateTime * 1000}</Moment></p>
          <hr/>
          <p>Remaining Amount: <span
            className={loan.RemainingAmount > 0 ? classes.warn : classes.success}>${loan.RemainingAmount.toLocaleString('en-US', { minimumFractionDigits: 2 })}</span>
          </p>
          <p>Due Now: <span
            className={loan.Due > 0 ? classes.warn : classes.success}>${loan.Due.toLocaleString('en-US', { minimumFractionDigits: 2 })}</span></p>
        </div>
        <div style={{ position: 'relative' }}>
          <AttachMoney className={classes.backIcon} style={{ right: 0 }}/>
        </div>
      </div>
      <Modal
        onClose={() => setOpen(false)}
        title={loan.LoanNumber}
        desc={`${loan.LoanType ? loan.LoanType : ''} Loan Information`}
        open={open}
        actions={<>
          <Button className={'error'} onClick={() => setOpen(false)}>Close</Button>
          <Button className={'success'} onClick={() => setOpenPayNow(true)}>Pay Now</Button>
        </>}
      >
        <div
          className={classes.modal}
          style={{
            position: 'absolute',
            left: '50%',
            top: '57%',
            transform: 'translate(-50%, -50%)',
          }}
        >
          <p>Due Date: <Moment format="YYYY/MM/DD HH:mm">{loan.DueDateTime * 1000}</Moment></p>
          {loan.LoanType === 'Vehicle' && <div>
            <p>Registration Number: {loan.LoanEntity.RegPlate}</p>
            <p>Vehicle Make: {loan.LoanEntity.Make}</p>
          </div>}
          {loan.LoanType === 'Property' && <div>
            <p>Address: {loan.LoanEntity.Address}</p>
          </div>}
          <p>Remaining Amount: <span
            className={loan.RemainingAmount > 0 ? classes.warn : classes.success}>${loan.RemainingAmount.toLocaleString('en-US', { minimumFractionDigits: 2 })}</span>
          </p>
          <p>Due Now: <span
            className={loan.Due > 0 ? classes.warn : classes.success}>${loan.Due.toLocaleString('en-US', { minimumFractionDigits: 2 })}</span></p>
        </div>
      </Modal>
      <Modal open={openPayNow} onClose={() => setOpenPayNow(false)} title={'Pay Now'} desc={'Pay your loan off'}
             actions={<>
               <Button className={'error'} onClick={() => setOpenPayNow(false)}>Close</Button>
               <Button className={'success'} onClick={handlePayment}>Pay</Button>
             </>
             }>
        {loading && <div className={classes.loading}><LinearProgress/></div>}
        <div
          style={{
            position: 'absolute',
            left: '50%',
            top: '50%',
            transform: 'translate(-50%, -50%)',
          }}
        >

          <p
            className={classes.p}>Wallet: <span>${self.wallet.toLocaleString('en-US', { minimumFractionDigits: 2 })}</span>
          </p>
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
    </>
  );
};


export { useStyles as LoanItemStyle };
export default LoanItem;
