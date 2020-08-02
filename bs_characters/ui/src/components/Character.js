/* eslint-disable react/prop-types */
import React from 'react';
import { connect } from 'react-redux';
import { makeStyles } from '@material-ui/core/styles';
import Moment from 'react-moment';
import {
  IconButton,
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogContentText,
  DialogTitle,
} from '@material-ui/core';
import { PlayCircleFilled, Delete } from '@material-ui/icons';
import {
  deleteCharacter,
  getCharacterSpawns,
} from '../actions/characterActions';

const useStyles = makeStyles(theme => ({
  wrapper: {
    margin: 15,
    padding: 15,
    border: `2px solid ${theme.palette.secondary.dark}`,
    color: theme.palette.text.main,
    '&:hover': {
      borderColor: '#2f2f2f',
      transition: 'border-color ease-in 0.15s',
      cursor: 'pointer',
    },
  },
  highlight: {
    color: theme.palette.primary.main,
  },
  left: {
    display: 'inline-block',
    width: '75%',
  },
  right: {
    display: 'inline-block',
    width: '25%',
    textAlign: 'right',
  },
  actionButton: {
    display: 'inline-block',
    width: '40%',
  },
}));

const Character = props => {
  const classes = useStyles();

  const [open, setOpen] = React.useState(false);

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  const playCharacter = () => {
    props.getCharacterSpawns(props.character);
  };

  const deleteChar = () => {
    props.deleteCharacter(props.id, props.character.ID);
    setOpen(false);
  };

  return (
    <div className={classes.wrapper}>
      <div className={classes.left}>
        <div>
          <span className={classes.headerText}>
            {props.character.First} {props.character.Last}
          </span>
        </div>
        <div>
          <span>
            Last Played:
            {+props.character.LastPlayed === -1 ? (
              <span className={classes.highlight}> Never</span>
            ) : (
              <span className={classes.highlight}>
                {' '}
                <Moment withTitle fromNow>
                  {+props.character.LastPlayed}
                </Moment>{' '}
                <small>
                  (
                  <Moment format="M/D/YYYY h:mm:ss A" withTitle>
                    {+props.character.LastPlayed}
                  </Moment>
                  )
                </small>
              </span>
            )}
          </span>
        </div>
      </div>
      <div className={classes.right}>
        <div className={classes.actionButton}>
          <IconButton onClick={handleClickOpen}>
            <Delete />
          </IconButton>
        </div>
        <div className={classes.actionButton}>
          <IconButton onClick={playCharacter}>
            <PlayCircleFilled />
          </IconButton>
        </div>
      </div>
      <Dialog open={open} onClose={handleClose}>
        <DialogTitle>{`Delete ${props.character.First} ${props.character.Last}?`}</DialogTitle>
        <DialogContent>
          <DialogContentText>
            Are you sure you want to delete {props.character.First}{' '}
            {props.character.Last}? This action is completely & entirely
            irreversible by{' '}
            <i>
              <b>anyone</b>
            </i>{' '}
            including staff. Proceed?
          </DialogContentText>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleClose} color="default">
            No
          </Button>
          <Button onClick={deleteChar} color="primary" autoFocus>
            Yes
          </Button>
        </DialogActions>
      </Dialog>
    </div>
  );
};

const mapStateToProps = state => ({
  selected: state.characters.selected,
});

export default connect(mapStateToProps, {
  deleteCharacter,
  getCharacterSpawns,
})(Character);
