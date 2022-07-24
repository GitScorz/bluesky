/* eslint-disable react/no-danger */
import React from 'react';
import { useSelector } from 'react-redux';
import ReactHtmlParser from 'react-html-parser';
import { Fade, makeStyles } from '@material-ui/core';

const useStyles = makeStyles(theme => ({
  wrapper: {
    '&::before': {
      content: '" "',
      background: theme.palette.secondary.main,
      height: 10,
      position: 'absolute',
      transform: 'rotate(1deg)',
      zIndex: -1,
      width: '100%',
      margin: '0 auto',
      left: 0,
      right: 0,
      marginTop: -25,
    },
    background: theme.palette.secondary.main,
    color: theme.palette.text.secondary,
    padding: 20,
    position: 'absolute',
    bottom: '15%',
    left: 0,
    right: 0,
    margin: 'auto',
    width: 'fit-content',
    fontSize: 20,
  },
  highlight: {
    color: '#3aaaf9',
    fontWeight: 500,
  },
  '.highlight': {
    color: '#3aaaf9',
    fontWeight: 500,
  },
  highlightSplit: {
    color: '#ffffff',
    fontWeight: 500,
  },
  key: {
    padding: 5,
    background: theme.palette.text.main,
    color: theme.palette.secondary.main,
    borderRadius: 2,
    textTransform: 'capitalize',
  },
}));

export default () => {
  const classes = useStyles();
  const showing = useSelector(state => state.action.showing);
  const message = useSelector(state => state.action.message);

  const ParseButtonText = () => {
    let v = message;
    v = v.replace(
      /\{key\}/g,
      `<span class=${classes.key}>`,
    );

    v = v.replace(
      /\{\/key\}/g,
      `</span>`,
    );

    return v;
  };

  return (
    <Fade in={showing}>
      <div className={classes.wrapper}>
        {ReactHtmlParser(ParseButtonText())}
      </div>
    </Fade>
  );
};
