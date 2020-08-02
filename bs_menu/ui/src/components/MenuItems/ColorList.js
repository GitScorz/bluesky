import React, { useState } from 'react';
import { makeStyles, Grid, Fade } from '@material-ui/core';
import { ExpandMore } from '@material-ui/icons';
import Nui from '../../util/Nui';

const useStyles = makeStyles(theme => ({
  div: {
    width: '100%',
    height: 42,
    fontSize: 13,
    fontWeight: 500,
    textAlign: 'center',
    textDecoration: 'none',
    textShadow: 'none',
    whiteSpace: 'nowrap',
    display: 'inline-block',
    verticalAlign: 'middle',
    borderRadius: 3,
    transition: '0.1s all linear',
    userSelect: 'none',
    background: '#3e4148a3',
    border: '2px solid #3e4148',
    color: '#ffffff',
    marginBottom: 5,
    lineHeight: '38px',
    '&:hover:not(.disabled)': {
      background: '#3e414847',
      border: '2px solid #3e4148',
    },
  },
  preview: {
    display: 'inline-block',
    margin: 7,
    width: 60,
    height: 25,
    border: `2px solid ${theme.palette.text.main}`,
    transition: 'background 0.15s',
  },
  popup: {
    opacity: 1,
    transition: 'opacity 0.15s',
    position: 'absolute',
    left: 0,
    zIndex: '2',
    width: '100%',
  },
  cover: {
    position: 'fixed',
    top: '0px',
    right: '0px',
    bottom: '0px',
    left: '0px',
    zIndex: -1,
    background: 'rgba(0, 0, 0, 0.5)',
  },
  itemsList: {
    '&::before': {
      content: '" "',
      background: theme.palette.secondary.dark,
      height: 25,
      position: 'absolute',
      transform: 'rotate(-1deg)',
      zIndex: -1,
      width: '100%',
      margin: '0 auto',
      left: 0,
      right: 0,
      marginTop: -25,
      boxShadow: '0 5px 15px #000000',
    },
    width: '100%',
    padding: 10,
    background: theme.palette.secondary.dark,
    minHeight: 84,
    zIndex: 999,
    boxShadow: '0 15px 15px #000000',
  },
  colorButton: {
    width: '100%',
    display: 'block',
    height: 42,
    fontSize: 13,
    fontWeight: 500,
    textAlign: 'center',
    textDecoration: 'none',
    textShadow: 'none',
    whiteSpace: 'nowrap',
    verticalAlign: 'middle',
    borderRadius: 3,
    transition: '0.1s all linear',
    userSelect: 'none',
    background: '#3e4148a3',
    border: '2px solid #3e4148',
    color: '#ffffff',
    marginBottom: 5,
    zIndex: 999,
    '&:hover': {
      background: '#3e414847',
      border: '2px solid #3e4148',
    },
  },
}));

const ColorList = props => {
  const classes = useStyles();
  const [showList, setShowList] = useState(false);
  const [selectedColor, setSelectedColor] = useState(
    props.data.options.colors[props.data.options.current],
  );

  const onClick = () => {
    if (!props.data.options.disabled) {
      setShowList(!showList);
    }
  };

  const changeColor = index => {
    setSelectedColor(props.data.options.colors[index]);
    Nui.send('Selected', {
      id: props.data.id,
      data: { color: props.data.options.colors[index] },
    });
  };

  const cssClass = props.data.options.disabled
    ? `${classes.div} disabled`
    : classes.div;
  const style = props.data.options.disabled ? { opacity: 0.5 } : {};

  return (
    <div className={cssClass} style={style} onClick={onClick}>
      <Grid container>
        <Grid item xs={2}>
          <div
            className={classes.preview}
            style={{
              background:
                selectedColor.rgb != null
                  ? `rgb(${selectedColor.rgb.r}, ${selectedColor.rgb.g}, ${selectedColor.rgb.b})`
                  : selectedColor.hex,
            }}
          />
        </Grid>
        <Grid item xs={8}>
          <span style={{ textShadow: '2px 2px #000' }}>
            {selectedColor.label}
          </span>
        </Grid>
        <Grid item xs={2}>
          <ExpandMore style={{ marginTop: '10%' }} />
        </Grid>
      </Grid>
      <Fade in={showList}>
        <div className={classes.popup}>
          <div className={classes.cover} onClick={onClick} />
          <div className={classes.itemsList}>
            <h3>Select Color</h3>
            {props.data.options.colors.map(function(color, i) {
              console.log(color);
              return (
                <div
                  className={classes.colorButton}
                  key={i}
                  onClick={() => {
                    changeColor(i);
                  }}
                >
                  <Grid container>
                    <Grid item xs={2}>
                      <div
                        className={classes.preview}
                        style={{
                          background:
                            color.rgb != null
                              ? `rgb(${color.rgb.r}, ${color.rgb.g}, ${color.rgb.b})`
                              : color.hex,
                        }}
                      />
                    </Grid>
                    <Grid item xs={8}>
                      <span style={{ textShadow: '2px 2px #000' }}>
                        {color.label}
                      </span>
                    </Grid>
                    <Grid item xs={2}></Grid>
                  </Grid>
                </div>
              );
            })}
          </div>
        </div>
      </Fade>
    </div>
  );
};

export default ColorList;
