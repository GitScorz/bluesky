/* eslint-disable react/no-array-index-key */
/* eslint-disable react/prop-types */
import React from 'react';
import { connect } from 'react-redux';
import { makeStyles } from '@material-ui/core/styles';
import { Button } from '@material-ui/core';
import { AddBox } from '@material-ui/icons';
import Moment from 'react-moment';
import Character from '../../components/Character';

import { SET_STATE } from '../../actions/types';
import { STATE_CREATE } from '../../util/States';

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
  createButton: {
    position: 'absolute',
    left: -63,
    borderRadius: 0,
    padding: 13,
    background: theme.palette.secondary.main,
    boxShadow: 'none',
    fontSize: 16,
    border: 'none',
    '&:hover': {
      backgroundColor: '#3aaaf966',
      boxShadow: 'none',
    },
    '&:active': {
      boxShadow: 'none',
    },
    '&:focus': {
      boxShadow: 'none',
    },
  },
  bodyWrapper: {
    display: 'inline-block',
    width: '60%',
    height: '96%',
    overflow: 'hidden',
  },
  motd: {
    '& span::before': {
      content: '"Message of the Day:"',
      color: theme.palette.primary.main,
      marginRight: 5,
    },
    borderLeft: `1px solid ${theme.palette.secondary.main}`,
    padding: 15,
    background: theme.palette.secondary.dark,
    color: theme.palette.text.main,
    whiteSpace: 'nowrap',
    overflow: 'hidden',
    textOverflow: 'ellipsis',
  },
  charList: {
    overflowY: 'auto',
    overflowX: 'hidden',
    height: '91%',
    display: 'block',
    '&::-webkit-scrollbar': {
      width: 6,
    },
    '&::-webkit-scrollbar-thumb': {
      background: '#131317',
    },
    '&::-webkit-scrollbar-thumb:hover': {
      background: theme.palette.primary.main,
    },
    '&::-webkit-scrollbar-track': {
      background: theme.palette.secondary.main,
    },
  },
  changelogWrapper: {
    display: 'inline-block',
    width: '40%',
    position: 'absolute',
    height: '96%',
    overflow: 'hidden',
    color: theme.palette.text.main,
  },
  changelogHeader: {
    '& span::before': {
      content: '"Changelog:"',
      color: theme.palette.primary.main,
      marginRight: 5,
    },
    padding: 15,
    background: theme.palette.secondary.dark,
    borderLeft: `1px solid ${theme.palette.secondary.main}`,
    borderRight: `1px solid ${theme.palette.secondary.main}`,
    overflow: 'hidden',
    whiteSpace: 'nowrap',
    textOverflow: 'ellipsis',
  },
  changelogbody: {
    height: '90.5%',
    overflowX: 'hidden',
    overflowY: 'auto',
    display: 'block',
    padding: 10,
    borderLeft: `1px solid ${theme.palette.secondary.dark}`,
    '&::-webkit-scrollbar': {
      width: 6,
    },
    '&::-webkit-scrollbar-thumb': {
      background: '#131317',
    },
    '&::-webkit-scrollbar-thumb:hover': {
      background: theme.palette.primary.main,
    },
    '&::-webkit-scrollbar-track': {
      background: theme.palette.secondary.main,
    },
  },
  charActions: {
    background: theme.palette.secondary.dark,
    position: 'absolute',
    width: '100%',
    bottom: 0,
  },
  actionData: {
    display: 'inline-block',
    width: '50%',
    padding: 15,
  },
  selectedText: {
    '&::before': {
      content: '"Selected:"',
      color: theme.palette.primary.main,
      marginRight: 5,
    },
    fontSize: 25,
    fontWeight: 500,
    color: theme.palette.text.main,
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
  noChar: {
    margin: 15,
    padding: 15,
    border: `2px solid ${theme.palette.secondary.dark}`,
    textAlign: 'center',
    color: theme.palette.text.main,
    '&:hover': {
      borderColor: '#2f2f2f',
      transition: 'border-color ease-in 0.15s',
      cursor: 'pointer',
    },
    '& h3': {
      color: theme.palette.primary.main,
    },
    '& span': {
      color: '#38b58f',
    },
  },
}));

const Characters = props => {
  const classes = useStyles();

  const createCharacter = () => {
    props.dispatch({
      type: SET_STATE,
      payload: { state: STATE_CREATE },
    });
  };

  return (
    <div className={classes.wrapper}>
      <Button
        className={classes.createButton}
        variant="contained"
        color="primary"
        onClick={createCharacter}
      >
        <AddBox />
      </Button>
      <div className={classes.bodyWrapper}>
        <div className={classes.motd}>
          <span>{props.motd}</span>
        </div>
        <div className={classes.charList}>
          {props.characters.length > 0 ? (
            props.characters.map((char, i) => (
              <Character key={i} id={i} character={char} />
            ))
          ) : (
            <div className={classes.noChar} onClick={createCharacter}>
              <h3>No Characters</h3>
              <span>+ Create New Character</span>
            </div>
          )}
        </div>
      </div>
      <div className={classes.changelogWrapper}>
        <div className={classes.changelogHeader}>
          <span>
            {props.changelog == null ? (
              'No Changelogs'
            ) : (
              <Moment format="M/D/YYYY h:mm:ss A" withTitle>
                {+props.changelog.date}
              </Moment>
            )}
          </span>
        </div>
        <div className={classes.changelogbody}>
          {props.changelog == null
            ? null
            : props.changelog.changes.map((change, i) => (
                <div>
                  <h3>{change.title}</h3>
                  <ul>
                    {change.changes.map((change2, j) => (
                      <li>{change2}</li>
                    ))}
                  </ul>
                </div>
              ))}
        </div>
      </div>
    </div>
  );
};

const mapStateToProps = state => ({
  characters: state.characters.characters,
  selected: state.characters.selected,
  changelog: state.characters.changelog,
  motd: state.characters.motd,
});

export default connect(mapStateToProps)(Characters);
