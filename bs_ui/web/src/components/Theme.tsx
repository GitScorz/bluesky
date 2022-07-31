import { createTheme } from '@mui/material/styles'

const Theme = createTheme({
    components: {
        MuiTooltip: {
            defaultProps: {
                arrow: true,
            },
            styleOverrides: {
                tooltip: {
                    fontSize: '1rem',
                }
            }
        },
        MuiInput: {
            styleOverrides: {
                underline: {
                    color: '#fff',
                    borderBottom: '1px solid #fff',
                }
            }
        }
    },
    palette: {
        primary: {
            main: '#fff',
        },
        text: {
            secondary: 'white',
        },
    },
});

export default Theme;