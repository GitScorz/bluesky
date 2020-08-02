/* eslint-disable prettier/prettier */
/* eslint-disable react/prop-types */
import React from 'react';
import { Box, makeStyles } from '@material-ui/core';

const useStyles = makeStyles(theme => ({
  tabPanel: {
    background: theme.palette.secondary.dark,
    height: 595,
  },
}));

export default props => {
  const classes = useStyles();
  const { children, value, index, ...other } = props;

  return (
    <div
      hidden={value !== index}
    >
      {value === index && (
        <Box className={classes.tabPanel} p={0}>
          {children}
        </Box>
      )}
    </div>
  );
};
