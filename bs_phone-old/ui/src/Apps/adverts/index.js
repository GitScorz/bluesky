import React, { useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { makeStyles, withStyles, Tabs, Tab } from '@material-ui/core';

import RestoreIcon from '@material-ui/icons/Restore';
import CategoryIcon from '@material-ui/icons/Category';

import Latest from './Latest';
import Categories from './Categories';
import ActionButtons from './ActionButtons';
import { DeleteAdvert, BumpAdvert } from './action';

const YPTabs = withStyles((theme) => ({
	root: {
		borderBottom: '1px solid #f9a825',
	},
	indicator: {
		backgroundColor: '#f9a825',
	},
}))((props) => <Tabs {...props} />);

const YPTab = withStyles((theme) => ({
	root: {
		width: '50%',
		'&:hover': {
			color: '#f9a825',
			transition: 'color ease-in 0.15s',
		},
		'&$selected': {
			color: '#f9a825',
			transition: 'color ease-in 0.15s',
		},
		'&:focus': {
			color: '#f9a825',
			transition: 'color ease-in 0.15s',
		},
	},
	selected: {},
}))((props) => <Tab {...props} />);

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	content: {
		height: '90.5%',
		padding: '0 10px',
		overflow: 'hidden',
	},
	tabPanel: {
		height: '100%',
	},
	add: {
		position: 'absolute',
		bottom: '12%',
		right: '10%',
		backgroundColor: '#f9a825',
		opacity: 0.3,
		'&:hover': {
			backgroundColor: '#f9a825',
			opacity: 1,
			transition: 'opacity ease-in 0.3s',
		},
	},
	delete: {
		position: 'absolute',
		bottom: '19%',
		right: '10%',
		backgroundColor: theme.palette.error.main,
		opacity: 0.3,
		'&:hover': {
			backgroundColor: theme.palette.error.main,
			opacity: 1,
			transition: 'opacity ease-in 0.3s',
		},
	},
	bump: {
		position: 'absolute',
		bottom: '26%',
		right: '10%',
		backgroundColor: theme.palette.error.light,
		opacity: 0.3,
		'&:hover': {
			backgroundColor: theme.palette.error.light,
			opacity: 1,
			transition: 'opacity ease-in 0.3s',
		},
	},
}));

export default connect(null, { DeleteAdvert, BumpAdvert })((props) => {
	const classes = useStyles();
	const navigate = useNavigate()
	const myAdvertId = useSelector((state) => state.data.data.myData.sid);
	const myAdvert = useSelector((state) => state.data.data.adverts)[myAdvertId];

	const [tab, setTab] = useState(0);
	const [del, setDel] = useState(false);

	const handleTabChange = (event, tab) => {
		setTab(tab);
	};

	return (
		<div className={classes.wrapper}>
			<div className={classes.tabs}>
				<YPTabs
					value={tab}
					onChange={handleTabChange}
					scrollButtons="off"
					centered
				>
					<YPTab label="Latest" icon={<RestoreIcon />} />
					<YPTab label="Categories" icon={<CategoryIcon />} />
				</YPTabs>
			</div>
			<div className={classes.content}>
				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={tab !== 0}
					id="latest"
				>
					{tab === 0 && <Latest del={del} />}
				</div>
				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={tab !== 1}
					id="categories"
				>
					{tab === 1 && <Categories />}
				</div>
			</div>
			<ActionButtons />
		</div>
	);
});
