import React from 'react';
import { connect } from 'react-redux';
import { makeStyles } from '@material-ui/core/styles';
import Loader from '../../components/Loader/Loader';

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
}));

const Splash = (props) => {
    const classes = useStyles();

    return (
        <div className={classes.wrapper}>
            {
                props.loading ?
                <div>
                    <Loader />
                    <div className="label">{props.message}</div>
                </div>:
                null
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

export default connect(mapStateToProps)(Splash);