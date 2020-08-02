import React, { useState } from 'react';
import { Button, fade, FormGroup, makeStyles, TextField } from '@material-ui/core';
import { AddRounded as AddIcon } from '@material-ui/icons';

import { AccountItemStyle } from './AccountItem';
import Modal from '../../../../../../../Components/Modal/Modal';
import { isStringEmpty } from '../../../../../../../util/Utils';
import { useSelector } from 'react-redux';
import Nui from '../../../../../../../util/Nui';
import LinearProgress from '@material-ui/core/LinearProgress';

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
  const accountStyles = AccountItemStyle();

  const selfName = useSelector(state => state.App.selfData.name);

  // Open & Close
  const [open, setOpen] = React.useState(false);

  const handleClose = () => {
    setOpen(false);

    setTimeout(() => {
      setLoading(false);
      setName('');
    }, 300);
  };

  const handleCreate = async () => {
    if (isStringEmpty(name)) return;
    const payload = {
      Name: name,
      type: type,
    };
    setLoading(true);
    await Nui.send('CreateAccount', payload);
    setLoading(false);
    handleClose();
  };

  // Form
  const [name, setName] = React.useState('');
  const [loading, setLoading] = useState(false);
  const handleNameChange = e => setName(e.target.value);

  return (
    <>
      <div className={accountStyles.account + ' ' + classes.create} onClick={() => setOpen(true)}>
        <div className="info">
          <div>
            <AddIcon/>
          </div>

          <h3>Create an {type ? 'joint' : 'private'} account</h3>
        </div>
      </div>

      <Modal
        title="Create account"
        desc={`Create an bank account for ${type ? 'joint (shared)' : 'private'} use.`}
        open={open}
        onClose={handleClose} // backdrop pressed
        actions={<>
          <Button onClick={handleCreate} size="small" className="success">CREATE</Button>
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
            <TextField required autoFocus
                       error={isStringEmpty(name)}
                       label="Account name"
                       value={name}
                       onChange={handleNameChange}
                       disabled={loading}
            />
          </FormGroup>
        </div>
      </Modal>
    </>
  );
};

export default AccountCreate;
