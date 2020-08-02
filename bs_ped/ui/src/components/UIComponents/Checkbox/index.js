/* eslint-disable jsx-a11y/no-static-element-interactions */
/* eslint-disable jsx-a11y/click-events-have-key-events */
/* eslint-disable react/prop-types */
import React from 'react';
import { Grid, makeStyles, Tooltip } from '@material-ui/core';
import { CheckBox, CheckBoxOutlineBlank } from '@material-ui/icons';

const useStyles = makeStyles(theme => ({
  div: {
    width: '100%',
    fontSize: 13,
    fontWeight: 500,
    textDecoration: 'none',
    textShadow: 'none',
    whiteSpace: 'nowrap',
    display: 'inline-block',
    verticalAlign: 'middle',
    borderRadius: 3,
    transition: '0.1s all linear',
    userSelect: 'none',
    color: '#ffffff',
    margin: 'auto',
    lineHeight: '84px',
    height: '100%',
  },
  disabled: {
    height: '100%',
    color: theme.palette.error.main,
  },
  enabled: {
    height: '100%',
    color: '#38b58f',
  },
}));

const Checkbox = props => {
  const classes = useStyles();

  return (
    <div className={classes.div} onClick={props.onClick}>
      <Grid container>
        <Grid item xs={12}>
          {props.disabled ? (
            <Tooltip title="Enable">
              <CheckBoxOutlineBlank className={classes.disabled} />
            </Tooltip>
          ) : (
            <Tooltip title="Disable">
              <CheckBox className={classes.enabled} />
            </Tooltip>
          )}
        </Grid>
      </Grid>
    </div>
  );
};

export default Checkbox;
