import React, { useEffect, useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { makeStyles, Input, Grid, Button, IconButton } from '@material-ui/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import InputMask from 'react-input-mask';
import { green } from '@material-ui/core/colors';

import { showAlert } from '../../actions/alertActions';
import { createCall } from './action';

import BackspaceIcon from '@material-ui/icons/Backspace';
import PhoneIcon from '@material-ui/icons/Phone';

const useStyles = makeStyles(theme => ({
    wrapper: {
        height: '100%',
        background: theme.palette.secondary.main,
    },
    number: {
        marginBottom: '10%',
    },
    numInput: {
        width: '100%',
    },
    callinfo: {
        textAlign: 'center',
        fontSize: 20,
        color: theme.palette.text.secondary,
        margin: 20,
    },
    keypadBtn: {
        textAlign: 'center',
        height: 75,
        fontSize: '25px',
        width: '100%',
    },
    keypadAction: {
        padding: 20,
        color: theme.palette.getContrastText(green[500]),
        backgroundColor: green[500],
        '&:hover': {
            backgroundColor: green[700],
        },
    },
    keypadActionDis: {
        padding: 20,
        color: theme.palette.getContrastText(green[500]),
        backgroundColor: green[500],
        filter: 'brightness(0.25)',
        '&:hover': {
            backgroundColor: green[700],
        },
    },
    backBtn: {
        margin: 'auto',
        textAlign: 'center',
    },
    anonSymbol: {
        fontSize: 35,
        color: theme.palette.primary.main,
        textAlign: 'right',
    }
}));

export default connect(null, { showAlert, createCall })((props) => {
    const classes = useStyles();
    const navigate = useNavigate()
    const data = useSelector(state => state.data.data);
    const myData = data.myData;
    const callData = useSelector(state => state.call.call);

    const [contacts, setContacts] = useState([]);
    useEffect(() => {
        setContacts(data.contacts);
    }, [data]);

    const [isAnon, setIsAnon] = useState(false);
    const [dialNumber, setDialNumber] =  useState('');
    const [isContact, setIsContact] = useState([]);

    useEffect(() => {
        if (dialNumber != '')
            setIsContact(contacts.filter((c) => c.number.startsWith(dialNumber.replace(/\_/g, ''))));
        else
            setIsContact([]);
    }, [dialNumber]);

    const toggleAnon = e => {
        setIsAnon(!isAnon);
    }

	const onChange = e => {
        setDialNumber(e.target.value);
    };
    
    const onBackClick = e => {
        setDialNumber(dialNumber.substring(0, dialNumber.length - 1));
    }

    const startcall = e => {
        if (dialNumber.length == 12)
            if (dialNumber !== myData.number) {
                if (callData == null) {
                    props.createCall(dialNumber);
                    navigate(`/apps/phone/call/${dialNumber}`);
                }
            } else {
                props.showAlert('Cannot Call Yourself, Idiot');
            }
    }

    const btnClick = value => { // TODO : Make this less fucking retarded
        let tmp = (dialNumber.replace(/\-/g, '').replace(/\_/g, '')) + value;
        if (tmp.length <= 10)
        {
            if (tmp.length > 3 && tmp.length < 7)
                setDialNumber(tmp.replace(/(\d{3})(\d{1,3})/, '$1-$2'));
            else
                setDialNumber(tmp.replace(/(\d{3})(\d{3})(\d{1,4})/, '$1-$2-$3'));
        }
    }   

    return (
        <div className={classes.wrapper}>
            <div className={classes.number}>
                <Grid container spacing={1}>
                    <Grid item xs={12} className={classes.callinfo}>
                        { isAnon ? 'Anonymous' : 'Standard' }
                    </Grid>
                    <Grid item xs={12} className={classes.callinfo}>
                        { isContact.length > 0 ? 
                            (isContact.length > 1 ? 'Matches Multiple Contacts' : isContact[0].name) : 'Unknown'
                        }
                    </Grid>
                    <Grid item xs={1} className={classes.anonSymbol}>
                        { isAnon ? <div>#</div> : null }
                    </Grid>
                    <Grid item xs={8}>
                        <InputMask
                            mask="999-999-9999"
                            value={dialNumber}
                            onChange={onChange}
                        >
                            {() => (
                                <Input
                                    className={classes.numInput}
                                    name="number"
                                    type="text"
                                    disableUnderline
                                    placeholder='___-___-____'
                                    inputProps={{
                                        style: { fontSize: 40 }
                                    }}
                                />
                            )}
                        </InputMask>
                    </Grid>
                    <Grid item xs={3} className={classes.backBtn}>
                        <IconButton onClick={onBackClick} style={{padding: 20}}>
                            <BackspaceIcon />
                        </IconButton>
                    </Grid>
                </Grid>
            </div>
            <Grid container spacing={1}>
                <Grid item xs={4}>
                    <Button color="primary" className={classes.keypadBtn} onClick={() => btnClick(1)}>1</Button>
                </Grid>
                <Grid item xs={4}>
                    <Button color="primary" className={classes.keypadBtn} onClick={() => btnClick(2)}>2</Button>
                </Grid>
                <Grid item xs={4}>
                    <Button color="primary" className={classes.keypadBtn} onClick={() => btnClick(3)}>3</Button>
                </Grid>
                <Grid item xs={4}>
                    <Button color="primary" className={classes.keypadBtn} onClick={() => btnClick(4)}>4</Button>
                </Grid>
                <Grid item xs={4}>
                    <Button color="primary" className={classes.keypadBtn} onClick={() => btnClick(5)}>5</Button>
                </Grid>
                <Grid item xs={4}>
                    <Button color="primary" className={classes.keypadBtn} onClick={() => btnClick(6)}>6</Button>
                </Grid>
                <Grid item xs={4}>
                    <Button color="primary" className={classes.keypadBtn} onClick={() => btnClick(7)}>7</Button>
                </Grid>
                <Grid item xs={4}>
                    <Button color="primary" className={classes.keypadBtn} onClick={() => btnClick(8)}>8</Button>
                </Grid>
                <Grid item xs={4}>
                    <Button color="primary" className={classes.keypadBtn} onClick={() => btnClick(9)}>9</Button>
                </Grid>
                <Grid item xs={4}>
                    <Button color="primary" className={classes.keypadBtn} disabled>*</Button>
                </Grid>
                <Grid item xs={4} className={classes.keypadBtn}>
                    <Button color="primary" className={classes.keypadBtn} onClick={() => btnClick(0)}>0</Button>
                </Grid>
                <Grid item xs={4} className={classes.keypadBtn}>
                    <Button color="primary" className={classes.keypadBtn} onClick={toggleAnon}>#</Button>
                </Grid>
                <Grid item xs={12} className={classes.keypadBtn}>
                    <IconButton className={dialNumber.replace(/\_/g, '').length == 12 && callData == null ? classes.keypadAction : classes.keypadActionDis} onClick={startcall}>
                        <PhoneIcon style={{ fontSize: 40 }} />
                    </IconButton>
                </Grid>
            </Grid>
        </div>
    );
});
