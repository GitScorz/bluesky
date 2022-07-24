import React from 'react';
import { connect, useSelector } from 'react-redux';
import { useNavigate } from "react-router-dom";
import { Grid, makeStyles } from '@material-ui/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles(theme => ({
    footer: {
        background: '#000000',
        height: '7%',
        borderBottomLeftRadius: 30,
        borderBottomRightRadius: 30,
        textAlign: 'center',
        color: '#ffffff',
        lineHeight: '65px',
        fontSize: '20px',
    },
    fButton: {
        '&:hover': {
            transition: 'color ease-in 0.15s',
            color: theme.palette.primary.main
        }
    }
}));

export default connect()(props => {
    const classes = useStyles();
    const navigate = useNavigate()
	const expanded = useSelector((state) => state.phone.expanded);

    const ToggleExpando = () => {
        props.dispatch({
            type: 'TOGGLE_EXPANDED'
        })
    }

    const GoHome = () => {
        navigate('/');
    }

    const GoBack = () => {
        navigate(-1);
    }

    return (
        <Grid container className={classes.footer}>
            <Grid item xs={4} className={classes.fButton} onClick={ToggleExpando}>
                <FontAwesomeIcon icon={expanded ? 'fa-solid fa-minimize' : 'fa-solid fa-maximize'} />
            </Grid>
            <Grid item xs={4} className={classes.fButton} onClick={GoHome}>
                <FontAwesomeIcon icon="fa-solid fa-circle" />
            </Grid>
            <Grid item xs={4} className={classes.fButton} onClick={GoBack}>
                <FontAwesomeIcon icon="fa-solid fa-chevron-left" />
            </Grid>
        </Grid>
    );
});
