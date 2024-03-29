import React, { useEffect, useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { makeStyles, TextField, Grid } from '@material-ui/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import App from './App';
import banner from '../../banner.png';

const useStyles = makeStyles(theme => ({
    wrapper: {
        height: '100%',
        background: theme.palette.secondary.main,
    },
    search: {
        height: '10%',
        padding: '0 10px',
    },
	searchInput: {
		width: '100%',
        height: '100%',
    },
    appList: {
		maxHeight: '90%',
        padding: '0 10px',
    }
}));

export default connect()((props) => {
    const classes = useStyles();
    const navigate = useNavigate()
    const apps = useSelector(state => state.phone.apps);
	const installed = useSelector(state => state.data.data.installed);

    const [searchVal, setSearchVal] = useState('');
	const onSearchChange = (e) => {
		setSearchVal(e.target.value);
    };

    return (
        <div className={classes.wrapper}>
        <img className={classes.phoneImg} src={banner}/>
            <div className={classes.search}>
                <TextField
                    className={classes.searchInput}
                    label="Search For App"
                    value={searchVal}
                    onChange={onSearchChange}
                />
            </div>
            <Grid className={classes.appList} container spacing={2} justify="flex-start">
                {
                    Object.keys(apps).map((entry, i) => {
                        let app = apps[entry];
                        if ((app.label.toUpperCase().includes(searchVal.toUpperCase()) || searchVal === '') && !installed.includes(entry)) {
                            return(<App key={i} appKey={entry} app={app} />)
                        } else {
                            return null;
                        }
                    })
                }
            </Grid>
        </div>
    );
});
