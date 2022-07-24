import React from 'react';
import { connect, useSelector } from 'react-redux';
import { makeStyles, Grid    } from '@material-ui/core';
import { Alert } from '@material-ui/lab';

import AppNotif from './components/AppNotif';
import Version from './components/Version';

const useStyles = makeStyles(theme => ({
    wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
    },
    listWrapper: {
		height: '95%',
		overflowY: 'auto',
		overflowX: 'hidden',
		flexDirection: 'column',
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
    listWrapperShort: {
		height: '86%',
		overflowY: 'auto',
		overflowX: 'hidden',
		flexDirection: 'column',
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
    error: {
		fontWeight: 'bold',
		height: '9%',
    }
}));

export default connect()((props) => {
    const classes = useStyles();
	const apps = useSelector(state => state.phone.apps);
	const installed = useSelector(state => state.data.data.installed);
    const settings = useSelector(state => state.data.data.settings);

    return (
        <div className={classes.wrapper}>
            {
                !settings.notifications ?
                <Alert variant='filled' severity='error' elevation={6} className={classes.error}>Notifications Are Currently Disabled System-wide, enable them to control on a per-app level.</Alert> : null
            }
            <Grid container spacing={0} className={settings.notifications ? classes.listWrapper : classes.listWrapperShort }>
                {
                    installed.map((a, index) => {
                        let app = apps[a];
                        if (app == null) return null;
                        return (<AppNotif key={index} app={app} />);
                    })
                }
            </Grid>
            <Version />
        </div>
    );
});
