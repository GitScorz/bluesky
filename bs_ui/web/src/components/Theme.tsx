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
        }
    }
});

export default Theme;