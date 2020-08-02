import React from 'react';
import { makeStyles } from '@material-ui/core/styles';

const useStyles = makeStyles(theme => ({
  inner: {
    background: theme.palette.secondary.main,
    paddingBottom: 10,
    overflow: 'hidden',
  },
  header: {
    color: theme.palette.text.main,
    position: 'relative',
    background: theme.palette.secondary.dark,
    padding: 14,
    width: 'fit-content',
    marginBottom: 20,
    fontSize: 12,
    letterSpacing: 2,
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
      borderBottom: `46px solid ${theme.palette.secondary.dark}`,
      borderRight: '21px solid transparent',
    },
  },
}));

export default (props) => {
  const classes = useStyles();
  return (
    <div className={classes.inner}>
      <div className={classes.header}>
        <div
          style={{
            maxWidth: '100%',
            overflow: 'hidden',
            textOverflow: 'ellipsis',
          }}
        >
          {props.label}
        </div>
      </div>
      <div className={props.bodyClass}>
        {props.children}
      </div>
    </div>);
}
