import React, { Fragment, useEffect } from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/core';

const initialState = {
    mouseX: null,
    mouseY: null,
};
const useStyles = makeStyles(theme => ({
    hover: {
        position: 'absolute',
        top: 0,
        left: 0,
        pointerEvents: 'none',
        zIndex: 1,
    },
    img: {
        height: 140,
        width: '100%',
        overflow: 'hidden',
        zIndex: 3,
        backgroundSize: '70%',
        backgroundRepeat: 'no-repeat',
        backgroundPosition: 'center center',
    },
    label: {
        top: 0,
        left: 0,
        width: '100%',
        position: 'absolute',
        textAlign: 'center',
        padding: '0 5px',
        color: theme.palette.text.dark,
        background: theme.palette.secondary.main,
        borderRight: `1px solid ${theme.palette.secondary.light}`,
        borderBottom: `1px solid ${theme.palette.secondary.light}`,
        zIndex: 4,
    },
    slot: {
        width: '140px',
        height: '140px',
        backgroundColor: 'rgba(50, 50, 50, 0.38)',
        border: `1px solid ${theme.palette.secondary.light}`,
        position: 'relative',
        zIndex: 2,
    },
    count: {
        bottom: 0,
        left: 0,
        position: 'absolute',
        textAlign: 'right',
        padding: '0 5px',
        color: theme.palette.primary.main,
        background: theme.palette.secondary.main,
        borderRight: `1px solid ${theme.palette.secondary.light}`,
        borderTop: `1px solid ${theme.palette.secondary.light}`,
        zIndex: 4,
    },
}));

export default props => {
    const classes = useStyles();
    const [state, setState] = React.useState(initialState);

    const hover = useSelector(state => state.inventory.hover);

    const mouseMove = event => {
        event.preventDefault();
        setState({
            mouseX: event.clientX,
            mouseY: event.clientY,
        });
    };
    useEffect(() => {
        document.addEventListener('mousemove', mouseMove);
        return () => document.removeEventListener('mousemove', mouseMove);
    }, []);

    if (hover) {
        return (
            <div
                className={classes.hover}
                style={
                    state.mouseY !== null && state.mouseX !== null
                        ? {
                              top: state.mouseY,
                              left: state.mouseX,
                              transform: 'translate(-50%, -50%)',
                          }
                        : undefined
                }
            >
                <div className={classes.slot}>
                    <div
                        className={classes.img}
                        style={{
                            backgroundImage:
                                'url(../images/items/' + hover.Image + ')',
                        }}
                    ></div>
                    {hover.Label !== undefined ? (
                        <div className={classes.label}>{hover.Label}</div>
                    ) : null}
                    {hover.Count !== undefined && hover.Count > 0 ? (
                        <div className={classes.count}>{hover.Count}</div>
                    ) : null}
                </div>
            </div>
        );
    } else {
        return <Fragment />;
    }
};
