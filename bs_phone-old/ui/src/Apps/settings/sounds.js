import React from 'react';
import { connect, useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/core';
import { blue, orange } from '@material-ui/core/colors';
import { Settings } from '@material-ui/icons';

import Version from './components/Version';
import SoundSelect from './components/SoundSelect';
import { UpdateSetting, TestSound } from './actions';

const ringtones = [
    { value: 'ringtone', label: 'Ringtone 1'},
    { value: 'ringtone2', label: 'Ringtone 2' },
];

const texttones = [
    { value: 'text', label: 'Text Tone 1'},
    { value: 'text2', label: 'Text Tone 2' },
];

const useStyles = makeStyles(theme => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	sounds: {
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
}));

export default connect(null, { UpdateSetting, TestSound })(props => {
	const classes = useStyles();
    const settings = useSelector(state => state.data.data.settings);

    const ringChanged = (index) => {
        if (index !== settings.ringtone)
            props.UpdateSetting('ringtone', index);
    }

    const textChanged= (index) => {
        if (index !== settings.texttone)
            props.UpdateSetting('texttone', index);
    }

    const testRingtone = (index) => {
		props.TestSound('ringtone', index);
    }

    const testTexttone= (index) => {
		props.TestSound('texttone', index);
    }

	return (
		<div className={classes.wrapper}>
            <div className={classes.sounds}>
                <SoundSelect label="Ringtone" selected={settings.ringtone} options={ringtones} color={orange[500]} onChange={ringChanged} playSound={testRingtone} />
                <SoundSelect label="Text Tone" selected={settings.texttone} options={texttones} color={blue[500]} onChange={textChanged} playSound={testTexttone} />
            </div>
			<Version />
		</div>
	);
});
