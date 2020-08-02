/* eslint-disable jsx-a11y/no-static-element-interactions */
/* eslint-disable jsx-a11y/click-events-have-key-events */
/* eslint-disable react/prop-types */
import React, { useState } from 'react';
import { makeStyles, TextField } from '@material-ui/core';
import Nui from '../../util/Nui';

const useStyles = makeStyles(() => ({
    div: {
        width: '100%',
        height: 84,
        fontSize: 13,
        fontWeight: 500,
        textAlign: 'center',
        textDecoration: 'none',
        textShadow: 'none',
        whiteSpace: 'nowrap',
        display: 'inline-block',
        verticalAlign: 'middle',
        padding: '10px 20px',
        borderRadius: 3,
        transition: '0.1s all linear',
        userSelect: 'none',
        background: '#3e4148a3',
        border: '2px solid #3e4148',
        color: '#ffffff',
        marginBottom: 5,
        '&:hover:not(.disabled)': {
            background: '#3e414847',
            border: '2px solid #3e4148',
        },
    },
    input: {
        width: '100%',
    },
}));

export default props => {
    const classes = useStyles();
    const [value, setValue] = useState(
        props.data.options.current == null ? '' : props.data.options.current,
    );

    const onChange = event => {
        setValue(event.target.value);
        Nui.send('Selected', {
            id: props.data.id,
            data: { value: event.target.value },
        });
    };

    const cssClass = props.data.options.disabled
        ? `${classes.div} disabled`
        : classes.div;
    const style = props.data.options.disabled ? { opacity: 0.5 } : {};

    return (
        <div className={cssClass} style={style}>
            <TextField
                label={props.data.label}
                disabled={props.data.options.disabled}
                value={value}
                onChange={onChange}
                className={classes.input}
                
          type="number"
            />
        </div>
    );
};
