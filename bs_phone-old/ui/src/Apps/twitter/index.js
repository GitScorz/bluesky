import React, { useEffect } from 'react';
import { connect, useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles(theme => ({
    wrapper: {
        height: '100%',
        background: theme.palette.secondary.main,
    },
}));

export default connect()((props) => {
    const classes = useStyles();

    useEffect(() => {
    }, []);

    return (
        <div className={classes.wrapper}>
            This is the phone, LUL
        </div>
    );
});
