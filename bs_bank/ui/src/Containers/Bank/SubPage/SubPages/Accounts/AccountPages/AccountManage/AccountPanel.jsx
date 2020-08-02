import React from 'react';
import { makeStyles } from '@material-ui/core';

const useStyles = makeStyles(theme => ({
  container: {
    background: theme.palette.secondary.main,
    borderRadius: 5,
    boxShadow: '0px 0px 12px -2px rgba(0,0,0,0.3)',
    marginLeft: 15,
    marginBottom: 35,
    marginTop: 20,
    overflow: 'hidden',
  },

  wrapper: {
    display: 'inline-block',
    width: '90%',
    height: '95%',
    marginLeft: '5%',
    marginTop: '2.5%',
    overflow: 'hidden',
  },

  hr: {
    width: '100%',
    borderColor: 'rgba(200, 200, 200, 0.04)',
    borderWidth: 0.5,
    borderStyle: 'solid',
    marginTop: 8,
  },

  title: {
    marginTop: 0,
    color: theme.palette.primary.main,
    fontWeight: 500,
    marginBottom: 0,
    fontSize: 19,
  },

  desc: {
    fontSize: 12,
    fontWeight: 100,
    marginBottom: 0,
    marginTop: -3,
    color: theme.palette.secondary.contrastText,
  },

  content: {
    overflow: 'auto',
    height: '90%',
    width: '100%',
  },
}));

const AccountPanel = ({
  width = 300, height = 200,
  title, desc,
  children,
}) => {

  const classes = useStyles();

  return (
    <div className={classes.container} style={{ width, height }}>
      <div className={classes.wrapper}>
        <h2 className={classes.title}>{title}</h2>
        <p className={classes.desc}>{desc}</p>
        <hr className={classes.hr}/>

        <div className={classes.content}>
          {children}
        </div>

      </div>
    </div>
  );
};

export default AccountPanel;
