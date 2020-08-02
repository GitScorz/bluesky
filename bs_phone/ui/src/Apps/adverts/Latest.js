import React, { useEffect } from 'react';
import { connect, useSelector } from 'react-redux';
import { makeStyles, Tabs, Tab } from '@material-ui/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import './editor.css';
import Advert from './components/Advert';

const useStyles = makeStyles(theme => ({
    wrapper: {
        height: '100%',
        background: theme.palette.secondary.main,
		overflowY: 'auto',
		overflowX: 'hidden',
		'&::-webkit-scrollbar': {
			width: 3,
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
}));

export default connect()((props) => {
    const classes = useStyles();
    const adverts = useSelector(state => state.data.data.adverts);

    return (
        <div className={classes.wrapper}>
            {
                Object.keys(adverts).filter(a => a !== '0').sort((a, b) => {
                    let aItem = adverts[a];
                    let bItem = adverts[b];
                    return bItem.time - aItem.time;
                }).map((ad, i) => {
                    return <Advert key={`advert-${i}`} advert={adverts[ad]} del={props.del} />
                })
            }
        </div>
    );
});
