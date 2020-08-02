import React, { useState } from 'react';
import { connect, useSelector } from 'react-redux';
import Typography from '@material-ui/core/Typography';
import CssBaseline from '@material-ui/core/CssBaseline';
import { MuiThemeProvider, createMuiTheme, Fade } from '@material-ui/core';
import Warning from '../components/Warning';
import Hud from '../components/Hud';


export default connect()((props) => {
  const muiTheme = createMuiTheme({
    typography: {
      fontFamily: ['Kanit', 'sans-serif'],
    },
    palette: {
      primary: {
        main: 'rgb(0, 216, 255)',
        light: 'rgb(0, 216, 255)',
        dark: 'rgb(0, 216, 255)',
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

  return (<div>
        <MuiThemeProvider theme={muiTheme}>
          <CssBaseline />
          <Warning />
          <Hud />
        </MuiThemeProvider>
        </div>);
});
