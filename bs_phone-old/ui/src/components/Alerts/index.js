import React, { useEffect, useState } from 'react';
import { useSelector, connect } from 'react-redux';
import { makeStyles, Fade } from '@material-ui/core';

const useStyles = makeStyles(theme => ({
    wrapper: {
        background: 'rgba(0, 0, 0, 0.75)',
        padding: 10,
        borderRadius: 5,
        position: 'absolute',
        bottom: '25%',
        left: 0,
        right: 0,
        margin: 'auto',
        width: 'fit-content',
        maxWidth: '80%',
        minHeight: 40,
        zIndex: 1000,
        pointerEvents: 'none',
    },
}));

export default connect()((props) => {
    const classes = useStyles();
    const alerts = useSelector(state => state.alerts.alerts);

    const [show, setShow] = useState(false);
    const [alertTimer, setAlertTimer] = useState(null);

    useEffect(() => {
        if (alerts.length > 0) {
            if (alertTimer == null) {
                setShow(true);
                setAlertTimer(setTimeout(() => {
                    setShow(false);
                    setTimeout(() => {
                        props.dispatch({
                            type: 'ALERT_EXPIRE',
                        });
                        setAlertTimer(null);
                    }, 500);
                }, 2500));
            }
        } else {
            setShow(false);
        }
    }, [alerts, alertTimer]);

    return (
        <Fade in={show} duration={1000}>
            <div className={classes.wrapper}>
                {
                    alerts.length > 0 ?
                    alerts[0] :
                        null
                }
            </div>
        </Fade>
    );
});
 