import React, { useEffect, useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import {
	makeStyles,
	withStyles,
	Menu,
	MenuItem,
	TextField,
	Slide,
	Avatar,
	Badge
} from '@material-ui/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import {
	addToHome,
	removeFromHome,
	addToDock,
	removeFromDock,
} from '../../actions/homeActions';
import { uninstall } from '../../Apps/store/action';
import { showAlert } from '../../actions/alertActions';
import {
	dismissNotif,
	openedApp,
	dismissNotifAll,
} from '../../actions/notificationAction';

const useStyles = makeStyles(theme => ({
	wrapper: {
		height: '100%',
	},
	search: {
		height: '12.5%',
		padding: 25,
	},
	searchInput: {
		width: '100%',
		height: '100%',
	},
	grid: {
		display: 'flex',
		height: '87.5%',
		padding: '0 10px',
		flexWrap: 'wrap',
		justifyContent: 'start',
		alignContent: 'flex-start',
		overflowX: 'hidden',
		overflowY: 'auto',
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
	appBtn: {
		width: '25%',
		display: 'inline-block',
		textAlign: 'center',
		height: 'fit-content',
		padding: 10,
		borderRadius: 10,
		position: 'relative',
		'&:hover': {
			transition: 'background ease-in 0.15s',
			background: `${theme.palette.primary.main}40`,
			cursor: 'pointer',
		},
	},
	appContext: {
		width: '25%',
		display: 'inline-block',
		textAlign: 'center',
		height: 'fit-content',
		padding: 10,
		borderRadius: 10,
		position: 'relative',
		transition: 'background ease-in 0.15s',
		background: `${theme.palette.primary.main}40`,
	},
	appIcon: {
		fontSize: 35,
		width: 60,
		height: 60,
		margin: 'auto',
		color: '#fff',
	},
	appLabel: {
		fontSize: 16,
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		textShadow: '0px 0px 5px #000000',
		fontWeight: 'normal',
		marginTop: 10,
	},
	menuClose: {
		position: 'fixed',
		top: 0,
		left: 0,
		height: '-webkit-fill-available',
		width: '-webkit-fill-available',
	},
	menu: {
		padding: 5,
		background: theme.palette.secondary.main,
		zIndex: 999,
		fontSize: 18,
		margin: 5,
		width: '40%',
	},
}));

const NotifCount = withStyles(theme => ({
	root: {
		width: 24,
		height: 24,
		fontSize: 16,
		lineHeight: '24px',
		color: '#fff',
		background: '#ff0000',
	},
}))(Avatar);

export default connect(null, {
	showAlert,
	dismissNotif,
	openedApp,
	dismissNotifAll,
	uninstall,
	addToHome,
	removeFromHome,
	addToDock,
	removeFromDock,
})(props => {
	const classes = useStyles();
	let navigate = useNavigate();
	const apps = useSelector(state => state.phone.apps);
	const installed = useSelector(state => state.data.data.installed);
	const homeApps = useSelector(state => state.data.data.home);
	const notifications = useSelector(
		state => state.notifications.notifications,
	);

	const [open, setOpen] = useState(false);
	useEffect(() => {
		setOpen(true);
		return () => {
			setOpen(false);
		};
	}, []);

	const [searchVal, setSearchVal] = useState('');
	const [filteredApps, setFilteredApps] = useState(
		Object.keys(apps).length > 0 ? installed : Array(),
	);
	const [contextApp, setContextApp] = useState(null);
	const [offset, setOffset] = useState({
		left: 110,
		top: 0,
	});

	useEffect(() => {
		if (Object.keys(apps).length > 0)
			setFilteredApps(
				installed.filter(app =>
					apps[app].label
						.toUpperCase()
						.includes(searchVal.toUpperCase()),
				),
			);
	}, [searchVal, installed, apps]);

	const onClick = app => {
		props.openedApp(app);
		navigate(`/apps/${app}`);
	};

	const openApp = () => {
		props.openedApp(contextApp);
		navigate(`/apps/${contextApp}`);
	};

	const onRightClick = (e, app) => {
		e.preventDefault();
		setOffset({ left: e.clientX - 2, top: e.clientY - 4 });
		if (app != null) setContextApp(app);
	};

	const closeContext = e => {
		if (e != null) e.preventDefault();
		setContextApp(null);
	};

	const addToHome = () => {
		props.addToHome(contextApp);
		props.showAlert(`${apps[contextApp].label} Added To Home Screen`);
		closeContext();
	};

	const uninstallApp = () => {
		props.uninstall(contextApp);
		closeContext();
	};

	const onSearchChange = e => {
		setSearchVal(e.target.value);
	};

	return (
		<Slide in={open} direction="up">
			<div className={classes.wrapper}>
				<div className={classes.search}>
					<TextField
						className={classes.searchInput}
						label="Search For App"
						value={searchVal}
						onChange={onSearchChange}
					/>
				</div>
				<div className={classes.grid}>
					{filteredApps
						.sort((a, b) => {
							if (apps[a].label > apps[b].label) return 1;
							else if (apps[a].label < apps[b].label) return -1;
							else return 0;
						})
						.map((app, i) => {
							let data = apps[app];
							let nCount = notifications.filter(n => n.app == app)
								.length;
							return (
								<div
									key={i}
									className={
										contextApp === app
											? classes.appContext
											: classes.appBtn
									}
									title={data.label}
									onClick={() => onClick(app)}
									onContextMenu={e => onRightClick(e, app)}
								>
								{
									nCount > 0 ?
									<Badge
										overlap="circle"
										anchorOrigin={{
											vertical: 'bottom',
											horizontal: 'right',
										}}
										badgeContent={
											<NotifCount style={{border: `2px solid ${data.color}`}}>{nCount}</NotifCount>
										}
									>
										<Avatar
											variant="rounded"
											className={classes.appIcon}
											style={{background: `${data.color}`}}
										>
											<FontAwesomeIcon icon={data.icon} />
										</Avatar>
									</Badge> :
									<Avatar
										variant="rounded"
										className={classes.appIcon}
										style={{background: `${data.color}`}}
									>
										<FontAwesomeIcon icon={data.icon} />
									</Avatar>
								}
									<div className={classes.appLabel}>
										{data.label}
									</div>
								</div>
							);
						})}
				</div>
				{contextApp != null ? (
					<Menu
						keepMounted
						onContextMenu={closeContext}
						open={!!contextApp}
						onClose={closeContext}
						anchorReference="anchorPosition"
						anchorPosition={offset}
						style={{ zIndex: 9999 }}
					>
						<MenuItem disabled>{apps[contextApp].label}</MenuItem>
						<MenuItem
							onClick={addToHome}
							disabled={
								homeApps.filter(app => app == contextApp)
									.length > 0
							}
						>
							Add To Home
						</MenuItem>
						<MenuItem onClick={openApp}>
							Open {apps[contextApp].label}
						</MenuItem>
						{apps[contextApp].canUninstall ? (
							<MenuItem onClick={uninstallApp}>
								Uninstall {apps[contextApp].label}
							</MenuItem>
						) : null}
					</Menu>
				) : null}
			</div>
		</Slide>
	);
});
