import React, { useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import { makeStyles, Grid, Avatar, IconButton } from '@material-ui/core';
import { green, red } from '@material-ui/core/colors';
import PhoneIcon from '@material-ui/icons/Phone';

import { Modal } from '../../components';
import { addToCall, acceptCall, endCall, dismissIncoming } from './action';

const useStyles = makeStyles(theme => ({
    incomingModal: {
        boxShadow: `0 0 25px ${green[400]}`,
    },
    avatar: {
        height: 100,
        width: 100,
        fontSize: 35,
        color: theme.palette.text.dark,
        display: 'block',
        textAlign: 'center',
        lineHeight: '105px',
        margin: 'auto',
        transition: 'border 0.15s ease-in',
    },
    avatarFav: {
        height: 100,
        width: 100,
        fontSize: 35,
        color: theme.palette.text.dark,
        display: 'block',
        textAlign: 'center',
        lineHeight: '105px',
        margin: 'auto',
        border: '2px solid gold',
        transition: 'border 0.15s ease-in',
    },
    contactNumber: {
        fontSize: 14,
        color: theme.palette.primary.main,
    },
    incomingNumber: {
        width: '100%',
        textAlign: 'center',
        padding: 20,
        '& span': {
            fontSize: 30,
            fontWeight: 'bold',
        }
    },
    keypadBtn: {
        textAlign: 'center',
        height: 75,
        fontSize: '25px',
        width: '100%',
    },
    keypadAction: {
        padding: 15,
        color: theme.palette.getContrastText(green[500]),
        backgroundColor: green[500],
        '&:hover': {
            backgroundColor: green[700],
        },
    },
    keypadAction2: {
        padding: 15,
        color: theme.palette.getContrastText(red[500]),
        backgroundColor: red[500],
        '&:hover': {
            backgroundColor: red[700],
        },
    },
}));

export default connect(null, { acceptCall, endCall, dismissIncoming })((props) => {
    const classes = useStyles();
    const history = useHistory();
    const contacts = useSelector(state => state.data.data.contacts);
    const isContact = props.call == null ? null : contacts.filter((c) => c.number === props.call.number)[0];
    const isDismissed = useSelector(state => state.call.incomingDismissed);

    const acceptCall = e => {
        props.acceptCall(props.call.number);
        history.push(`/apps/phone/call/${props.call.number}`)

    }

    const rejectCall = e => {
        props.endCall();
    }

    const closeIncoming = e => {
        props.dismissIncoming();
    }

    if (props.call == null || props.call.state !== 1) {
        return null;
    } else {
        return (
            <Modal className={classes.incomingModal} open={props.call.state === 1 && !isDismissed} handleClose={closeIncoming} title='Incoming Call'>
                <Grid container>
                    <Grid item xs={12}>
                        { isContact != null ? 
                            (isContact.avatar != null && isContact.avatar !== '' ?
                                <Avatar
                                    className={isContact.favorite ? classes.avatarFav : classes.avatar}
                                    src={isContact.avatar}
                                    alt={isContact.name.charAt(0)}
                                /> :
                                <Avatar
                                    className={isContact.favorite ? classes.avatarFav : classes.avatar}
                                    style={{
                                        background: isContact.color,
                                    }}
                                >
                                    {isContact.name.charAt(0)}
                                </Avatar>) :
                                <Avatar
                                    className={classes.avatar}
                                    style={{
                                        background: '#333',
                                    }}
                                >#</Avatar>
                        }
                    </Grid>
                    <Grid item xs={12}>
                        <div className={classes.incomingNumber}>
                            <span>{ isContact != null ? isContact.name : props.call.number }</span>
                            { isContact != null ? <div className={classes.contactNumber}>{isContact.number}</div> : null }
                        </div>
                    </Grid>
                    <Grid item xs={12}>
                        <Grid container style={{marginTop: '10%', marginBottom: '10%'}}>
                            <Grid item xs={6} className={classes.keypadBtn}>
                                <IconButton className={classes.keypadAction} onClick={acceptCall}>
                                    <PhoneIcon style={{ fontSize: 40 }} />
                                </IconButton>
                            </Grid>
                            <Grid item xs={6} className={classes.keypadBtn}>
                                <IconButton className={classes.keypadAction2} onClick={rejectCall}>
                                    <PhoneIcon style={{ fontSize: 40 }} />
                                </IconButton>
                            </Grid>
                        </Grid>
                    </Grid>
                </Grid>
            </Modal>
        );
    }
});
