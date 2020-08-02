import React, { useEffect, useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import { makeStyles, Fab } from '@material-ui/core';

import AddIcon from '@material-ui/icons/Add';
import EditIcon from '@material-ui/icons/Edit';
import DeleteIcon from '@material-ui/icons/Delete';
import PublishIcon from '@material-ui/icons/Publish';

import { showAlert } from '../../actions/alertActions';
import { DeleteAdvert, BumpAdvert } from './action';

const useStyles = makeStyles((theme) => ({
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

export default connect(null, { DeleteAdvert, BumpAdvert, showAlert })((props) => {
	const classes = useStyles();
	const history = useHistory();
	const myAdvertId = useSelector((state) => state.data.data.myData.sid);
	const myAdvert = useSelector((state) => state.data.data.adverts)[
		myAdvertId
	];

	const [del, setDel] = useState(false);
	const onDelete = () => {
		setDel(true);

		setTimeout(() => {
			props.DeleteAdvert(myAdvertId, () => {
                props.showAlert('Advertisement Deleted');
            });
		}, 500);
	};
	const onBump = () => {
		props.BumpAdvert(myAdvertId, myAdvert, () => {
            props.showAlert('Advertisement Bumped');
        });
	};

	return (
		<>
			{myAdvert != null && !del ? (
				<>
					<Fab
						className={classes.add}
						onClick={() => history.push('/apps/adverts/edit')}
					>
						<EditIcon />
					</Fab>
					<Fab
						className={classes.delete}
						onClick={onDelete}
						disabled={del}
					>
						<DeleteIcon />
					</Fab>
					{myAdvert.time < Date.now() - 1000 * 60 * 30 ? (
						<Fab className={classes.bump} onClick={onBump}>
							<PublishIcon />
						</Fab>
					) : null}
				</>
			) : (
				<Fab
					className={classes.add}
					onClick={() => history.push('/apps/adverts/add')}
				>
					<AddIcon />
				</Fab>
			)}
		</>
	);
});
