import React, { useState } from 'react';
import Nui from '../../util/Nui';
import { makeStyles, Slider as MSlider, Tooltip, Grid } from '@material-ui/core';
import { CheckCircle } from '@material-ui/icons';

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
    padding: '10px 20px',
    borderRadius: 3,
    border: '1px solid rgba(0,0,0,0.1)',
    transition: '0.1s all linear',
    userSelect: 'none',
    background: '#3e4148a3',
    border: '2px solid #3e4148',
    color: '#ffffff',
    marginBottom: 5,
  },
  label: {
      display: 'block',
      width: '100%'
  },
  slider: {
      display: 'block',
      position: 'relative',
      top: '25%'
  },
  saveContainer: {
      textAlign: 'right',
      color: '#38b58fab',
      '&:hover': {
          color: '#38b58f59',
      }
  },
  icon: {
    width: '0.75em',
    height: '100%',
    fontSize: '1.25rem',
    float: 'right',
  },
}));

function ValueLabelComponent(props) {
    const { children, open, value } = props;
  
    return (
      <Tooltip open={open} enterTouchDelay={0} placement="top" title={value}>
        {children}
      </Tooltip>
    );
}

const Slider = (props) => {
    const classes = useStyles();
    const [currValue, setCurrValue] = useState(props.data.options.current);
    const [savedValue, setSavedValue] = useState(currValue);

    const onChange = (event, newValue) => {
        if(!props.data.disabled) {
            setCurrValue(newValue)
        }
    };

    const onSave = () => {
        if(!props.data.disabled && currValue != savedValue) {
            setSavedValue(currValue);
            Nui.send('FrontEndSound', {sound: 'SELECT'});
            Nui.send('Selected', {
                id: props.data.id,
                data: { value: currValue }
            });
        }
    };

    var cssClass = props.data.options.disabled ? `${classes.div} disabled` : classes.div; 
    var style = props.data.options.disabled ? { opacity: 0.5 } : {};

    return (
        <div className={cssClass} style={style}>
            <Grid container>
                <Grid item xs={2}></Grid>
                <Grid item xs={8}>
                    <span>{props.data.label}</span>
                </Grid>
                <Grid item xs={2} className={classes.saveContainer} onClick={onSave}>
                    { currValue == savedValue ? null : <CheckCircle className={classes.icon} /> }
                </Grid>
                <Grid item xs={12}>
                    <MSlider
                        className={classes.slider}
                        onChange={onChange}
                        ValueLabelComponent={ValueLabelComponent}
                        defaultValue={0}
                        value={currValue}
                        step={props.data.options.step != null ? props.data.options.step : 1}
                        min={props.data.options.min}
                        max={props.data.options.max}
                        component='div'
                    />
                </Grid>
            </Grid>
        </div>
    );
}

export default Slider;