import React from 'react';
import { makeStyles } from '@material-ui/core';
import { connect, useSelector } from 'react-redux';
import { moveSlot, moveToNextSecondary } from './actions';
let fuckingDone = false;

const useStyles = makeStyles(theme => ({
    slotWrap: {
        display: 'inline-block',
        margin: 5,
        boxSizing: 'border-box',
        flexGrow: 0,
        width: 140,
        flexBasis: 140,
        zIndex: 1,
    },
    slot: {
        width: '100%',
        height: 140,
        border: `1px solid ${theme.palette.secondary.light}`,
        position: 'relative',
        zIndex: 2,
    },
    slotDrag: {
        width: '100%',
        height: 140,
        border: `1px solid ${theme.palette.primary.main}`,
        position: 'relative',
        zIndex: 2,
        opacity: 0.35,
        transition: 'opacity ease-in 0.15s, border ease-in 0.15s',
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
    label: {
        top: 0,
        left: 0,
        position: 'absolute',
        textAlign: 'left',
        padding: '0 5px',
        maxWidth: '116px',
        overflow: 'hidden',
        whiteSpace: 'nowrap',
        color: theme.palette.text.dark,
        background: theme.palette.secondary.main,
        borderRight: `1px solid ${theme.palette.secondary.light}`,
        borderBottom: `1px solid ${theme.palette.secondary.light}`,
        zIndex: 4,
    },
    labelNoHotKey: {
        top: 0,
        left: 0,
        position: 'absolute',
        textAlign: 'left',
        padding: '0 5px',
        maxWidth: '100%',
        overflow: 'hidden',
        whiteSpace: 'nowrap',
        color: theme.palette.text.dark,
        background: theme.palette.secondary.main,
        borderRight: `1px solid ${theme.palette.secondary.light}`,
        borderBottom: `1px solid ${theme.palette.secondary.light}`,
        zIndex: 4,
    },
    hotkey: {
        top: 0,
        right: 0,
        position: 'absolute',
        padding: '0 5px',
        width: '20px',
        color: theme.palette.primary.main,
        background: theme.palette.secondary.main,
        borderLeft: `1px solid ${theme.palette.secondary.light}`,
        borderBottom: `1px solid ${theme.palette.secondary.light}`,
        zIndex: 4,
    },

    default: {
        backgroundColor: 'rgba(50, 50, 50, 0.38)',
    },
    player: {
        backgroundColor: 'rgba(71, 0, 61, 0.38)',
    },
    temp: {
        backgroundColor: 'rgba(71, 0, 0, 0.38)',
    },
    storage: {
        backgroundColor: 'rgba(0, 45, 71, 0.38)',
    },
    evidence: {
        backgroundColor: 'rgba(71, 48, 0, 0.38)',
    },
    shop: {
        backgroundColor: 'rgba(0, 71, 4, 0.38)',
    },
    used: {
        backgroundColor: 'rgba(71, 0, 0, 0.58)',
    },
}));

export default connect()(props => {
    const classes = useStyles();
    const hover = useSelector(state => state.inventory.hover);
    const hoverOrigin = useSelector(state => state.inventory.hoverOrigin);
    const showSecondary = useSelector(state => state.inventory.showSecondary);
    const secondaryInventory = useSelector(state => state.inventory.secondary);
    const playerInventory = useSelector(state => state.inventory.player);
    const showing = useSelector(state => state.app.showing);

    let slotStyle = null;
    switch (props.invType) {
        case 1:
            slotStyle = classes.player;
            break;
        case 2:
            slotStyle = classes.storage;
            break;
        case 8:
            slotStyle = classes.evidence;
            break;
        case 9:
            slotStyle = classes.temp;
            break;
        case 11:
            slotStyle = classes.shop;
            break;
        default:
            slotStyle = classes.default;
            break;
    }

    const moveItem = () => {
        if (
            hoverOrigin.slot !== props.slot ||
            hoverOrigin.owner !== props.owner
        ) {
            moveSlot(
                hoverOrigin.owner,
                props.owner,
                hoverOrigin.slot,
                props.slot,
                hoverOrigin.invType,
                props.invType,
                hoverOrigin.Name,
                hoverOrigin.Count,
                hover.Count,
            );
        }

        props.dispatch({
            type: 'SET_HOVER',
            payload: null,
        });
        props.dispatch({
            type: 'SET_HOVER_ORIGIN',
            payload: null,
        });
    };

    const onMouseDown = event => {
        if (hoverOrigin == null) {
            if (props.data.Name == null) return;
            if (event.button !== 0) return;

            if (event.shiftKey && showSecondary) {
                {
                    props.invType == 1
                        ? moveToNextSecondary(
                                props.owner,
                                secondaryInventory.owner,
                                props.slot,
                                props.invType,
                                secondaryInventory.invType,
                                props.data.Name,
                                props.data.Count,
                            )
                        : moveToNextSecondary(
                                secondaryInventory.owner,
                                playerInventory.owner,
                                props.slot,
                                secondaryInventory.invType,
                                1,
                                props.data.Name,
                                props.data.Count,
                            );
                }
            } else {
                props.dispatch({
                    type: 'SET_HOVER',
                    payload: {
                        Name: props.data.Name,
                        Image: props.data.Image,
                        Label: props.data.Label,
                        Count: props.data.Count,
                    },
                });
                props.dispatch({
                    type: 'SET_HOVER_ORIGIN',
                    payload: {
                        slot: props.slot,
                        owner: props.owner,
                        invType: props.invType,
                        ...props.data,
                    },
                });
            }
        } else {
            moveItem();
        }
    };

    const onMouseUp = event => {
        if (hoverOrigin == null) return;
        if (event.button !== 0) return;
        moveItem();
    };

    if (showing !== null && showing == props.slot && props.inHotbar) {
        slotStyle = classes.used;
    }
    

    return (
        <div
            className={classes.slotWrap}
            onMouseDown={onMouseDown}
            onMouseUp={onMouseUp}
            onContextMenu={props.onContextMenu}
        >
            <div
                className={`${classes.slot} ${slotStyle}${
                    hoverOrigin != null &&
                    hoverOrigin.slot === props.slot &&
                    hoverOrigin.owner === props.owner
                        ? ` ${classes.slotDrag}`
                        : ''
                }`}
            >
                {props.data.Image !== undefined ? (
                    <div
                        className={classes.img}
                        style={{
                            backgroundImage:
                                'url(../images/items/' + props.data.Image + ')',
                        }}
                    ></div>
                ) : null}
                {props.data.Name !== undefined ? (
                    <div className={classes.label}>{props.data.Label}</div>
                ) : null}
                {props.data.Count !== undefined && props.data.Count > 0 ? (
                    <div className={classes.count}>{props.data.Count}</div>
                ) : null}
                {props.hotkeys && props.slot <= 5 ? (
                    <div className={classes.hotkey}>{props.slot}</div>
                ) : null}

                {props.hotkeys && props.slot <= 5 ? (
                    <div className={classes.label}>{props.data.Label}</div>
                ) : (
                    <div className={classes.labelNoHotKey}>
                        {props.data.Label}
                    </div>
                )}
            </div>
        </div>
    );
});
