import React, { useState } from 'react';
import { connect, useSelector } from 'react-redux';
import Typography from '@material-ui/core/Typography';
import { library } from '@fortawesome/fontawesome-svg-core';
import { far } from '@fortawesome/pro-regular-svg-icons';
import { fas } from '@fortawesome/pro-solid-svg-icons';
import { fal } from '@fortawesome/pro-light-svg-icons';
import { fad } from '@fortawesome/pro-duotone-svg-icons';
import { fab } from '@fortawesome/free-brands-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Fade, makeStyles } from '@material-ui/core';
import Grid from '@material-ui/core/Grid';
import Paper from '@material-ui/core/Paper';

import logoImage from '../../logo.png';

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
  logoWrapper: {
    textAlign: 'center',
    width: '100%',
    marginTop: '-50px',
    zIndex:100,
    marginBottom: '20px'
  },
  logo: {
    width: '200px',
    zIndex:100,
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
      backgroundColor: '#00D8FF',
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
    width: '100%',
    height: '96%',
    padding: '5%',
    overflow: 'hidden',
  },
  motd: {
    '& span::before': {
      content: '"Notice:"',
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
  informationBox: {
    borderLeft: `1px solid ${theme.palette.secondary.main}`,
    padding: 15,
    background: theme.palette.secondary.dark,
    color: theme.palette.text.main,
    flexGrow: 1,
  },
  informationCategory: {
    color: theme.palette.primary.main,
    marginRight: 5,
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
  pluginVersion: {
    margin: 'auto',
    marginTop: 30,
    height:'50px',
    width: '350px',
    textAlign: 'center',
    lineHeight: '50px',
    fontSize: '20px',
    borderRadius: '10px'
  },
  positive: {
    color: '#38b58f59',
    fontWeight: 'bold',
  },
  negative: {
    color: '#672626',
    fontWeight: 'bold',
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
  paper: {
    padding: theme.spacing(1),
    textAlign: 'center',
  }
})); 

library.add(far, fab, fas, fal, fad );

export default connect()((props) => {
  const hidden = useSelector(state => state.app.warningScreen);
  const website = useSelector(state => state.app.website);
  const serverUrl = useSelector(state => state.app.serverUrl);
  const channel = useSelector(state => state.app.channel);
  const support = useSelector(state => state.app.support);
  const currentMessage = useSelector(state => state.app.currentMessage);
  const pluginColor = useSelector(state => state.app.pluginColor);
  const pluginText = useSelector(state => state.app.pluginText);
  let messageColor = useSelector(state => state.app.messageColor);
  let currentlyTalking = useSelector(state => state.app.currentlyTalking);
  const classes = useStyles();

  if(messageColor == 'positive') {
    messageColor = classes.positive;
  } else {
    messageColor = classes.negative;
  }
  function Servers() {
    return (
      <React.Fragment>
        <Grid item xs={6}>
          <Paper className={classes.paper}><span className={classes.informationCategory}>Server:</span> {serverUrl}</Paper>
        </Grid>
        <Grid item xs={6}>
          <Paper className={classes.paper}><span className={classes.informationCategory}>Website:</span> {website}</Paper>
        </Grid>
      </React.Fragment>
    );
  }

  function Channels() {
    return (
      <React.Fragment>
        <Grid item xs={6}>
          <Paper className={classes.paper}><span className={classes.informationCategory}>Channel:</span> {channel}</Paper>
        </Grid>
        <Grid item xs={6}>
          <Paper className={classes.paper}><span className={classes.informationCategory}>Support:</span> {support}</Paper>
        </Grid>
      </React.Fragment>
    );
  }

  function Status() {
    return (
      <React.Fragment>
        <Grid item xs={12}>
          <Paper className={classes.paper}><span className={messageColor}>{currentMessage}</span></Paper>
        </Grid>
        
      </React.Fragment>
    );
  }

  return (<Fade in={hidden}>
        <div className={classes.wrapper}>
      
      <div className={classes.bodyWrapper}>
        <div className={classes.logoWrapper}>
          <img className={classes.logo} src={logoImage}></img>
        </div>
        <div className={classes.motd}>
          <span>
          <FontAwesomeIcon className={classes.redColor} icon="headset" /> TokoVoip Voice Communication Required</span>
        </div>
        <p>TokoVoip is required to play on the Blue Sky Servers.</p>
        <p>It allows for a smoother and better voice communication system used by all in the city.</p>
        <div className={classes.informationBox}>
          <Grid container spacing={2}>
            <Grid container item xs={12} spacing={1}>
              <Servers />
            </Grid>
            <Grid container item xs={12} spacing={1}>
              <Channels />
            </Grid>
            <Grid container item xs={12} spacing={1}>
              <Status />
            </Grid>
        </Grid>
        </div>
        <div className={classes.pluginVersion} style={{background: pluginColor }}>
          {pluginText}
        </div>
      </div>
      
    </div>
      </Fade>);
});
