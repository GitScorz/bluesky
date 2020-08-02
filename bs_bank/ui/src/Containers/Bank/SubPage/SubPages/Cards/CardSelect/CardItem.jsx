import React, { useState } from 'react';
import { makeStyles } from '@material-ui/core';
import { CreditCard } from '@material-ui/icons';
import Button from '@material-ui/core/Button';
import Modal from '../../../../../../Components/Modal/Modal';
import LinearProgress from '@material-ui/core/LinearProgress';
import Nui from '../../../../../../util/Nui';

const useStyles = makeStyles(theme => ({
  account: {
    width: '35%',
    height: '35%',
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
}));

const CardItem = ({ card }) => {

  const classes = useStyles();
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);

  const handleClose = () => {
    setOpen(false);

    setTimeout(() => {
      setLoading(false);
    }, 300);
  };

  const handleCancel = async () => {
    const payload = {
      CardNumber: card.CardNumber,
    };
    setLoading(true);
    await Nui.send('CancelCard', payload);
    setLoading(false);
    handleClose();
  };

  return (
    <div className={classes.account}>
      <div className={classes.info}>
        <h3>{card.CardNumber}</h3>
        <p>Account Number: {card.AccountNumber}</p>
        <hr/>
      </div>
      <div style={{ position: 'relative' }}>
        <Button className={classes.cancelButton} onClick={() => setOpen(true)}>Cancel</Button>
        <CreditCard className={classes.backIcon} style={{ right: 0 }}/>
      </div>

      <Modal
        open={open}
        title={'Cancel'}
        desc={'Cancel this Card'}
        onClose={handleClose}
        actions={<>
          <Button onClick={handleCancel} size="small" className="error">CANCEL</Button>
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
          <p className={classes.warn}>This will permanently disable the use of this card</p>
        </div>
      </Modal>
    </div>
  );
};

export { useStyles as CardItemStyle };
export default CardItem;
