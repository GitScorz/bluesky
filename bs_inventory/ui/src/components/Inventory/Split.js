import React, { useEffect, useState } from 'react';
import { makeStyles, TextField, ButtonGroup, Button } from '@material-ui/core';
import { useDispatch } from 'react-redux';
import { dropItem, sendNotify } from './actions';

const useStyles = makeStyles(theme => ({
    wrapper: {
        padding: 25,
    },
    input: {
        width: '100%',
        height: '100%',
    },
    quickActions: {
        marginTop: 15,
        textAlign: 'center',
    },
}));

export default React.forwardRef((props, ref) => {
    const classes = useStyles();
    const dispatch = useDispatch();

    const [val, setVal] = useState(props.data.item.Count);

    useEffect(() => {
        return () => {
            setVal(0);
        };
    }, []);

    const onChange = e => {
        setVal(e.target.value > props.data.item.Count ? props.data.item.Count : Math.floor(e.target.value));
    };

    const setAmount = (amount) => {
        setVal(Math.floor(amount));
    }

    const drag = e => {
        dispatch({
            type: 'SET_HOVER',
            payload: {
                Name: props.data.item.Name,
                Image: props.data.item.Image,
                Label: props.data.item.Label,
                Count: Math.floor(val)
            },
        });
        dispatch({
            type: 'SET_HOVER_ORIGIN',
            payload: {
                slot: props.data.item.Slot,
                owner: props.data.owner,
                invType: props.data.invType,
                ...props.data.item,
            },
        });
        dispatch({
            type: 'SET_SPLIT_ITEM',
            payload: null,
        });
    };

    const drop = e => {
        if (e != null) e.preventDefault();
        if(Math.floor(val) <= props.data.item.Count) {
            dropItem(props.data.owner, props.data.item.Slot, props.data.invType, Math.floor(val))
            dispatch({
                type: 'SET_SPLIT_ITEM',
                payload: null,
            });
        } else {
            sendNotify('error', 'You do not have enough of that item to drop', 3500);
        }
    }

    return (
        <div className={classes.wrapper}>
            <div className={classes.inputWrap}>
                <TextField
                    className={classes.input}
                    label="Amount"
                    type="number"
                    value={val}
                    inputProps={{
                        min: 0
                    }}
                    onChange={onChange}
                />
            </div>
            <div className={classes.quickActions}>
                <ButtonGroup variant="contained" color="secondary">
                    <Button onClick={() => setAmount(1)}>Single</Button>
                    <Button onClick={() => setAmount(props.data.item.Count / 4 < 1 ? 1 : props.data.item.Count / 4)}>1/4</Button>
                    <Button onClick={() => setAmount(props.data.item.Count / 2 < 1 ? 1 : props.data.item.Count / 2)}>1/2</Button>
                    <Button onClick={() => setAmount(props.data.item.Count)}>Max</Button>
                </ButtonGroup>
            </div>
            <div className={classes.quickActions}>
                <ButtonGroup size="large" variant="contained" color="secondary">
                {props.data.invType == 1 ? (
                    <Button onClick={drop}>Drop</Button>
                ) : null}
                    <Button onClick={drag}>Move</Button>
                </ButtonGroup>
            </div>
        </div>
    );
});
