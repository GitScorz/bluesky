import React from 'react';
import { connect, useSelector } from 'react-redux';
import { makeStyles, Avatar, Paper, Grid } from '@material-ui/core';
import { Person as PersonIcon } from '@material-ui/icons';

import Version from './components/Version';

const useStyles = makeStyles(theme => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		position: 'relative',
	},
	dataWrapper: {
		height: '95%',
		overflowY: 'auto',
		overflowX: 'hidden',
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
	avatar: {
		height: 100,
		width: 100,
		color: theme.palette.text.light,
		background: theme.palette.primary.main,
		display: 'block',
		textAlign: 'center',
		margin: 'auto',
		marginTop: '-20%',
	},
	avatarIcon: {
		fontSize: 55,
		position: 'absolute',
		left: 0,
		right: 0,
		bottom: 0,
		top: 0,
		margin: 'auto',
	},
	contactHeader: {
		padding: 20,
		background: theme.palette.secondary.dark,
		width: '100%',
		margin: '70px auto 25px auto',
		textAlign: 'center',
	},
	profileSection: {
		padding: 20,
		background: theme.palette.secondary.dark,
		width: '100%',
		margin: 'auto',
		marginBottom: 25,
		'&::last-child': {
			marginBottom: 'none',
		},
	},
	name: {
		fontSize: 30,
		color: theme.palette.primary.main,
	},
	number: {
		fontSize: 15,
		color: theme.palette.text.main,
	},
	contactButtons: {
		marginTop: 25,
	},
	contactButton: {
		fontSize: 22,
		'&:hover': {
			color: theme.palette.primary.main,
			transition: 'color 0.15s ease-in',
			cursor: 'pointer',
		},
	},
	actions: {
		background: theme.palette.secondary.dark,
		borderRadius: 10,
		fontSize: 15,
		fontWeight: 'bold',
		margin: '0 auto 25px auto',
		width: '90%',
	},
	sectionHeader: {
		fontSize: 24,
		fontFamily: 'Stylized',
		color: theme.palette.text.light,
		padding: 10,
		borderBottom: `1px solid ${theme.palette.primary.main}`,
	},
	sectionBody: {
		fontSize: 16,
	},
	bodyItem: {
		padding: 10,
	},
	highlight: {
		fontWeight: 'bold',
		color: theme.palette.primary.main,
	},
}));

export default connect()(props => {
	const classes = useStyles();
	const apps = useSelector(state => state.phone.apps);
	const myData = useSelector(state => state.data.data.myData);

	return (
		<div className={classes.wrapper}>
			<div className={classes.dataWrapper}>
				<Paper className={classes.contactHeader}>
					<Avatar className={classes.avatar}>
						<PersonIcon className={classes.avatarIcon} />
					</Avatar>
					<div
						className={classes.name}
					>{`${myData.name.first} ${myData.name.last}`}</div>
					<div className={classes.number}>{myData.number}</div>
				</Paper>
				<Paper className={classes.profileSection}>
					<div className={classes.sectionHeader}>
						Personal Details
					</div>
					<div className={classes.sectionBody}>
						<div className={classes.bodyItem}>
							<span className={classes.highlight}>
								Server ID:{' '}
							</span>
							{myData.sid}
						</div>
						<div className={classes.bodyItem}>
							<span className={classes.highlight}>
								Citizen ID:{' '}
							</span>
							{myData.cid}
						</div>
					</div>
				</Paper>
				<Paper className={classes.profileSection}>
					<div className={classes.sectionHeader}>
						Application Aliases
					</div>
					<div className={classes.sectionBody}>
						{Object.keys(myData.aliases).map((app, i) => {
							return (
								<div key={i} className={classes.bodyItem}>
									<span className={classes.highlight}>
										{apps[app].label}:
									</span>
									{myData.aliases[app]}
								</div>
							);
						})}
					</div>
				</Paper>
			</div>
			<Version />
		</div>
	);
});
