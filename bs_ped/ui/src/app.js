import '@babel/polyfill';

import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import CssBaseline from '@material-ui/core/CssBaseline';
import { createMuiTheme, MuiThemeProvider } from '@material-ui/core';

import App from 'containers/App';

import WindowListener from 'containers/WindowListener';

import configureStore from './configureStore';

const initialState = {};
const store = configureStore(initialState);
const MOUNT_NODE = document.getElementById('app');

const render = () => {
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
  ReactDOM.render(
    <Provider store={store}>
      <WindowListener>
        <MuiThemeProvider theme={muiTheme}>
          <CssBaseline />
          <App />
        </MuiThemeProvider>
      </WindowListener>
    </Provider>,
    MOUNT_NODE,
  );
};

if (module.hot) {
  module.hot.accept(['containers/App'], () => {
    ReactDOM.unmountComponentAtNode(MOUNT_NODE);
    render();
  });
}

render();
