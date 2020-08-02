import Grid from '@material-ui/core/Grid';
import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles, IconButton } from '@material-ui/core';
import CancelIcon from '@material-ui/icons/Cancel';
import { closeInventory } from '../Inventory/actions';

const useStyles = makeStyles((theme) => ({
  outsideDiv: {
    width: '100vw',
    height: '100vh',
    position: 'absolute',
    right: 0,
    left: 0,
    top: 0,
    bottom: 0,
    margin: 'auto',
    zIndex: -1,
    background: 'rgba(0,0,0,0.75)',
    '@global': {
      '*::-webkit-scrollbar': {
        width: 0,
      },
      '*::-webkit-scrollbar-thumb': {
        background: theme.palette.secondary.light,
      },
      '*::-webkit-scrollbar-thumb:hover': {
        background: theme.palette.primary.main,
      },
      '*::-webkit-scrollbar-track': {
        background: theme.palette.secondary.main,
      },
    },
  },
  insideDiv: {
    width: '100%',
    height: '60%',
    position: 'absolute',
    top: 0,
    bottom: 0,
    margin: 'auto',
    display: 'block',
    zIndex: -1,
  },
  dialog: {
    display: 'flex',
    flexDirection: 'column',
    margin: 'auto',
    width: 'fit-content',
    zIndex: -1,
  },
  closeButton: {
    position: 'absolute',
    top: 0,
    left: 0,
    color: theme.palette.primary.main,
    padding: 25,
    background: 'transparent',
    minWidth: 32,
    boxShadow: 'none',
    '&:hover': {
      color: theme.palette.primary.main,
      background: 'transparent',
      boxShadow: 'none',
      '& svg': {
        filter: 'brightness(0.6)',
        transition: 'filter ease-in 0.15s',
      },
    },
  },
}));

export default function AppScreen(props) {
  const classes = useStyles();
  const dispatch = useDispatch();
  const hoverOrigin = useSelector(state => state.inventory.hoverOrigin);

  const onClick = () => {
    if (hoverOrigin != null) {
      dispatch({
          type: 'SET_HOVER',
          payload: null,
      });
      dispatch({
          type: 'SET_HOVER_ORIGIN',
          payload: null,
      });
    }
  }

  const close = () => {
    dispatch({
      type: 'SET_CONTEXT_ITEM',
      payload: null
    });
    dispatch({
      type: 'SET_SPLIT_ITEM',
      payload: null
    });
    closeInventory();
  }

  return (
    <Grid
      style={{ visibility: props.hidden ? 'hidden' : 'visible' }}
      className={classes.outsideDiv}
      onClick={onClick}
    >
      <IconButton
        className={classes.closeButton}
        variant='contained'
        color='primary'
        onClick={close}
      >
        <CancelIcon style={{ fontSize: 30 }} />
      </IconButton>
      <Grid
        container
        className={classes.insideDiv}
        justify={'center'}
        alignItems={'center'}
      >
        {props.children}
      </Grid>
    </Grid>
  );
}
