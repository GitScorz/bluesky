import React, { useEffect, useState } from 'react';
import { compose } from 'redux';
import { connect, useSelector } from 'react-redux';
import { useNavigate } from "react-router-dom";
import withRouter from '../../hooks/withRouter';
import { Grid, makeStyles, CircularProgress, Collapse } from '@material-ui/core';
import Moment from 'react-moment';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { grey, green, red } from '@material-ui/core/colors';
import { Inline } from '@zendeskgarden/react-loaders';

import { showIncoming } from '../../Apps/phone/action';
import CallTimer from '../../Apps/phone/timer';

import { removeNewNotif } from '../../actions/notificationAction';

export default compose(withRouter, connect(null, { removeNewNotif, showIncoming }))((props) => {
    const notifications = useSelector(state => state.notifications.notifications);
    const newNotifs = useSelector(state => state.notifications.new);
    const installing = useSelector(state => state.store.installing).length > 0;
    const uninstalling = useSelector(state => state.store.uninstalling).length > 0;
    const settings = useSelector(state => state.data.data.settings);

    const callData = useSelector(state => state.call.call);

    const useStyles = makeStyles(theme => ({
        header: {
            background: (props.location.pathname != '/' && props.location.pathname != '/apps') ? theme.palette.secondary.main : 'transparent',
            height: '8%',
            margin: 'auto',
            borderTopLeftRadius: 30,
            borderTopRightRadius: 30,
            fontSize: '16px',
            lineHeight: '75px',
            padding: '0 105px 0 20px',
            '&:hover': {
                filter: 'brightness(0.75)',
                transition: 'filter ease-in 0.15s',
                cursor: 'pointer',
            }
        },
        hLeft: {
            color: theme.palette.text.light,
        },
        hRight: {
            textAlign: 'right',
        },
        headerIcon: {
            marginLeft: 10,
            '&:first-child': {
                marginLeft: 0,
            }
        },
        newNotifIcon: {
            marginRight: 10,
        },
        newTime: {
            display: 'block',
            color: theme.palette.text.main,
            fontSize: 12,
        },
        newText: {
            maxWidth: '80%',
            overflow: 'hidden',
            textOverflow: 'ellipsis',
        },
        newNotif: {
            zIndex: 5,  
            position: 'absolute',
            width: '89%',
            height: '7%',
            padding: 25,
            background: theme.palette.secondary.dark,
            whiteSpace: 'nowrap',
            overflow: 'hidden',
            textOverflow: 'ellipsis',
            borderTopLeftRadius: 30,
            borderTopRightRadius: 30,
            '&:hover': {
                background: theme.palette.secondary.light,
                transition: 'background ease-in 0.15s',
                cursor: 'pointer',
            }
        },
        callActive: {
            marginLeft: 10,
            whiteSpace: 'nowrap',
            overflow: 'hidden',
            textOverflow: 'ellipsis'
        }
    }));

    const classes = useStyles();
    const navigate = useNavigate()
    const [show, setShow] = useState(false);
    const [newTimer, setNewTimer] = useState(null);

    useEffect(() => {
        if (newNotifs.length > 0) {
            if (newTimer == null) {
                setShow(true);
                setNewTimer(setTimeout(() => {
                    setShow(false);
                    setTimeout(() => {
                        props.removeNewNotif();``
                    }, 500);
                    setNewTimer(null);
                }, 2000));
            }
        } else {
            setShow(false);
        }
    }, [newNotifs]);

    const onClick = () => {
        if (notifications.length > 0 && props.location.pathname != '/notifications') {
            navigate('/notifications');
        }
    }

    const onClickCall = () => {
        if (callData != null) {
            if (callData.state === 1) {
                props.showIncoming();
            } else {
                navigate(`/apps/phone/call/${callData.number}`);
            }
        }
    }

    const onNewClick = (app) => {
        if (newTimer != null) {
            clearTimeout(newTimer);
            setNewTimer(null);
            setShow(false);
            setTimeout(() => {
                props.removeNewNotif();
            }, 500);
        }

        navigate(`/apps/${app}`);
    }

    if ((callData == null) || (props.location.pathname.startsWith('/apps/phone/call')))
    {
        return (
            <div>
                <Collapse collapsedHeight={0} in={show}>
                    <div className={classes.newNotif} onClick={() => onNewClick(newNotifs[0].app)}>
                        {
                            newNotifs[0] != null ?
                            <div className={classes.newText}>
                                <FontAwesomeIcon className={classes.newNotifIcon} style={{ color: newNotifs[0].color }} icon={newNotifs[0].icon} /> {newNotifs[0].text}
                                <Moment className={classes.newTime} fromNow>{Date.now()}</Moment>
                            </div> :
                            null
                        }
                    </div>
                </Collapse>
                <Grid container className={classes.header} onClick={onClick}>
                    <Grid item xs={8} className={classes.hLeft}>
                        { callData != null && callData.state === 2 ? <CallTimer /> : null }
                        <Moment interval={30000} format='hh:mm' />
                        {
                            notifications.filter((app, i) => (i < 5)).map((notif, i) => {
                                return(<FontAwesomeIcon key={i} className={classes.headerIcon} style={{ color: notif.color }} icon={notif.icon} />);
                            })
                        }
                        {
                            notifications.length > 5 ?
                            <span className={classes.headerIcon}>+{notifications.length - 5}</span> :
                            null
                        }
                    </Grid>
                    <Grid item xs={4} className={classes.hRight}>
                        {
                            installing && !props.location.pathname.startsWith('/apps/store') ? 
                            <CircularProgress
                                size={18}
                                className={classes.headerIcon}
                                style={{ color: green[500] }}
                            /> :
                            (
                                uninstalling && !props.location.pathname.startsWith('/apps/store') ? 
                                <CircularProgress
                                    size={18}
                                    className={classes.headerIcon}
                                    style={{ color: red[500] }}
                                /> :
                                <FontAwesomeIcon className={classes.headerIcon} icon='wifi' />
                            )
                        }
                        <FontAwesomeIcon className={classes.headerIcon} icon='signal' />
                        <FontAwesomeIcon className={classes.headerIcon} icon='battery-full' />
                    </Grid>
                </Grid>
            </div>
        );
    } else {
        return (
            <div>
                <Grid container className={classes.header} onClick={onClickCall}>
                    <Grid item xs={8} className={classes.hLeft}>
                        { callData != null && callData.state === 2 ? <CallTimer /> : null }
                        <Moment interval={30000} format='hh:mm' />
                        {
                            callData.state == 0 ?
                            <small className={classes.callActive}> Calling <Inline size={12} color={grey[50]} /></small> :
                            (callData.state == 1 ? 
                            <small className={classes.callActive}>
                                Call Incoming <Inline size={12} color={grey[50]} />
                            </small> :
                            <small className={classes.callActive}>
                                Call Active <Inline size={12} color={grey[50]} />
                            </small>)
                        }
                    </Grid>
                    <Grid item xs={4} className={classes.hRight}>
                        {
                            installing && !props.location.pathname.startsWith('/apps/store') ? 
                            <CircularProgress
                                size={18}
                                className={classes.headerIcon}
                                style={{ color: green[500] }}
                            /> :
                            (
                                uninstalling && !props.location.pathname.startsWith('/apps/store') ? 
                                <CircularProgress
                                    size={18}
                                    className={classes.headerIcon}
                                    style={{ color: red[500] }}
                                /> :
                                <FontAwesomeIcon className={classes.headerIcon} icon='wifi' />
                            )
                        }
                        <FontAwesomeIcon className={classes.headerIcon} icon='signal' />
                        <FontAwesomeIcon className={classes.headerIcon} icon='battery-full' />
                    </Grid>
                </Grid>
            </div>
        );
    }
});
