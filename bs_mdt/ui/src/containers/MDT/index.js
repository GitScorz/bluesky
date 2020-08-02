import React from 'react';
import { connect } from 'react-redux';
import { makeStyles } from '@material-ui/core';
import Iframe from 'react-iframe';

const useStyles = makeStyles(theme => ({
    wrapper: {
        display: 'block',
        height: '85%',
        width: '95%',
        position: 'absolute',
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        margin: 'auto',
        border: 'none'
    },
}));

export default connect()(props => {
    const classes = useStyles();

    return (
        <Iframe
            url="http://71.15.161.53:3000"
            width="100%"
            height="100%"
            className={classes.wrapper}
            display="initial"
            position="absolute"
        />
    );
});
