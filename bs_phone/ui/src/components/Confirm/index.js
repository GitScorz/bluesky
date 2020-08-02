import React from 'react';
import { connect } from 'react-redux';
import { makeStyles, Fade, ButtonGroup, Button  } from '@material-ui/core';

const useStyles = makeStyles(theme => ({
    modal: {
        height: 'fit-content',
        width: '80%',
        position: 'absolute',
        bottom: '10%',
        right: 0,
        left: 0,
        margin: 'auto',
        background: theme.palette.secondary.dark,
        boxShadow: '0 0 15px #000000',
        textAlign: 'center',
        borderRadius: 30,
        zIndex: 25,
    },
    header: {
        paddingBottom: 10,
        fontSize: 25,
        color: theme.palette.text.dark,
    },
    body: {
        padding: 5,
        color: theme.palette.text.main,
    },
    footer: {
        fontSize: 20,
        fontWeight: 'bold',
        color: theme.palette.primary.main,
        width: '100%',
    },
    footerButton: {
        padding: 20,
        borderBottomLeftRadius: 30,
        width: '-webkit-fill-available'
    },
    background: {
        display: 'block',
        height: '100%',
        width: '100%',
        position: 'absolute',
        top: 0,
        left: 0,
        padding: 30,
        zIndex: 24,
    },
    backgroundInner: {
        display: 'block',
        height: '100%',
        width: '100%',
        background: 'rgba(0, 0, 0, 0.75)',
        borderRadius: 50,
    }
}));

export default connect()((props) => {
    const classes = useStyles();

    return (
        <Fade in={props.open != null && !(!props.open)}>
            <div>
                <div className={classes.background}><div className={classes.backgroundInner} onClick={props.onDecline}></div></div>
                <div className={classes.modal}>
                    <h2 className={classes.header}>{props.title}</h2>
                    <div className={classes.body}>
                        {props.children}
                    </div>
                    <div className={classes.footer}>
                        <ButtonGroup variant="text" color="primary" className={classes.footer}>
                            <Button className={classes.footerButton} onClick={props.onDecline}>{props.decline}</Button>
                            <Button className={classes.footerButton} onClick={props.onConfirm}>{props.confirm}</Button>
                        </ButtonGroup>
                    </div>
                </div>
            </div>
        </Fade>
    );
});
