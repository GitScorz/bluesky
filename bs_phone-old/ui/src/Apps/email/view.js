import React, { useEffect, useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import {
	makeStyles,
	Grid,
	AppBar,
	Menu,
	MenuItem,
	Avatar,
	Paper,
	IconButton,
} from '@material-ui/core';
import Moment from 'react-moment';
import { Sanitize } from '../../util/Parser';

import { ReadEmail, DeleteEmail, GPSRoute } from './action';
import { showAlert } from '../../actions/alertActions';

import ArrowBackIcon from '@material-ui/icons/ArrowBack';
import MoreVertIcon from '@material-ui/icons/MoreVert';
import GpsFixedIcon from '@material-ui/icons/GpsFixed';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
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
	titleBar: {
		padding: 15,
		textAlign: 'center',
	},
	senderBar: {
		padding: 15,
		textAlign: 'left',
		lineHeight: '30px',
		backgroundColor: theme.palette.secondary.light,
	},
	sendTime: {
		color: theme.palette.text.main,
	},
	expireBar: {
		padding: 15,
		textAlign: 'center',
		background: theme.palette.error.main,
	},
	emailTitle: {
		fontSize: 20,
		fontWeight: 'bold',
		width: '100%',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		whiteSpace: 'nowrap',
	},
	avatar: {
		color: theme.palette.text.light,
		height: 55,
		width: 55,
		position: 'relative',
		top: 0,
	},
	sender: {
		fontSize: 18,
		color: theme.palette.text.light,
	},
	recipient: {
		fontSize: 14,
		color: theme.palette.text.main,
	},
	emailBody: {
		padding: 20,
		background: theme.palette.secondary.dark,
	},
	gps: {
		position: 'absolute',
		right: 0,
		top: '40%',
	},
}));

const calendarStrings = {
	lastDay: '[Yesterday at] LT',
	sameDay: '[Today at] LT',
	nextDay: '[Tomorrow at] LT',
	lastWeek: '[last] dddd [at] LT',
	nextWeek: 'dddd [at] LT',
	sameElse: 'L',
};

export default connect(null, { showAlert, ReadEmail, DeleteEmail, GPSRoute })(
	(props) => {
		const classes = useStyles();
		const navigate = useNavigate()
		const { id } = props.match.params;
		const emails = useSelector((state) => state.data.data.emails);
		const email = emails.filter((e) => e._id === id)[0];

		useEffect(() => {
			let intrvl = null;

			if (email.unread) props.ReadEmail(email._id, emails);

			if (email.flags != null && email.flags.expires != null) {
				if (email.flags.expires < Date.now()) {
					props.showAlert('Email Has Expired');
					props.DeleteEmail(email._id);
					navigate(-1);
				} else {
					intrvl = setInterval(() => {
						if (email.flags.expires < Date.now()) {
							props.showAlert('Email Has Expired');
							props.DeleteEmail(email._id);
							navigate(-1);
						}
					}, 2500);
				}
			}
			return () => {
				clearInterval(intrvl);
			};
		}, []);

		const [open, setOpen] = useState(false);
		const [offset, setOffset] = useState({
			left: 110,
			top: 0,
		});

		const onClick = (e) => {
			e.preventDefault();
			setOffset({ left: e.clientX - 2, top: e.clientY - 4 });
			setOpen(true);
		};

		const onClose = () => {
			setOpen(false);
		};

		const deleteEmail = () => {
			onClose();
			props.showAlert('Email Deleted');
			props.DeleteEmail(email._id);
			navigate(-1);
		};

		const gpsClicked = () => {
			if (email.flags != null && email.flags.location != null)
				props.GPSRoute(email._id, email.flags.location);
		};

		return (
			<div className={classes.wrapper}>
				<AppBar position="static">
					<Grid container className={classes.titleBar}>
						<Grid item xs={2} style={{ textAlign: 'left' }}>
							<IconButton onClick={() => navigate(-1)}>
								<ArrowBackIcon />
							</IconButton>
						</Grid>
						<Grid
							item
							xs={8}
							className={classes.emailTitle}
							title={email.subject}
						>
							{email.subject}
						</Grid>
						<Grid item xs={2} style={{ textAlign: 'right' }}>
							<IconButton onClick={onClick}>
								<MoreVertIcon />
							</IconButton>
						</Grid>
					</Grid>
					<Grid container className={classes.senderBar}>
						<Grid item xs={2}>
							<Avatar className={classes.avatar}>
								{email.sender.charAt(0)}
							</Avatar>
						</Grid>
						<Grid
							item
							xs={6}
							style={{
								overflow: 'hidden',
								whiteSpace: 'nowrap',
								textOverflow: 'ellipsis',
							}}
						>
							<div
								className={classes.sender}
								title={email.sender}
							>
								{email.sender.split('@')[0]}
							</div>
							<div className={classes.recipient}>to: me</div>
						</Grid>
						<Grid
							item
							xs={4}
							style={{ textAlign: 'right', position: 'relative' }}
						>
							<span className={classes.sendTime}>
								<Moment interval={60000} fromNow>
									{+email.time}
								</Moment>
							</span>
							{email.flags != null &&
							email.flags.location != null ? (
								<IconButton
									className={classes.gps}
									onClick={gpsClicked}
								>
									<GpsFixedIcon />
								</IconButton>
							) : null}
						</Grid>
					</Grid>
				</AppBar>
				<Menu
					anchorReference="anchorPosition"
					anchorPosition={offset}
					keepMounted
					open={open}
					onClose={onClose}
				>
					<MenuItem onClick={deleteEmail}>Delete Email</MenuItem>
				</Menu>
				{email.flags != null && email.flags.expires != null ? (
					<AppBar className={classes.expireBar} position="static">
						<div>
							Email expires{' '}
							<Moment
								interval={10000}
								calendar={calendarStrings}
								fromNow
							>
								{+email.flags.expires}
							</Moment>
						</div>
					</AppBar>
				) : null}
				<Paper
					className={classes.emailBody}
					style={{
						height:
							email.flags != null && email.flags.expires != null
								? '74.5%'
								: '81%',
					}}
				>
					{Sanitize(email.body)}
				</Paper>
			</div>
		);
	},
);
