/* eslint-disable react/prop-types */
import React from 'react';
import { connect } from 'react-redux';
import { makeStyles } from '@material-ui/core/styles';
import { spawnToWorld } from '../actions/characterActions';

const useStyles = makeStyles(() => ({
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
    background: '#3aaaf980',
    border: '2px solid #3aaaf9',
    color: '#ffffff',
    marginBottom: 5,
    '&:disabled': {
      opacity: 0.5,
      cursor: 'not-allowed',
    },
    '&:hover': {
      background: '#3aaaf92e',
      border: '2px solid #3aaaf9',
    },
  },
}));

const SpawnButton = props => {
  const classes = useStyles();

  const onClick = () => {
    props.spawnToWorld(props.spawn, props.selected);
  };

  return (
    <button type="button" className={classes.button} onClick={onClick}>
      {props.spawn.label}
    </button>
  );
};

const mapStateToProps = state => ({
  selected: state.characters.selected,
});

export default connect(mapStateToProps, { spawnToWorld })(SpawnButton);
