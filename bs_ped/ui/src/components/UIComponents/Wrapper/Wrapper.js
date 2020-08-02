import { makeStyles } from '@material-ui/core/styles';
import React from 'react';


const useStyles = makeStyles(theme => ({
  wrapper: {
    padding: 30,
    color: theme.palette.text.main,
    maxHeight: '100%',
    overflowX: 'hidden',
    overflowY: 'auto',
    '&::-webkit-scrollbar': {
      width: 6,
    },
    '&::-webkit-scrollbar-thumb': {
      background: '#131317',
    },
    '&::-webkit-scrollbar-track': {
      background: theme.palette.secondary.main,
    },
  },
}));
export default (props) => {
  const classes = useStyles();
  return <div className={classes.wrapper}>
    {props.children}
  </div>
}
