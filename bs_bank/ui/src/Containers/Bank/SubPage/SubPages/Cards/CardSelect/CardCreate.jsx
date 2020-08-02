import React, { useState } from 'react';
import { Button, fade, FormGroup, makeStyles } from '@material-ui/core';
import { AddRounded as AddIcon } from '@material-ui/icons';

import { useSelector } from 'react-redux';
import LinearProgress from '@material-ui/core/LinearProgress';
import FormControl from '@material-ui/core/FormControl';
import InputLabel from '@material-ui/core/InputLabel';
import Select from '@material-ui/core/Select';
import MenuItem from '@material-ui/core/MenuItem';
import { CardItemStyle } from './CardItem';
import Modal from '../../../../../../Components/Modal/Modal';
import Nui from '../../../../../../util/Nui';

const useStyles = makeStyles(theme => ({
  create: {
    background: 'transparent',
    boxShadow: 'none',

    '& .info': {
      width: '60%',
      height: '40%',
      margin: 'auto',
      marginTop: '10%',
      textAlign: 'center',

      '& div': {
        background: fade(theme.palette.primary.main, 0.025),
        height: 48,
        width: 48,
        margin: 'auto',
        borderRadius: 50,

        '& .MuiSvgIcon-root': {
          verticalAlign: 'middle',
          fontSize: 36,
          margin: 'auto',
          marginTop: 6,
          color: theme.palette.primary.main,
        },
      },
      '& h3': {
        fontWeight: 400,
        color: theme.palette.secondary.contrastText,
        marginTop: 6,
      },
    },
  },
  loading: {
    paddingLeft: 10,
    paddingRight: 10,
  },
  form: {
    width: '100%',
    height: '100%',
    textAlign: 'center',
  },
}));

const AccountCreate = ({ type }) => {

  const classes = useStyles();
  const accountStyles = CardItemStyle();

  const accs = useSelector(state => state.Accounts.list);

  // Open & Close
  const [open, setOpen] = React.useState(false);

  const handleClose = () => {
    setOpen(false);

    setTimeout(() => {
      setLoading(false);
    }, 300);
  };

  const handleCommission = async () => {
    if (acc === null) return;
    const payload = {
      AccountNumber: acc,
    };
    setLoading(true);
    await Nui.send('CommissionCard', payload);
    setLoading(false);
    handleClose();
  };

  // Form
  const [acc, setAcc] = React.useState(null);
  const [loading, setLoading] = useState(false);
  const handleChange = e => setAcc(e.target.value);

  return (
    <>
      <div className={accountStyles.account + ' ' + classes.create} onClick={() => setOpen(true)}>
        <div className="info">
          <div>
            <AddIcon/>
          </div>

          <h3>Commission a Card</h3>
        </div>
      </div>

      <Modal
        title="Card"
        desc={`Commission a Card`}
        open={open}
        onClose={handleClose} // backdrop pressed
        actions={<>
          <Button onClick={handleCommission} size="small" className="success">Commission</Button>
          <Button onClick={handleClose} size="small" className="error">CANCEL</Button>
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
            <FormControl className={classes.formControl} fullWidth>
              <InputLabel>Account</InputLabel>
              <Select
                value={acc}
                onChange={handleChange}
              >
                {accs.map((value, key) => {
                  return <MenuItem selected={key === 0} value={value.AccountNumber}>{value.AccountNumber}</MenuItem>;
                })}
              </Select>
            </FormControl>
          </FormGroup>
        </div>
      </Modal>
    </>
  );
};

export default AccountCreate;
