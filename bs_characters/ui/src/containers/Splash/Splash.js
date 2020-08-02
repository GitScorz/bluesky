import React, { useEffect } from 'react';
import { connect } from 'react-redux';
import { makeStyles } from '@material-ui/core/styles';
import { login } from '../../actions/loginActions';

const useStyles = makeStyles(theme => ({
    wrapper: {
        '&::before': {
            content: '" "',
            background: theme.palette.secondary.main,
            height: 25,
            position: 'absolute',
            transform: 'rotate(1deg)',
            zIndex: -1,
            width: '100%',
            margin: '0 auto',
            left: 0,
            right: 0,
            marginTop: -42,
        },
        background: theme.palette.secondary.main,
        height: 380,
        width: '55%',
        position: 'absolute',
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        margin: 'auto',
        textAlign: 'center',
        fontSize: 30,
        color: theme.palette.text.main,
        zIndex: 1000,
        padding: 36,
    },
    innerBody: {
        lineHeight: '250%',
        transform: 'translate(0%, 50%)'
    },
    splashHeader: {
        fontSize: '1.5vw',
        display: 'block'
    },
    splashTip: {
        fontSize: '0.8vw'
    },
    splashTipHighlight: {
        fontWeight: 500,
        color: theme.palette.primary.main,
    },
}));

const Splash = (props) => {
    const classes = useStyles();

    const Bleh = (e) => {
        if (e.which == 1 || e.which == 13 || e.which == 32) {
            props.login();
        }
    }

    useEffect(() => {
        ['click', 'keydown', 'keyup'].forEach(function(e) {
            window.addEventListener(e, Bleh);
        });
      
        // returned function will be called on component unmount 
        return () => {
            ['click', 'keydown', 'keyup'].forEach(function(e) {
                window.removeEventListener(e, Bleh);
            });
        }
    }, []);

    return (
        <div className={classes.wrapper}>
            {
                <div className={classes.innerBody}>
                    <span className={classes.splashHeader}>Welcome To Blue Sky Roleplay</span>
                    <span className={classes.splashTip}>Press <span className={classes.splashTipHighlight}>ENTER</span> / <span className={classes.splashTipHighlight}>SPACE</span> / <span className={classes.splashTipHighlight}>LEFT MOUSE</span> To Continue</span>
                </div>
            }            
        </div>
    );
}

const mapStateToProps = (state) => {
    return {
        loading: state.loader.loading,
        message: state.loader.message
    }
}

export default connect(mapStateToProps, { login })(Splash);