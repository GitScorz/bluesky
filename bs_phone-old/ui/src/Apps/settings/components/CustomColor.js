import React, { useState } from 'react';
import { connect, useSelector } from 'react-redux';
import {
	makeStyles,
	Grid,
	Paper,
	Avatar,
} from '@material-ui/core';
import { ChevronRight, Colorize } from '@material-ui/icons';

import { Modal, ColorPicker } from '../../../components';

const useStyles = makeStyles(theme => ({
	div: {
		width: '100%',
		textDecoration: 'none',
		whiteSpace: 'nowrap',
		verticalAlign: 'middle',
		userSelect: 'none',
		'-webkit-user-select': 'none',
		textAlign: 'left',
	},
	rowWrapper: {
		background: theme.palette.secondary.main,
		padding: '25px 12px',
		width: '100%',
		height: 'fit-content',
		userSelect: 'none',
		'-webkit-user-select': 'none',
		'&:hover': {
			background: theme.palette.secondary.light,
			transition: 'background ease-in 0.15s',
			cursor: 'pointer',
		},
	},
	avatar: {
		color: theme.palette.text.dark,
		height: 55,
		width: 55,
		fontSize: 35,
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
	},
	avatarIcon: {
		fontSize: 35,
		color: theme.palette.text.light,
	},
	sectionHeader: {
		display: 'block',
		fontSize: 20,
		fontWeight: 'bold',
		lineHeight: '35px',
	},
	arrow: {
		fontSize: 35,
		position: 'absolute',
		top: 0,
		bottom: 0,
		right: 0,
		margin: 'auto',
	},
	selectedItem: {
		color: theme.palette.text.main,
		fontWeight: 'bold',
	},
	buttons: {
		width: '100%',
		display: 'flex',
		margin: 'auto',
	},
	buttonNeg: {
		width: '-webkit-fill-available',
		padding: 20,
		color: theme.palette.error.main,
		'&:hover': {
			backgroundColor: `${theme.palette.error.main}14`,
		},
	},
	buttonPos: {
		width: '-webkit-fill-available',
		padding: 20,
		color: theme.palette.error.dark,
		'&:hover': {
			backgroundColor: `${theme.palette.error.dark}14`,
		},
	},
}));

export default connect()(props => {
	const classes = useStyles();
	const settings = useSelector(state => state.data.data.settings);
	const [open, setOpen] = useState(false);
	const [color, setColor] = useState(props.color);

	const onClick = () => {
		setOpen(!open);
	};

	const onChange = e => {
		setColor(e.hex);
	};

	const onSave = index => {
		onClick();
		props.onSave(color);
	};

	const cssClass = props.disabled ? `${classes.div} disabled` : classes.div;
	const style = props.disabled ? { opacity: 0.5 } : {};

	return (
		<div className={cssClass} style={style}>
			<Grid container>
				<Paper className={classes.rowWrapper} onClick={onClick}>
					<Grid item xs={12}>
						<Grid container>
							<Grid item xs={2} style={{ position: 'relative' }}>
								<Avatar
									className={classes.avatar}
									style={{ backgroundColor: props.color }}
								>
									<Colorize className={classes.avatarIcon} />
								</Avatar>
							</Grid>
							<Grid
								item
								xs={8}
								style={{ paddingLeft: 5, position: 'relative' }}
							>
								<span className={classes.sectionHeader}>
									{props.label}
								</span>
								<span
									className={classes.selectedItem}
									style={{ color: props.color }}
								>
									{props.color}
								</span>
							</Grid>
							<Grid item xs={2} style={{ position: 'relative' }}>
								<ChevronRight className={classes.arrow} />
							</Grid>
						</Grid>
					</Grid>
				</Paper>
			</Grid>
			{open ? (
				<Modal
					open={open}
					handleClose={() => onClick(false)}
					title={`Select ${props.label}`}
				>
					<ColorPicker color={color} onChange={onChange} onSave={onSave} />
				</Modal>
			) : null}
		</div>
	);
});
