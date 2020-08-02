import React, { useState } from 'react';
import { connect, useSelector } from 'react-redux';
import {
	makeStyles,
	TextField,
	ButtonGroup,
	Button,
    Chip,
    InputAdornment,
} from '@material-ui/core';
import { useHistory } from 'react-router-dom';
import { Autocomplete } from '@material-ui/lab';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { showAlert } from '../../actions/alertActions';
import { UpdateAdvert } from './action';
import { Categories } from './data';
import { Editor } from '../../components';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		overflowY: 'auto',
		overflowX: 'hidden',
		padding: 10,
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
	button: {
		width: '-webkit-fill-available',
		padding: 20,
		color: theme.palette.error.light,
		'&:hover': {
			backgroundColor: `${theme.palette.error.light}14`,
		},
	},
	buttonNegative: {
		width: '-webkit-fill-available',
		padding: 20,
		color: theme.palette.error.main,
		'&:hover': {
			backgroundColor: `${theme.palette.error.main}14`,
		},
	},
	buttonPositive: {
		width: '-webkit-fill-available',
		padding: 20,
		color: theme.palette.error.dark,
		'&:hover': {
			backgroundColor: `${theme.palette.error.dark}14`,
		},
	},
    creatorInput: {
        marginTop: 20,
    }
}));

const initState = {
	title: '',
	short: '',
    full: '',
    time: null,
	tags: Array(),
};

export default connect(null, { UpdateAdvert, showAlert })((props) => {
	const classes = useStyles();
	const history = useHistory();
	const myData = useSelector((state) => state.data.data.myData);
	const advert = useSelector((state) => state.data.data.adverts)[myData.sid];

	const [state, setState] = useState({
		title: advert.title,
		short: advert.short,
        full: advert.full,
        price: advert.price,
		tags: Categories.filter((c) => advert.categories.includes(c.label)),
	});
	const onChange = (content) => {
		setState({
			...state,
			full: content,
		});
	};

	const textChange = (e) => {
		setState({
			...state,
			[e.target.name]: e.target.value,
		});
	};

	const onSave = () => {
		
        let t = Array();
        state.tags.map(tag => {
            t.push(tag.label);
        })
		props.UpdateAdvert(myData.sid, {
            ...state,
            id: myData.sid,
            author: `${myData.name.first} ${myData.name.last}`,
            number: myData.number,
            time: Date.now(),
            categories: t
        }, () => {
			props.showAlert('Advert Updated');
			history.goBack();
		});
	};

	return (
		<div className={classes.wrapper}>
			<TextField
				className={classes.creatorInput}
				fullWidth
				label="Title"
				name="title"
				variant="outlined"
				required
				onChange={textChange}
				value={state.title}
				inputProps={{
					maxLength: 32,
				}}
			/>
			<Autocomplete
				multiple
				fullWidth
				style={{ marginTop: 10 }}
				value={state.tags}
				onChange={(event, newValue) => {
					setState({
						...state,
						tags: [...newValue],
					});
				}}
				options={Categories}
				getOptionLabel={(option) => option.label}
				renderTags={(tagValue, getTagProps) =>
					tagValue.map((option, index) => (
						<Chip
							label={option.label}
							style={{ backgroundColor: option.color }}
							{...getTagProps({ index })}
						/>
					))
				}
				renderInput={(params) => (
					<TextField {...params} label="Tags" variant="outlined" />
				)}
			/>
			<TextField
				className={classes.creatorInput}
				fullWidth
				label="Price (Leave Empty If Negotiable)"
				name="price"
				variant="outlined"
				onChange={textChange}
				value={state.price}
				inputProps={{
					maxLength: 16,
				}}
				InputProps={{
					startAdornment: (
						<InputAdornment position="start">
							<FontAwesomeIcon icon={['fad', 'dollar-sign']} />
						</InputAdornment>
					),
				}}
			/>
			<TextField
				className={classes.creatorInput}
				fullWidth
                required
				label="Short Description"
				name="short"
				variant="outlined"
				required
				onChange={textChange}
				value={state.short}
				inputProps={{
					maxLength: 64,
				}}
			/>
			<Editor
				minified
				value={state.full}
				onChange={onChange}
				placeholder="Description"
			/>
			<ButtonGroup variant="text" color="primary" fullWidth>
				<Button
					className={classes.buttonNegative}
					onClick={() => history.goBack()}
				>
					Cancel
				</Button>
				<Button className={classes.buttonPositive} onClick={onSave}>Update Ad</Button>
			</ButtonGroup>
		</div>
	);
});
