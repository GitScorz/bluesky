import React, { useEffect, useState } from 'react';
import { makeStyles, useTheme, LinearProgress } from '@material-ui/core';
import Particles from 'react-tsparticles';
import GlitchClip from 'react-glitch-effect/core/Clip';
import { Dot } from 'react-animated-dots';
import { useSelector } from 'react-redux';
import ReactPlayer from 'react-player';

import logo from '../../logo.png';

const useStyles = makeStyles((theme) => ({
	background: {
		backgroundColor: theme.palette.secondary.dark,
		backgroundSize: 'cover',
		minHeight: '100vh',
		display: 'flex',
		overflow: 'hidden',
		justifyContent: 'center',
		alignItems: 'center',
	},
	particles: {
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		zIndex: 9,
	},
	logo: {
		position: 'absolute',
		width: 'fit-content',
		height: 'fit-content',
		textAlign: 'center',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		zIndex: 10,
		pointerEvents: 'none',
	},
	logoImg: {
		width: '30%',
	},
	text: {
		color: theme.palette.text.main,
		fontSize: '3em',
		textShadow: '2px 2px 8px rgba(0, 0, 0, 0.5)',
		fontFamily: 'Stylized',
		marginTop: 25,
	},
	hightlight: {
		color: '#0ad3ac',
	},
	prog: {
		display: 'block',
		width: '100%',
		position: 'absolute',
		bottom: 0,
	},
	effect: {
		position: 'absolute',
		width: '100%',
		height: '100%',
	},
	bar: {
		height: 10,
	},
	dot1: {
		color: theme.palette.primary.main,
	},
	dot2: {
		color: theme.palette.text.main,
	},
	dot3: {
		color: '#0ad3ac',
	},
	domain: {
		position: 'absolute',
		top: '1%',
		right: '1%',
		fontFamily: 'Stylized',
		fontSize: 13,
	},
	discord: {
		position: 'absolute',
		top: '1%',
		left: '1%',
		fontFamily: 'Stylized',
		fontSize: 13,
	},
	slash: {
		fontFamily: 'fantasy',
		fontSize: 17,
	},
	stageText: {
		position: 'absolute',
		left: '1%',
		bottom: "300%",
	},
	completedStage: {
		color: '#ffffff',
		fontWeight: 'bold',
		fontSize: 20,
		fontFamily: 'Stylized',
		'&::after': {
			color: '#0ad3ac',
			content: '": COMPLETED,"',
			marginRight: 24,
		}
	},
	currentStage: {
		color: '#ffffff',
		fontWeight: 'bold',
		fontSize: 20,
		fontFamily: 'Stylized',
		'&::after': {
			color: theme.palette.primary.main,
			content: '": IN PROGRESS,"',
			marginRight: 24,
		}
	}
}));

export default () => {
	const classes = useStyles();

	const test = useSelector((state) => state.load.test);
	const pct = Math.min(test.current / test.total) * 100;
	const completed = useSelector((state) => state.load.completed);
	const current = useSelector((state) => state.load.currentStage);

	return (
		<div className={classes.background}>
			<Particles
				className={classes.particles}
				options={{
					particles: {
						number: {
							value: 300,
							density: {
								enable: true,
								value_area: 2500,
							},
						},
						line_linked: {
							enable: true,
							opacity: 0.05,
							color: '#00d8ff',
						},
						move: {
							speed: 1.25,
						},
						size: {
							value: 3,
							random: true,
						},
						color: '#00d8ff',
						opacity: {
							anim: {
								enable: true,
								speed: 1,
								opacity_min: 0.15,
							},
						},
					},
					interactivity: {
						events: {
							onclick: {
								enable: true,
								mode: 'push',
							},
						},
						modes: {
							push: {
								particles_nb: 1,
							},
						},
					},
				}}
			/>
			<div className={classes.logo}>
				<img src={logo} className={classes.logoImg} />
				<GlitchClip duration={'5s'}>
					<div className={classes.text}>
						Loading Into{' '}
						<span className={classes.hightlight}>
							React Roleplay
						</span>
						<Dot className={classes.dot1}>.</Dot>
						<Dot className={classes.dot2}>.</Dot>
						<Dot className={classes.dot3}>.</Dot>
					</div>
				</GlitchClip>
			</div>
			<div className={classes.domain}>blueskyrp.com</div>
			<div className={classes.discord}>
				blueskyrp.com<span className={classes.slash}>/</span>discord
				<span className={classes.slash}>/</span>invite
				<span className={classes.slash}>/</span>general
			</div>
			<div className={classes.prog}>
				<div className={classes.stageText}>
					{
						Object.keys(completed).map(val => {
							return(
								<span className={classes.completedStage}>{val}</span>
							);
						})
					}
					{current != null ? <span className={classes.currentStage}>{current}</span> : (
						pct >= 100 ?
						<span className={classes.currentStage}>Loading Models</span> : null
					)}
				</div>
				<LinearProgress
					className={classes.bar}
					variant="determinate"
					value={pct <= 100 ? pct : 100}
				/>
			</div>
			<ReactPlayer
				url="https://blueskyrp.com/uploads/loadscreen.mp4"
				width="100vw"
				height="100%"
				controls={false}
				loop
				playing
				muted
				/>
		</div>
	);
};
