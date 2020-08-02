import React, { useEffect, useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import { makeStyles, withStyles, Grid, Avatar, ExpansionPanel as MuiExpansionPanel, ExpansionPanelSummary, ExpansionPanelDetails, Paper } from '@material-ui/core';
import ExpandMoreIcon from '@material-ui/icons/ExpandMore';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { PhoneMissed as PhoneMissedIcon, CallMade as OutgoingIcon, CallReceived as IncomingIcon } from '@material-ui/icons';
import Moment from 'react-moment';
import { createCall } from './action';

const ExpansionPanel = withStyles({
    root: {
        border: '1px solid rgba(0, 0, 0, .25)',
        boxShadow: 'none',
        '&:not(:last-child)': {
            borderBottom: 0,
        },
        '&:before': {
            display: 'none',
        },
        '&$expanded': {
            margin: 'auto',
        },
    },
    expanded: {},
})(MuiExpansionPanel);

const useStyles = makeStyles(theme => ({
    contact: {
        '&::before': {
            background: 'transparent !important',
        },
        background: theme.palette.secondary.dark,
        '&:hover': {
			background: theme.palette.secondary.main,
			transition: 'background ease-in 0.15s',
			cursor: 'pointer',
        },
    },
    paper: {
        background: theme.palette.secondary.dark,
    },
    expandoContainer: {
        textAlign: 'center',
        fontSize: 30,
    },
    expandoItem: {
        '&:hover': {
            color: theme.palette.primary.main,
            transition: 'color ease-in 0.15s',
        }
    },
    avatar: {
        color: '#fff',
        height: 45,
        width: 45,
    },
    avatarFav: {
        color: '#fff',
        height: 45,
        width: 45,
        border: '2px solid gold',
    },
    contactName: {
        fontSize: 18,
        color: theme.palette.text.light,
    },
    contactNumber: {
        fontSize: 16,
        color: theme.palette.text.main,
    },
    expanded: {
        margin: 0,
    },
    missedIcon: {
        height: 16,
        width: 16,
        color: theme.palette.error.main
    },
    incomingIcon: {
        height: 16,
        width: 16,
        color: '#5ec750',
    },
    outgoingIcon: {
        height: 16,
        width: 16,
        color: '#50a2c7',
    },
    callDate: {
        textAlign: 'right',
        fontSize: 12,
    }
}));

export default connect(null, { createCall })((props) => {
    const classes = useStyles();
    const history = useHistory();
    const contacts = useSelector(state => state.data.data.contacts);
    const callData = useSelector(state => state.call.call);
    const isContact = contacts.filter((c) => c.number === props.call.number)[0];

    const callContact = () => {
        if (callData == null) {
            props.createCall(props.call.number);
            history.push(`/apps/phone/call/${props.call.number}`);
        }
    }

    const textContact = () => {
        history.push(`/apps/messages/convo/${props.call.number}`);
    }

    const editContact = () => {
        history.push(`/apps/contacts/edit/${isContact._id}`);
    }

    const addContact = () => {
        history.push(`/apps/contacts/add/${props.call.number}`);
    }

    const getCallIcon = (call) => {
        if (call.duration > -1) {
            if (call.method) {
                return(<OutgoingIcon className={classes.outgoingIcon} />);
            } else {
                return(<IncomingIcon className={classes.incomingIcon} />);
            }
        } else {
            if (call.method) {
                return(<OutgoingIcon className={classes.missedIcon} />);
            } else {
                return(<PhoneMissedIcon className={classes.missedIcon} />);
            }
        }
    }

    return (
        <Paper className={classes.paper}>
            <ExpansionPanel className={classes.contact} expanded={props.expanded == props.index} onChange={props.onClick}>
                <ExpansionPanelSummary expandIcon={<ExpandMoreIcon />}>
                    <Grid container>
                        <Grid item xs={2}>
                            {
                                isContact != null && isContact.avatar != null && isContact.avatar !== '' ?
                                <Avatar className={isContact.favorite ? classes.avatarFav : classes.avatar} src={isContact.avatar} alt={isContact.name.charAt(0)} /> :
                                <Avatar className={isContact != null && isContact.favorite ? classes.avatarFav : classes.avatar} style={{ background: isContact != null && isContact.color ? isContact.color : '#333' }}>{isContact != null ? isContact.name.charAt(0) : '#'}</Avatar>
                            }
                        </Grid>
                        <Grid item xs={10}>
                            <div className={classes.contactName}>{isContact != null ? isContact.name : 'Unkown Caller'}</div>
                            <Grid container className={classes.contactNumber}>
                                <Grid item xs={6}>{getCallIcon(props.call)} {props.call.number}</Grid>
                                <Grid item xs={6} className={classes.callDate}><Moment fromNow>{+props.call.time}</Moment></Grid>
                            </Grid>
                        </Grid>
                    </Grid>
                </ExpansionPanelSummary>
                <ExpansionPanelDetails>
                    <Grid container className={classes.expandoContainer}>
                        <Grid item xs={4} className={classes.expandoItem} onClick={callContact}>
                            <FontAwesomeIcon icon='phone' />
                        </Grid>
                        <Grid item xs={4} className={classes.expandoItem} onClick={textContact}>
                            <FontAwesomeIcon icon='sms' />
                        </Grid>
                        {
                            isContact != null ?
                            <Grid item xs={4} className={classes.expandoItem} onClick={editContact}>
                                <FontAwesomeIcon icon='user-edit' />
                            </Grid> :
                            <Grid item xs={4} className={classes.expandoItem} onClick={addContact}>
                                <FontAwesomeIcon icon='user-plus' />
                            </Grid>
                        }
                    </Grid>
                </ExpansionPanelDetails>
            </ExpansionPanel>
        </Paper>
    );
});
