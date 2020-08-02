/* eslint-disable react/prop-types */
/* eslint-disable react/no-array-index-key */
import React from 'react';
import { connect } from 'react-redux';
import { makeStyles } from '@material-ui/core/styles';
import SpawnButton from '../../components/SpawnButton';
import { STATE_CHARACTERS } from '../../util/States';
import { SET_STATE, DESELECT_CHARACTER } from '../../actions/types';

const useStyles = makeStyles(theme => ({
  wrapper: {
    '&::before': {
      display: 'block',
      content: '" "',
      background: theme.palette.secondary.main,
      height: 25,
      transform: 'rotate(1deg) translate(0, -50%)',
      zIndex: -1,
      width: '100%',
    },
    width: '25vw',
    height: 750,
    position: 'absolute',
    top: 0,
    bottom: 0,
    left: '5%',
    margin: 'auto',
    background: theme.palette.secondary.main,
  },
  innerWrapper: {
    height: '96%',
    padding: 10,
    overflow: 'hidden',
    textAlign: 'center',
  },
  body: {
    height: '84.5%',
    overflowY: 'auto',
    overflowX: 'hidden',
    '&::-webkit-scrollbar': {
      width: 6,
    },
    '&::-webkit-scrollbar-thumb': {
      background: '#333333',
    },
    '&::-webkit-scrollbar-thumb:hover': {
      background: theme.palette.primary.main,
    },
    '&::-webkit-scrollbar-track': {
      background: theme.palette.secondary.dark,
    },
  },
  header: {
    color: theme.palette.text.main,
    position: 'relative',
    background: theme.palette.secondary.dark,
    padding: 14,
    width: 'fit-content',
    fontSize: 12,
    letterSpacing: 2,
    marginBottom: '2%',
    textTransform: 'uppercase',
    whiteSpace: 'nowrap',
    maxWidth: '90%',
    '&::after': {
      content: '" "',
      position: 'absolute',
      display: 'block',
      transition: 'all 0.5s ease',
      top: 0,
      right: -21,
      width: 0,
      height: 0,
      borderBottom: `44px solid ${theme.palette.secondary.dark}`,
      borderRight: '21px solid transparent',
    },
  },
  footer: {
    height: 'fit-content',
    position: 'absolute',
    width: '100%',
    padding: '0 10px',
    left: 0,
    right: 0,
    margin: 'auto',
    bottom: '2%',
  },
  button: {
    width: '100%',
    height: 42,
    fontSize: 13,
    fontWeight: 500,
    textAlign: 'center',
    textDecoration: 'none',
    textShadow: 'none',
    whiteSpace: 'nowrap',
    display: 'inline-block',
    verticalAlign: 'middle',
    padding: '10px 20px',
    borderRadius: 3,
    transition: '0.1s all linear',
    userSelect: 'none',
    background: '#672626a1',
    border: '2px solid #672626',
    color: '#cecece',
    '&:hover': {
      background: '#67262652',
      border: '2px solid #672626',
    },
  },
}));
const Spawn = props => {
  const classes = useStyles();

  return (
    <div className={classes.wrapper}>
      <div className={classes.innerWrapper}>
        <div className={classes.header}>
          <span>Select Your Spawn</span>
        </div>
        <div className={classes.body}>
          {props.spawns.map((spawn, i) => (
            <SpawnButton key={i} type="button" spawn={spawn} />
          ))}
        </div>
        <div className={classes.footer}>
          <button
            type="button"
            className={classes.button}
            onClick={() => {
              props.dispatch({ type: DESELECT_CHARACTER });
              props.dispatch({
                type: SET_STATE,
                payload: { state: STATE_CHARACTERS },
              });
            }}
          >
            Cancel
          </button>
        </div>
      </div>
    </div>
  );
};

const mapStateToProps = state => ({
  spawns: state.spawn.spawns,
});

export default connect(mapStateToProps)(Spawn);
