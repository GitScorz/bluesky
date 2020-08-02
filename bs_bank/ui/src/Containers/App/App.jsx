import React from 'react';
import { useSelector } from 'react-redux';
import { createMuiTheme, CssBaseline, Fade, fade, makeStyles, MuiThemeProvider } from '@material-ui/core';
import { HashRouter, Redirect, Route, Switch } from 'react-router-dom';
import CancelIcon from '@material-ui/icons/Cancel';
import Bank from '../Bank/Bank';
import ATM from '../ATM/ATM';
import IconButton from '@material-ui/core/IconButton';
import Nui from '../../util/Nui';

const muiTheme = createMuiTheme({
  typography: {
    fontFamily: ['Manrope', 'sans-serif'],
  },
  palette: {
    primary: {
      main: '#1a7cc1',
      light: '#1a7cc1',
      dark: '#1a7cc1',
      contrastText: '#ffffff',
    },
    secondary: {
      main: fade('#1b1c21', 0.35),
      light: '#1b1c21',
      dark: '#1e1f24', // its actually lighter than main, but fuck you :-P
      contrastText: '#cecece',
    },
    error: {
      main: '#c75050',
      light: '#c75050',
      dark: '#c75050',
    },
    success: {
      main: '#53c95e',
      dark: '#388e3c',
      contrastText: 'rgba(0, 0, 0, 0.87)',
    },
    text: {
      main: '#cecece',
      light: '#000000',
      dark: '#ffffff',
    },
    type: 'dark',
  },
});

const useStyles = makeStyles(() => ({
  '@global': {
    '*': {
      fontFamily: '"Manrope", sans-serif',
    },
    '::-webkit': {
      '&-scrollbar': {
        width: 5,

        '&-thumb': {
          background: '#2C2D31',
          borderRadius: 50,
        },
      },
    },

    'input::-webkit': {
      '&-outer-spin-button': {
        WebkitAppearance: 'none',
        margin: 0,
      },
      '&-inner-spin-button': {
        WebkitAppearance: 'none',
        margin: 0,
      },
    },
  },
  container: {
    width: 1150,
    height: 650,
    position: 'absolute',
    top: 0,
    bottom: 0,
    right: 0,
    left: 0,
    margin: 'auto',
    background: muiTheme.palette.secondary.dark,
    overflow: 'none',
    borderRadius: 5,
  },
  closeButton: {
    position: 'absolute',
    top: 0,
    right: 0,
    color: muiTheme.palette.primary.main,
    padding: 10,
    background: 'transparent',
    minWidth: 32,
    zIndex: 999,
    boxShadow: 'none',
    '&:hover': {
      color: muiTheme.palette.primary.main,
      background: 'transparent',
      boxShadow: 'none',
      '& svg': {
        filter: 'brightness(0.6)',
        transition: 'filter ease-in 0.15s',
      },
    },
  },
}));

const App = () => {
  const hidden = useSelector(state => state.App.hidden);
  const page = useSelector(state => state.App.page);

  const classes = useStyles();

  const close = async () => {
    await Nui.send('Close');
  };

  return (
    <MuiThemeProvider theme={muiTheme}>
      <CssBaseline/>
      <HashRouter>
        <Fade in={!hidden} timeout={500}>
          <div className={classes.container}>
            <IconButton
              className={classes.closeButton}
              variant='contained'
              color='primary'
              onClick={close}
            >
              <CancelIcon style={{ fontSize: 30 }}/>
            </IconButton>
            <Switch>
              <Route exact key={'bank'} path={'/0'}>
                <Bank/>
              </Route>
              <Route exact key={'atm'} path={'/1'}>
                <ATM/>
              </Route>
            </Switch>
            <Redirect push to={'/' + page}/>
          </div>
        </Fade>
      </HashRouter>
    </MuiThemeProvider>
  );
};

export default App;
