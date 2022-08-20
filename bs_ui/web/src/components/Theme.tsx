import { createTheme } from "@mui/material/styles";

const Theme = createTheme({
  components: {
    MuiTooltip: {
      defaultProps: {
        arrow: true,
      },
      styleOverrides: {
        tooltip: {
          fontSize: "1rem",
        },
      },
    },
    MuiInput: {
      styleOverrides: {
        underline: {
          color: "#fff",
          borderBottom: "1px solid #fff",
        },
      },
    },
    MuiButton: {
      styleOverrides: {
        root: {
          boxShadow: "1px 1px 5px #000",
        },
      },
    },
    MuiSelect: {
      styleOverrides: {
        icon: {
          color: "#fff",
        },
      },
    },
  },
  palette: {
    primary: {
      main: "#fff",
    },
    text: {
      secondary: "white",
    },
  },
});

export default Theme;
