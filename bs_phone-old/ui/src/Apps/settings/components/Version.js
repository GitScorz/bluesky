import React, { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { connect } from 'react-redux';
import { makeStyles } from '@material-ui/core';

const useStyles = makeStyles(theme => ({
	phoneVers: {
		height: 40,
		lineHeight: '40px',
		textAlign: 'center',
		fontFamily: 'Stylized',
		width: '100%',
		userSelect: 'none',
		'-webkit-user-select': 'none',
	},
}));

export default connect()((props) => {
    const classes = useStyles();
    const navigate = useNavigate()

	useEffect(() => {
		return () => {
			clearTimeout(clickHoldTimer);
		};
	}, []);

	let clickHoldTimer = null;
	const versionStart = () => {
		clickHoldTimer = setTimeout(() => {
			navigate(`/apps/settings/software`);
		}, 2000);
	};

	const versionEnd = () => {
		clearTimeout(clickHoldTimer);
    };
    
    return (
        <div
            className={classes.phoneVers}
            onMouseDown={versionStart}
            onMouseUp={versionEnd}
            onMouseLeave={versionEnd}
        >
            Pixel OS v1.0
        </div>
    );
});
