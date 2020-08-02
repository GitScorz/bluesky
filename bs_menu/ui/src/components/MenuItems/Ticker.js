import React, { useState } from 'react';
import Nui from '../../util/Nui';
import { makeStyles, Grid, TextField } from '@material-ui/core';

import { ArrowBackIos, ArrowForwardIos } from '@material-ui/icons';

const useStyles = makeStyles(theme => ({
    div: {
        width: "100%",
        height: 84,
        fontSize: 13,
        fontWeight: 500,
        textAlign: 'center',
        textDecoration: 'none',
        textShadow: 'none',
        whiteSpace: 'nowrap',
        display: 'inline-block',
        verticalAlign: 'middle',
        borderRadius: 3,
        border: '1px solid rgba(0,0,0,0.1)',
        transition: '0.1s all linear',
        userSelect: 'none',
        background: '#3e4148a3',
        border: '2px solid #3e4148',
        color: '#ffffff',
        marginBottom: 5,
        lineHeight: '38px'
    },
    slider: {
        display: 'block',
        position: 'relative',
        top: '25%'
    },
    action: {
        height: 38,
        height: 80,
        lineHeight: '100px',
        '&:hover': {
            filter: 'brightness(0.6)',
            transition: 'filter ease-in 0.15s'
        }
    },
    textField: {
        width: 25,
        '& input': {
            textAlign: 'center',
            color: theme.palette.primary.main
        },
        '& input::-webkit-clear-button, & input::-webkit-outer-spin-button, & input::-webkit-inner-spin-button': {
                display: 'none'
         }
    },
    wrapper: {
        display: 'grid',
        gridGap: 0,
        gridTemplateColumns: '20% 60% 20%',
        gridTemplateRows: '40px 40px'
    }
}));

const Ticker = (props) => {
    const classes = useStyles();
    const [value, setValue] = useState(props.data.options.current);

    const onLeft = () => {
        if(value == 0) {
            setValue(props.data.options.max);
        } else {
            setValue(value - 1)
        }
        Nui.send('FrontEndSound', {sound: 'UPDOWN'});
        Nui.send('Selected', {
            id: props.data.id,
            data: { value: value === 0 ? props.data.options.max : value - 1 }
        });
    };
    
    const onRight = () => {
        if(value == props.data.options.max) {
            setValue(props.data.options.min);
        } else {
            setValue(value + 1);
        }

        Nui.send('FrontEndSound', {sound: 'UPDOWN'});
        Nui.send('Selected', {
            id: props.data.id,
            data: { value: value === props.data.options.max ? props.data.options.min : value + 1 }
        });
    };
    
    const updateIndex = (event) => {
        if (!props.data.options.disabled) {
            let v = parseInt(event.target.value, 10);
            
            if (isNaN(v)) {
                setValue(props.data.options.min);
                Nui.send('Selected', {
                    id: props.data.id,
                    data: { value: props.data.options.min }
                });
                return;
            } else {
                if (event.target.value > props.data.options.max) {
                  v = props.data.options.max;
                } else if (event.target.value < props.data.options.min) {
                  v = props.data.options.max;
                }
                console.log('whoer')
                setValue(v);
                Nui.send('Selected', {
                    id: props.data.id,
                    data: { value: v }
                });
            }
        }
    };

    var cssClass = props.data.options.disabled ? `${classes.div} disabled` : classes.div; 
    var style = props.data.options.disabled ? { opacity: 0.5 } : {};

    return (
        <div className={cssClass} style={style}>
            <div className={classes.wrapper}>
                <div style={{ gridColumn: 2, gridRow: 1 }}>
                    {props.data.label}
                </div>
                <div className={classes.action} onClick={onLeft} style={{ gridColumn: 1, gridRow: '1 / 2' }}>
                    <ArrowBackIos />
                </div>
                <div style={{ gridColumn: 2, gridRow: 2 }}>
                    <TextField
                        value={value}
                        className={classes.textField}
                        onChange={updateIndex}
                        disabled={props.data.options.disabled}
                        type='number'
                        inputProps={{ min: props.data.options.min, max: props.data.options.max, step: 1 }}
                /> / {props.data.options.max}
                </div>
                <div className={classes.action} onClick={onRight} style={{ gridColumn: 3, gridRow: '1 / 2' }}>
                    <ArrowForwardIos />
                </div>
            </div>
        </div>
    );
}

export default Ticker;