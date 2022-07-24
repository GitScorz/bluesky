import React, { useEffect } from 'react';
import { connect, useSelector } from 'react-redux';
import PropTypes from 'prop-types';
import CssBaseline from '@material-ui/core/CssBaseline';
import { MuiThemeProvider, createTheme } from '@material-ui/core';
import { library } from '@fortawesome/fontawesome-svg-core';
import { fab } from '@fortawesome/free-brands-svg-icons';
import { fas } from '@fortawesome/free-solid-svg-icons';
import { Router } from 'react-router-dom';
import { createMemoryHistory } from 'history';
import Phone from '../Phone';

library.add(fas, fab);
const customHistory = createMemoryHistory();

import Stylized from '../../LLPIXEL3.ttf';

const StylizedFont = {
  fontFamily: 'Stylized',
  fontStyle: 'normal',
  fontDisplay: 'swap',
  fontWeight: 400,
  src: `
    url(${Stylized}) format('truetype')
  `
};

export default connect()((props) => {
  const clear = useSelector(state => state.phone.clear);
  const settings = useSelector(state => state.data.data.settings);

  useEffect(() => {
    if (clear) {
      setTimeout(() => {
        customHistory.replace('/');
        props.dispatch({ type: 'CLEARED_HISTORY' });
      }, 2000);
    }
  }, [clear])

  const muiTheme = createTheme({
    typography: {
      fontFamily: ['Roboto', 'sans-serif'],
    },
    palette: {
      primary: {
        main: settings != null && settings.colors != null ? settings.colors.accent : '#1a7cc1',
        light: settings != null && settings.colors != null ? settings.colors.accent : '#1a7cc1',
        dark: settings != null && settings.colors != null ? settings.colors.accent : '#1a7cc1',
        contrastText: '#ffffff',
      },
      secondary: {
        main: '#18191e',
        light: '#2e3037',
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
        light: '#ffffff',
        dark: '#000000',
      },
			border: {
				main: '#e0e0e008',
				light: '#ffffff',
				dark: '#26292d',
				input: 'rgba(255, 255, 255, 0.23)',
				divider: 'rgba(255, 255, 255, 0.12)'
			},
      type: 'dark',
    },
    overrides: {
      MuiCssBaseline: {
        '@global': {
          '@font-face': [StylizedFont],
        },
      },
    },
  });
  return (
    <MuiThemeProvider theme={muiTheme}>
      <CssBaseline />
      <Router navigator={customHistory}>
        <Phone />
      </Router>
    </MuiThemeProvider>
  );
});