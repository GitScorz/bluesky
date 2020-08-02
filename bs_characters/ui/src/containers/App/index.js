import React from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import CssBaseline from '@material-ui/core/CssBaseline';
import { MuiThemeProvider, createMuiTheme, Fade } from '@material-ui/core';

import Loader from '../Loader/Loader';
import Splash from '../Splash/Splash';
import Characters from '../Characters/Characters';
import Create from '../Create/Create';
import Spawn from '../Spawn/Spawn';

import { STATE_CHARACTERS, STATE_CREATE, STATE_SPAWN } from '../../util/States';

const App = ({ hidden, loading, state }) => {
  const muiTheme = createMuiTheme({
    typography: {
      fontFamily: ['Kanit', 'sans-serif'],
    },
    palette: {
      primary: {
        main: '#3aaaf9',
        light: '#3aaaf9',
        dark: '#3aaaf9',
        contrastText: '#ffffff',
      },
      secondary: {
        main: '#18191e',
        light: '#18191e',
        dark: '#1e1f24',
        contrastText: '#cecece',
      },
      error: {
        main: '#c75050',
        light: '#c75050',
        dark: '#c75050',
      },
      text: {
        main: '#cecece',
        light: '#000000',
        dark: '#ffffff',
      },
      type: 'dark',
    },
  });

  let display;

  switch (state) {
    case STATE_CHARACTERS:
      display = <Characters />;
      break;
    case STATE_CREATE:
      display = <Create />;
      break;
    case STATE_SPAWN:
      display = <Spawn />;
      break;
    default:
      display = <Splash />;
      break;
  }

  return (
    <MuiThemeProvider theme={muiTheme}>
      <CssBaseline />
      <Fade in={!hidden}>
        <div className="App">
          {loading ? <Loader /> : display}
        </div>
      </Fade>
    </MuiThemeProvider>
  );
};

App.propTypes = {
  hidden: PropTypes.bool.isRequired,
  loading: PropTypes.bool.isRequired,
  state: PropTypes.string.isRequired,
};

const mapStateToProps = state => ({
  hidden: state.app.hidden,
  loading: state.loader.loading,
  state: state.app.state,
});

export default connect(mapStateToProps)(App);
