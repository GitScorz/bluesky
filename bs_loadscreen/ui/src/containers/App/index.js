import React from 'react';
import { MuiThemeProvider, createMuiTheme } from '@material-ui/core';
import CssBaseline from '@material-ui/core/CssBaseline';

import Loadscreen from '../Loadscreen';

import Stylized from '../../font.ttf';
const StylizedFont = {
  fontFamily: 'Stylized',
  fontStyle: 'normal',
  fontDisplay: 'swap',
  fontWeight: 400,
  src: `url(${Stylized}) format('truetype')`,
};

export default props => {
  const muiTheme = createMuiTheme({
    palette: {
      primary: {
        main: '#00d8ff',
        light: '#00c0ff',
        dark: '#0093ae',
        contrastText: '#ffffff',
      },
      secondary: {
        main: '#222222',
        light: '#2e2e2e',
        dark: '#191919',
        contrastText: '#ffffff',
      },
      error: {
        main: '#c75050',
        light: '#f77272',
        dark: '#802828',
      },
      success: {
        main: '#52984a',
        light: '#60eb50',
        dark: '#244a20',
      },
      warning: {
        main: '#f09348',
        light: '#f2b583',
        dark: '#b05d1a',
      },
      text: {
        main: '#ffffff',
        light: '#ffffff',
        dark: '#000000',
      },
      type: 'dark',
    },
    overrides: {
      MuiCssBaseline: {
        '@global': {
          '@font-face': [StylizedFont],
          'body': {
            margin: 0,
            padding: 0,
            fontFamily: 'sans-serif',
            overflow: 'hidden',
          }
        },
      },
    },
  });

  return (
    <MuiThemeProvider theme={muiTheme}>
      <CssBaseline />
      <Loadscreen />
    </MuiThemeProvider>
  );
};
