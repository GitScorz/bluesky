import React from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import CssBaseline from '@material-ui/core/CssBaseline';
import { MuiThemeProvider, createMuiTheme } from '@material-ui/core';
import { ToastContainer } from 'react-toastify';
import Action from '../Action';
import Hud from '../Hud';
import 'react-toastify/dist/ReactToastify.css';

const App = ({ hidden }) => {
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
        light: '#131317',
        dark: '#1e1f24',
        contrastText: '#cecece',
      },
      error: {
        main: '#c75050',
        light: '#d87c4f',
        dark: '#479c87',
      },
      text: {
        main: '#cecece',
        light: '#000000',
        dark: '#ffffff',
      },
      type: 'dark',
    },
  });
  return (
    <MuiThemeProvider theme={muiTheme}>
      <CssBaseline />
      <Hud />
      <Action />
      <ToastContainer
        position="top-right"
        autoClose={3000}
        hideProgressBar={false}
        newestOnTop={false}
        rtl={false}
        pauseOnVisibilityChange={false}
        draggable={false}
        pauseOnHover={false}
        closeButton={false}
      />
    </MuiThemeProvider>
  );
};

App.propTypes = {
  hidden: PropTypes.bool.isRequired,
};

const mapStateToProps = state => ({ hidden: state.app.hidden });

export default connect(mapStateToProps)(App);
