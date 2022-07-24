import React, { useEffect, useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { makeStyles } from '@material-ui/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Recent from './recent';

const useStyles = makeStyles(theme => ({
    wrapper: {
        height: '100%',
        background: theme.palette.secondary.main,
    },
}));

export default connect()((props) => {
    const classes = useStyles();
    const navigate = useNavigate()
    const data = useSelector(state => state.data.data);
    const [expanded, setExpanded] = useState(-1);

    const [calls, setCalls] = useState([]);
    useEffect(() => {
        setCalls(data.calls);
    }, [data]);

    const handleClick = (index) => (event, newExpanded) => {
        setExpanded(newExpanded ? index : -1);
    };

    return (
        <div className={classes.wrapper}>
            {calls.sort((a, b) => b.time - a.time).map((call, key) => {
                return(
                    <Recent key={key} expanded={expanded} index={key} call={call} onClick={handleClick(key)} />
                )
            })}
        </div>
    );
});
