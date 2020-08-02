/* eslint-disable react/prop-types */
import React, { useState } from 'react';
import { Grid, makeStyles, Slider as MSlider, Tooltip } from '@material-ui/core';
import { CheckCircle } from '@material-ui/icons';
import Nui from '../../../util/Nui';
import { connect } from 'react-redux';

const useStyles = makeStyles((theme) => ({
  div: {
    width: '100%',
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
    color: '#ffffff',
    marginBottom: 5,
  },
  label: {
    display: 'block',
    width: '100%',
  },
  slider: {
    display: 'block',
    position: 'relative',
    top: '25%',
  },
  saveContainer: {
    textAlign: 'right',
    color: '#38b58fab',
    '&:hover': {
      color: '#38b58f59',
    },
  },
  icon: {
    width: '0.75em',
    height: '100%',
    fontSize: '1.25rem',
    float: 'right',
    color: theme.palette.error.main
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

export default connect()(props => {
  const classes = useStyles();
  const [currentValue, setCurrentValue] = useState(props.current);

  const onChange = (event, newValue) => {
    if (!props.disabled) {
      setCurrentValue(newValue);
    }
  };

  const onSave = () => {
    if (!props.disabled && props.current !== currentValue) {
      Nui.send('FrontEndSound', { sound: 'SELECT' });
      props.dispatch(props.event(currentValue, props.data));
    }
  };

  const cssClass = props.disabled
    ? `${classes.div} disabled`
    : classes.div;
  const style = props.disabled ? { opacity: 0.5 } : {};

  return (
    <div className={cssClass} style={style}>
      <Grid container>
        <Grid item xs={2}/>
        <Grid item xs={8}>
          <span>{props.label}</span>
        </Grid>
        <Grid item xs={2} className={classes.saveContainer} onClick={onSave}>
          {currentValue === props.current ? null : (
            <CheckCircle className={classes.icon}/>
          )}
        </Grid>
        <Grid item xs={12}>
          <MSlider
            className={classes.slider}
            onChange={onChange}
            ValueLabelComponent={ValueLabelComponent}
            defaultValue={0}
            value={currentValue}
            disabled={props.disabled}
            step={1}
            min={props.min}
            max={props.max}
            component="div"
          />
        </Grid>
      </Grid>
    </div>
  );
});
