import React, { useState, useEffect } from 'react';
import { connect, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { makeStyles, AppBar, Grid, Chip, IconButton } from '@material-ui/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
const processString = require('react-process-string');
import { CopyToClipboard } from 'react-copy-to-clipboard';
import ReactPlayer from 'react-player';
import Moment from 'react-moment';
import NumberFormat from 'react-number-format';

import { Sanitize } from '../../util/Parser';
import { Categories } from './data';
import { createCall } from '../phone/action';
import ActionButtons from './ActionButtons';

export default connect(null, { createCall })((props) => {
	const navigate = useNavigate()
	const { id } = props.match.params;
	const myId = useSelector((state) => state.data.data.myData.sid);
	const adverts = useSelector((state) => state.data.data.adverts);
	const advert = useSelector((state) => state.data.data.adverts)[+id];

	useEffect(() => {
        console.log(JSON.stringify(adverts, false, 4));
        console.log(JSON.stringify(advert, false, 4));
		if (adverts != null && advert == null) history.replace('/apps/adverts');
	}, [adverts, advert]);

	const cats = Categories.filter((cat) => {
		return advert != null ? advert.categories.includes(cat.label) : Array();
	});
	const callData = useSelector((state) => state.call.call);

	const callAdvert = () => {
        if (advert.id === myId) return;
		if (callData == null) {
			props.createCall(advert.number);
			navigate(`/apps/phone/call/${advert.number}`);
		}
	};

	const textAdvert = () => {
        if (advert.id === myId) return;
		navigate(`/apps/messages/convo/${advert.number}`);
	};

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
		header: {
			background: '#f9a825',
			fontSize: 20,
			padding: 15,
			lineHeight: '45px',
		},
		subHeader: {
			padding: '7px 15px',
			backgroundColor: '#a37225',
		},
		subsubHeader: {
			padding: '7px 15px',
			backgroundColor: theme.palette.secondary.light,
		},
		body: {
			padding: '10px 20px',
			height: '70%',
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
		input: {
			width: '100%',
			padding: '0 10px',
		},
		messageImg: {
			display: 'block',
			maxWidth: 200,
		},
		copyableText: {
			color: theme.palette.primary.main,
			textDecoration: 'underline',
			'&:hover': {
				transition: 'color ease-in 0.15s',
				color: theme.palette.text.main,
				cursor: 'pointer',
			},
		},
		priceValue: {
			'&::before': {
				content: '"$"',
				color: theme.palette.error.dark,
				marginRight: 2,
			},
			fontSize: 20,
		},
		category: {
			'&:hover': {
				filter: 'brightness(0.8)',
				transition: 'filter ease-in 0.15s',
				cursor: 'pointer',
			},
		},
	}));
	const classes = useStyles();

	const categoryClick = (category) => {
		navigate(`/apps/adverts/category-view/${category}`);
	};

	const config = [
		{
			regex: /(http|https):\/\/(\S+)\.([a-z]{2,}?)(.*?)( |\,|$|\.)(jpg|png|gif)/gim,
			fn: (key, result) => (
				<CopyToClipboard
					text={result[0]}
					key={key}
					onCopy={() => props.showAlert('Link Copied To Clipboard')}
				>
					<img
						key={key}
						className={classes.messageImg}
						src={result[0]}
					/>
				</CopyToClipboard>
			),
		},
		{
			regex: /(http|https):\/\/(\S+)\.([a-z]{2,}?)(.*?)( |\,|$|\.)(mp4)/gim,
			fn: (key, result) => (
				<div>
					<ReactPlayer
						key={key}
						volume={0.25}
						width="100%"
						controls={true}
						url={`${result[0]}`}
					/>
				</div>
			),
		},
		{
			regex: /(http|https):\/\/(\S+)\.([a-z]{2,}?)(.*?)( |\,|$|\.)/gim,
			fn: (key, result) => (
				<CopyToClipboard
					text={result[0]}
					key={key}
					onCopy={() => props.showAlert('Link Copied To Clipboard')}
				>
					<a className={classes.copyableText}>{result.input}</a>
				</CopyToClipboard>
			),
		},
		{
			regex: /(\S+)\.([a-z]{2,}?)(.*?)( |\,|$|\.)/gim,
			fn: (key, result) => (
				<CopyToClipboard
					text={result[0]}
					key={key}
					onCopy={() => props.showAlert('Link Copied To Clipboard')}
				>
					<a className={classes.copyableText}>{result.input}</a>
				</CopyToClipboard>
			),
		},
	];

	return (
		<div className={classes.wrapper}>
			{advert != null && (
				<>
					<AppBar position="static" className={classes.header}>
						{advert.title}
					</AppBar>
					<AppBar position="static" className={classes.subHeader}>
						<Grid container>
							<Grid item xs={6}>
								{advert.author}
							</Grid>
							<Grid item xs={6} style={{ textAlign: 'right' }}>
								<Moment
									className={classes.postedTime}
									interval={60000}
									fromNow
									date={+advert.time}
								/>
							</Grid>
						</Grid>
					</AppBar>
					<AppBar position="static" className={classes.subsubHeader}>
						<Grid container>
							<Grid
								item
								xs={9}
								style={{
									textAlign: 'left',
									lineHeight: '51px',
								}}
							>
								{advert.price != null && advert.price !== '' ? (
									<NumberFormat
										className={classes.priceValue}
										value={advert.price}
										displayType={'text'}
										thousandSeparator={true}
									/>
								) : (
									<span>Price Negotiable</span>
								)}
							</Grid>
							<Grid item xs={3} style={{ textAlign: 'right' }}>
								<IconButton onClick={callAdvert} disabled={advert.id === myId}>
									<FontAwesomeIcon icon={['fad', 'phone']} />
								</IconButton>
								<IconButton onClick={textAdvert} disabled={advert.id === myId}>
									<FontAwesomeIcon icon={['fad', 'sms']} />
								</IconButton>
							</Grid>
						</Grid>
					</AppBar>
					<div className={classes.body}>
						{advert.full != null && advert.full != ''
							? Sanitize(processString(config)(advert.full))
							: advert.short}
					</div>
					<div className={classes.input}>
						<Grid container>
							<Grid
								item
								xs={12}
								style={{ textAlign: 'center', padding: 10 }}
							>
								{cats.map((cat, i) => {
									return (
										<Chip
											key={`advert-cat-${i}`}
											className={classes.category}
											size="small"
											style={{
												margin: 5,
												backgroundColor: cat.color,
											}}
											label={cat.label}
											onClick={() =>
												categoryClick(cat.label)
											}
										/>
									);
								})}
							</Grid>
						</Grid>
					</div>
					{myId === advert.id && <ActionButtons />}
				</>
			)}
		</div>
	);
});
