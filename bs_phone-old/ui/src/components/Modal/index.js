import React from 'react';
import { connect } from 'react-redux';
import { makeStyles, Fade } from '@material-ui/core';

const useStyles = makeStyles(theme => ({
    closer: {
        position: 'absolute',
        right: 30,
        bottom: 95,
        height: 870,
        width: 440,
        background: '#000',
        opacity: 0.75,
        zIndex: 10000,
        borderRadius: 25,
    },
    modal: {
        height: 'fit-content',
        width: '75%',
        position: 'absolute',
        top: 0,
        bottom: 0,
        right: 0,
        left: 0,
        margin: 'auto',
        background: theme.palette.secondary.dark,
        padding: 10,
        zIndex: 10001,
    },
    header: {
        paddingBottom: 10,
        borderBottom: `1px solid ${theme.palette.primary.main}`,
    },
    body: {
        padding: 5,
    },
}));

export default connect()((props) => {
    const classes = useStyles();

    return (
        <Fade in={props.open}>
            <div>
                <div className={classes.closer} onClick={props.handleClose}></div>
                <div className={`${classes.modal} ${props.className != null ? props.className : ''}`}>
                    { props.title !== '' ?
                        <h2 className={classes.header}>{props.title}</h2> :
                        null
                    }
                    <div className={classes.body}>
                        {props.children}
                    </div>
                </div>
            </div>
        </Fade>
    );
});
