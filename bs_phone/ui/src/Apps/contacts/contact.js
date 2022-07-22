import React from 'react';
import { connect, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { makeStyles, withStyles, Grid, Avatar, ExpansionPanel as MuiExpansionPanel, ExpansionPanelSummary, ExpansionPanelDetails, Paper } from '@material-ui/core';
import ExpandMoreIcon from '@material-ui/icons/ExpandMore';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { createCall } from '../phone/action';

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
    }
}));

export default connect(null, { createCall })((props) => {
    const classes = useStyles();
    const navigate = useNavigate()
    const callData = useSelector(state => state.call.call);

    const callContact = () => {
        if (callData == null) {
            props.createCall(props.contact.number);
            navigate(`/apps/phone/call/${props.contact.number}`);
        }
    }

    const textContact = () => {
        navigate(`/apps/messages/convo/${props.contact.number}`);
    }

    const editContact = () => {
        navigate(`/apps/contacts/edit/${props.contact._id}`);
    }

    return(
        <Paper className={classes.paper}>
        <ExpansionPanel className={classes.contact} expanded={props.expanded == props.index} onChange={props.onClick}>
            <ExpansionPanelSummary expandIcon={<ExpandMoreIcon />} style={{ padding: '0 12px'}}>
                <Grid container>
                    <Grid item xs={2}>
                        {
                            props.contact.avatar != null && props.contact.avatar !== '' ?
                            <Avatar className={props.contact.favorite ? classes.avatarFav : classes.avatar} src={props.contact.avatar} alt={props.contact.name.charAt(0)} /> :
                            <Avatar className={props.contact.favorite ? classes.avatarFav : classes.avatar} style={{ background: props.contact.color }}>{props.contact.name.charAt(0)}</Avatar>
                        }
                    </Grid>
                    <Grid item xs={10}>
                        <div className={classes.contactName}>{props.contact.name}</div>
                        <div className={classes.contactNumber}>{props.contact.number}</div>
                    </Grid>
                </Grid>
            </ExpansionPanelSummary>
            <ExpansionPanelDetails>
                <Grid container className={classes.expandoContainer}>
                    <Grid item xs={props.onDelete != null ? 3 : 4} className={classes.expandoItem} onClick={callContact}>
                        <FontAwesomeIcon icon='phone' />
                    </Grid>
                    <Grid item xs={props.onDelete != null ? 3 : 4} className={classes.expandoItem} onClick={textContact}>
                        <FontAwesomeIcon icon='sms' />
                    </Grid>
                    <Grid item xs={props.onDelete != null ? 3 : 4} className={classes.expandoItem} onClick={editContact}>
                        <FontAwesomeIcon icon='user-edit' />
                    </Grid>
                    {
                        props.onDelete != null ?
                        <Grid item xs={3} className={classes.expandoItem} onClick={props.onDelete}>
                            <FontAwesomeIcon icon='user-minus' />
                        </Grid> : null
                    }
                </Grid>
            </ExpansionPanelDetails>
        </ExpansionPanel>
        </Paper>
    )  
});
