import React, { useEffect, useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import { makeStyles, Avatar, Grid, Button, IconButton } from '@material-ui/core';
import { grey, red } from '@material-ui/core/colors';
import { Inline } from '@zendeskgarden/react-loaders';

import PersonAddIcon from '@material-ui/icons/PersonAdd';
import PauseIcon from '@material-ui/icons/Pause';
import VolumeUpIcon from '@material-ui/icons/VolumeUp';
import PhoneIcon from '@material-ui/icons/Phone';

import { addToCall, endCall } from './action';

const useStyles = makeStyles(theme => ({
    wrapper: {
        height: '100%',
        background: theme.palette.secondary.main,
    },
    content: {
        height: '90.5%',
        padding: 15,
        overflowY: 'auto',
        overflowX: 'hidden',
        padding: 10,
        '&::-webkit-scrollbar': {
            width: 6,
        },
        '&::-webkit-scrollbar-thumb': {
            background: '#ffffff52',
        },
        '&::-webkit-scrollbar-thumb:hover': {
            background: theme.palette.primary.main,
        },
        '&::-webkit-scrollbar-track': {
            background: 'transparent',
        },
    },
    tabPanel: {
        height: '100%',
    },
    phoneTab: {
        minWidth: '33.3%',
    },
    avatar: {
        height: 100,
        width: 100,
        fontSize: 35,
        color: theme.palette.text.dark,
        display: 'block',
        textAlign: 'center',
        lineHeight: '100px',
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
        lineHeight: '100px',
        margin: 'auto',
        border: '2px solid gold',
        transition: 'border 0.15s ease-in',
    },
    callData: {
        textAlign: 'center',
        marginTop: '10%',
        fontSize: 35,
        '& small': {
            display: 'block',
            fontSize: 20,
            marginTop: '2%',
        }
    },
    phoneBottom: {
        marginTop: '25%',
        textAlign: 'center',
    },
    keypadBtn: {
        textAlign: 'center',
        height: 75,
        fontSize: '25px',
        width: '100%',
    },
    keypadAction: {
        padding: 20,
        color: theme.palette.getContrastText(red[500]),
        backgroundColor: red[500],
        '&:hover': {
            backgroundColor: red[700],
        },
    },
}));

export default connect(null, { addToCall, endCall })((props) => {
    const classes = useStyles();
    const history = useHistory();
    const { number } = props.match.params;
    const contacts = useSelector(state => state.data.data.contacts);
    const callData = useSelector(state => state.call.call);
    const callDuration = useSelector(state => state.call.duration);
    const isContact = contacts.filter((c) => c.number === number)[0];

    const [isEnding, setIsEnding] = useState(false);

    useEffect(() => {
        setIsEnding(null);
    }, [])

    useEffect(() => {
        let fml = null;
        if (callData == null) {
            setIsEnding(true);
            fml = setTimeout(() => {
                history.goBack();
            }, 2500)
        }

        return () => {
            clearTimeout(fml);
        }
    }, [callData]);

    const addToCall = e => {
        props.addToCall(number);
    };

    const holdCall = e => {
    };

    const putOnSpeaker = e => {
        
    };

    const endCall = e => {
        console.log(JSON.stringify(callData, null, 4));
        console.log(isEnding);
        console.log(callData == null || isEnding);
        if (callData == null || isEnding) return;
        props.endCall();
    };

    function durToTime(duration) {
        var pad = function(num, size) { return ('000' + num).slice(size * -1); },
        time = parseFloat(duration).toFixed(3),
        hours = Math.floor(time / 60 / 60),
        minutes = Math.floor(time / 60) % 60,
        seconds = Math.floor(time - minutes * 60)
    
        return pad(hours, 2) + ':' + pad(minutes, 2) + ':' + pad(seconds, 2);
    }

    return (
        <div className={classes.wrapper}>
            <div className={classes.phoneTop}>
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
                <div className={classes.callData}>
                    { isContact != null ? isContact.name : number }
                    {
                        !isEnding ?
                        (<small>{callData != null ? (callData.state > 0 ? durToTime(callDuration) : <span>Calling <Inline size={12} color={grey[50]} /></span>) : <span>Pending <Inline size={12} color={grey[50]} /></span>}</small>) :
                        <small>Call Ended</small>
                    }
                </div>
            </div>
            <div className={classes.phoneBottom}>
                <Grid container>
                    <Grid item xs={4}>
                        <Button color="primary" className={classes.keypadBtn} onClick={addToCall}><PersonAddIcon style={{ fontSize: 40 }} /></Button>
                    </Grid>
                    <Grid item xs={4}>
                        <Button color="primary" className={classes.keypadBtn} onClick={holdCall}><PauseIcon style={{ fontSize: 40 }} /></Button>
                    </Grid>
                    <Grid item xs={4}>
                        <Button color="primary" className={classes.keypadBtn} onClick={putOnSpeaker}><VolumeUpIcon style={{ fontSize: 40 }} /></Button>
                    </Grid>
                    <Grid item xs={12} className={classes.keypadBtn} style={{marginTop: '42%'}}>
                        <IconButton className={classes.keypadAction} onClick={endCall} disabled={callData == null}>
                            <PhoneIcon style={{ fontSize: 40 }} />
                        </IconButton>
                    </Grid>
                </Grid>
            </div>
        </div>
    );
});
