import React, { useState } from 'react';
import { connect, useSelector } from 'react-redux';
import {
	makeStyles,
	Paper,
	TextField,
	ButtonGroup,
    Button,
    CircularProgress,
} from '@material-ui/core';
import AddIcon from '@material-ui/icons/Add';
import axios from 'axios';
import { Alert } from '@material-ui/lab';

import { UpdateSetting } from '../actions';
import { showAlert } from '../../../actions/alertActions';
import { Modal } from '../../../components';
import { Wallpapers } from '../../../util/Wallpapers';

const useStyles = makeStyles(theme => ({
	wrapper: {
		background: theme.palette.secondary.dark,
		width: '100%',
		height: 'fit-content',
		padding: 10,
		userSelect: 'none',
        border: `2px solid ${theme.palette.secondary.dark}`,
        textAlign: 'left',
		'-webkit-user-select': 'none',
		'&:hover': {
			background: theme.palette.secondary.light,
			borderColor: theme.palette.secondary.light,
			transition: 'background, border-color ease-in 0.15s',
			cursor: 'pointer',
		},
	},
	wrapperActive: {
		background: theme.palette.secondary.dark,
		width: '100%',
		height: 'fit-content',
		padding: 10,
        userSelect: 'none',
        border: `2px solid ${theme.palette.primary.main}`,
        textAlign: 'left',
		'-webkit-user-select': 'none',
		'&:hover': {
			background: theme.palette.secondary.light,
			borderColor: theme.palette.secondary.light,
			transition: 'background, border-color ease-in 0.15s',
			cursor: 'pointer',
		},
	},
    img: {
        height: 200,
        width: '100%',
        display: 'block',
    },
	addContainer: {
		height: 200,
		lineHeight: '200px',
		position: 'relative',
		width: '100%',
		display: 'block',
		backgroundColor: theme.palette.primary.main,
	},
	addIcon: {
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		fontSize: 35,
	},
	editField: {
		width: '100%',
		marginBottom: 20,
		fontSize: 20,
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
    customPH: {
        position: 'relative',
        height: 425,
        width: 250,
        margin: 'auto',
        background: theme.palette.secondary.dark,
        marginBottom: 25,
    },
    customImg: {
        display: 'block',
        height: 425,
        width: 250,
        margin: 'auto',
        marginBottom: 25,
    }
}));

export default connect(null, { UpdateSetting, showAlert })(props => {
	const classes = useStyles();
	const settings = useSelector(state => state.data.data.settings);

    const isActive = Wallpapers[settings.wallpaper] == null;

    const [open, setOpen] = useState(false);
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);
	const [val, setVal] = useState(
		isActive ? settings.wallpaper : '',
	);

	const toggleOpen = state => {
        if (!loading || !open)
            setOpen(state);
	};

	const onChange = e => {
		e.preventDefault();
		setVal(e.target.value);
	};

    const onSave = () => {
        setLoading(true);
        axios.head(val).then((res) => {
            if (res.headers['content-type'].includes('image')) {
                setLoading(false);
                toggleOpen(false);
                if (val !== '') {
                    props.UpdateSetting('wallpaper', val);
                    props.showAlert('Custom Wallpaper Saved');
                }
            } else {
                setLoading(false);
                setError('Link Is Not An Image');
            }
        }).catch((err) => {
            setError('Unable To Reach Link');
            setLoading(false);
        });
    }

	const removeImage = e => {
		e.preventDefault();
        toggleOpen(false);
		setVal('');
        props.UpdateSetting('wallpaper', 'wallpaper');
        props.showAlert('Wallpaper Deleted');
	};

	return (
		<>
			<Paper className={isActive ? classes.wrapperActive : classes.wrapper} onClick={() => toggleOpen(true)}>
                {
                    isActive ?
                    <img className={classes.img} src={settings.wallpaper} alt='Custom Wallpaper' /> :
                    <div className={classes.addContainer}>
                        <AddIcon className={classes.addIcon} />
                    </div>
                }
				Custom
			</Paper>

            {
                open ?
                <Modal
                    open={open}
                    handleClose={() => toggleOpen(false)}
                    title="Custom Wallpaper"
                >
                    {
                        loading ?
                        <div>
                            <div className={classes.customPH}>
                                <CircularProgress size={70} className={classes.addIcon} />
                            </div>
                            <div>Checking Link</div>
                        </div> :
                        <div>
                            {
                                val != '' ?
                                <img className={classes.customImg} src={val} alt='Custom Wallpaper' />:
                                <div className={classes.customPH}><AddIcon className={classes.addIcon} /></div>
                            }
                            {
                                error !== '' ?
                                <Alert variant='filled' severity='error' elevation={6} className={classes.error}>{error}</Alert> : null
                            }
                            <TextField
                                className={classes.editField}
                                label="Wallpaper Link"
                                name="wallpaper"
                                type="text"
                                onChange={onChange}
                                value={val}
                                InputLabelProps={{
                                    style: { fontSize: 20 },
                                }}
                            />
                            <ButtonGroup
                                variant="text"
                                color="primary"
                                className={classes.buttons}
                            >
                                {isActive ? (
                                    <Button
                                        className={classes.buttonNeg}
                                        onClick={removeImage}
                                    >
                                        Delete
                                    </Button>
                                ) : null}
                                <Button
                                    className={classes.buttonPos}
                                    onClick={onSave}
                                >
                                    Save
                                </Button>
                            </ButtonGroup>
                        </div>
                    }
                </Modal> : null
            }
		</>
	);
});
