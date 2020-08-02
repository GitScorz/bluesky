import React, { useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { makeStyles, Grid } from '@material-ui/core';

import CustomColor from './components/CustomColor';
import Version from './components/Version';
import { UpdateSetting } from './actions';

const useStyles = makeStyles(theme => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		textAlign: 'center',
		padding: '0 2px',
	},
	colorsList: {
		height: '95%',
		overflowY: 'auto',
		overflowX: 'hidden',
		margin: '0 !important',
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
}));

export default connect(null, { UpdateSetting })((props) => {
    const classes = useStyles();
    const settings = useSelector(state => state.data.data.settings);

	const onAccentSave = hex => {
		props.UpdateSetting('colors', {
			...settings.colors,
			accent: hex
		});
	};

	return (
		<div className={classes.wrapper}>
			<Grid container className={classes.colorsList}>
				<Grid item xs={12}>
					<CustomColor label='Accent Color' color={settings.colors.accent} onSave={onAccentSave} />
				</Grid>
			</Grid>
			<Version />
		</div>
	);
});
