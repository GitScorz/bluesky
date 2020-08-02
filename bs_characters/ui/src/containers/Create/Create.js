/* eslint-disable react/prop-types */
import React, { useState } from 'react';
import { connect } from 'react-redux';
import { makeStyles } from '@material-ui/core/styles';
import { TextField, FormControl, MenuItem } from '@material-ui/core';
import DateFnsUtils from '@date-io/date-fns';
import {
  MuiPickersUtilsProvider,
  KeyboardDatePicker,
} from '@material-ui/pickers';
import { SET_STATE } from '../../actions/types';
import { createCharacter } from '../../actions/characterActions';
import { STATE_CHARACTERS } from '../../util/States';

const useStyles = makeStyles(theme => ({
  wrapper: {
    '&::before': {
      display: 'block',
      content: '""',
      background: theme.palette.secondary.main,
      height: 25,
      transform: 'rotate(1deg) translate(0, -50%)',
      zIndex: -1,
      width: '100%',
    },
    width: '50%',
    height: 650,
    position: 'absolute',
    top: 0,
    bottom: 0,
    right: 0,
    left: 0,
    margin: 'auto',
    background: theme.palette.secondary.main,
  },
  createForm: {
    '&::before': {
      display: 'block',
      content: '""',
      background: theme.palette.secondary.dark,
      height: 25,
      transform: 'rotate(-1deg) translate(0, -50%)',
      zIndex: -1,
      width: '100%',
    },
    background: theme.palette.secondary.dark,
    margin: 25,
  },
  button: {
    fontSize: 14,
    lineHeight: '20px',
    fontWeight: '500',
    display: 'inline-block',
    padding: '10px 20px',
    borderRadius: 3,
    userSelect: 'none',
    margin: 10,
    width: '40%',
    '&:disabled': {
      opacity: 0.5,
      cursor: 'not-allowed',
    },
  },
  positive: {
    background: '#38b58f59',
    border: '2px solid #38b58f',
    color: theme.palette.text.dark,
  },
  negative: {
    border: ' 2px solid #672626',
    background: '#672626a1',
    color: theme.palette.text.main,
  },
  form: {
    display: 'flex',
    justifyContent: 'space-evenly',
    padding: '1% 0',
    flexWrap: 'wrap',
  },
  formControl: {
    width: '45%',
    display: 'block',
    margin: 10,
  },
  formControl2: {
    width: '94%',
    display: 'block',
    margin: 10,
  },
  input: {
    width: '100%',
  },
}));

const genders = [
  {
    value: 0,
    label: 'Male',
  },
  {
    value: 1,
    label: 'Female',
  },
];

const Create = props => {
  const classes = useStyles();

  const [state, setState] = useState({
    first: '',
    last: '',
    dob: new Date('1990-12-31T23:59:59'),
    gender: 0,
    bio: '',
  });

  const onChange = evt => {
    setState({
      ...state,
      [evt.target.name]: evt.target.value,
    });
  };

  const onSubmit = evt => {
    evt.preventDefault();
    const data = {
      first: state.first,
      last: state.last,
      gender: state.gender,
      dob: state.dob,
      lastPlayed: -1,
    };
    props.createCharacter(data, props.dispatch);
  };

  const date = new Date();
  date.setFullYear(date.getFullYear() - 18);
  const date2 = new Date();
  date2.setFullYear(date2.getFullYear() - 100);

  return (
    <MuiPickersUtilsProvider utils={DateFnsUtils}>
      <div className={classes.wrapper}>
        <div className={classes.createForm}>
          <h1 style={{ marginLeft: 15 }}>Create Character</h1>
          <hr style={{ marginBottom: 20 }} />
          <form
            autoComplete="off"
            id="createForm"
            className={classes.form}
            onSubmit={onSubmit}
          >
            <FormControl className={classes.formControl}>
              <TextField
                className={classes.input}
                required
                label="First Name"
                name="first"
                variant="outlined"
                value={state.first}
                onChange={onChange}
              />
            </FormControl>
            <FormControl className={classes.formControl}>
              <TextField
                className={classes.input}
                required
                label="Last Name"
                name="last"
                variant="outlined"
                value={state.last}
                onChange={onChange}
              />
            </FormControl>
            <FormControl className={classes.formControl}>
              <TextField
                className={classes.input}
                required
                select
                label="Gender"
                name="gender"
                helperText="NOTE: This will affect what ped you are, this cannot be changed"
                value={state.gender}
                onChange={onChange}
                variant="outlined"
              >
                {genders.map(option => (
                  <MenuItem key={option.value} value={option.value}>
                    {option.label}
                  </MenuItem>
                ))}
              </TextField>
            </FormControl>
            <FormControl className={classes.formControl}>
              <KeyboardDatePicker
                className={classes.input}
                views={['year', 'month', 'date']}
                required
                maxDate={date}
                maxDateMessage={`Date of Birth Must Be 18 or More Years Ago (On or Before ${date.toDateString()})`}
                minDate={date2}
                minDateMessage={`Date of Birth Must Be Within The Last 100 Years (On or After ${date2.toDateString()})`}
                openTo="year"
                animateYearScrolling
                autoOk
                variant="dialog"
                inputVariant="outlined"
                label="Date of Birth"
                format="MM/dd/yyyy"
                value={state.dob}
                InputAdornmentProps={{ position: 'start' }}
                onChange={newDate =>
                  onChange({ target: { name: 'dob', value: newDate } })
                }
              />
            </FormControl>
            <FormControl className={classes.formControl2}>
              <TextField
                className={classes.input}
                required
                label="Character Biography"
                name="bio"
                multiline
                rows="4"
                value={state.bio}
                onChange={onChange}
                variant="outlined"
              />
            </FormControl>
          </form>
        </div>
        <div className={classes.actionData} style={{ textAlign: 'center' }}>
          <button
            type="button"
            className={`${classes.button} ${classes.negative}`}
            onClick={() => {
              props.dispatch({
                type: SET_STATE,
                payload: { state: STATE_CHARACTERS },
              });
            }}
          >
            Cancel
          </button>
          <button
            type="submit"
            className={`${classes.button} ${classes.positive}`}
            form="createForm"
          >
            Create
          </button>
        </div>
      </div>
    </MuiPickersUtilsProvider>
  );
};

const mapDispatchToProps = dispatch => ({
  dispatch,
  createCharacter,
});

export default connect(null, mapDispatchToProps)(Create);
