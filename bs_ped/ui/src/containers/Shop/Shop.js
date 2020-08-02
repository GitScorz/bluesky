/* eslint-disable no-console */
/* eslint-disable jsx-a11y/no-static-element-interactions */
/* eslint-disable jsx-a11y/click-events-have-key-events */
/* eslint-disable prettier/prettier */
/* eslint-disable react/prop-types */
import React from 'react';
import { AppBar, makeStyles, Tab, Tabs } from '@material-ui/core';
import { TabPanel } from '../../components/UIComponents';
import { connect, useSelector } from 'react-redux';
import { SavePed } from '../../actions/pedActions';
import Clothes from '../../components/Clothes/Clothes';
import Accessories from '../../components/Accessories/Accessories';
import Nui from '../../util/Nui';


const useStyles = makeStyles(theme => ({
  header: {
    color: theme.palette.text.main,
    position: 'relative',
    background: theme.palette.secondary.dark,
    padding: 14,
    width: 'fit-content',
    marginBottom: 20,
    fontSize: 12,
    letterSpacing: 2,
    textTransform: 'uppercase',
    whiteSpace: 'nowrap',
    maxWidth: '90%',
    '&::after': {
      content: '" "',
      position: 'absolute',
      display: 'block',
      transition: 'all 0.5s ease',
      top: 0,
      right: -21,
      width: 0,
      height: 0,
      borderBottom: `46px solid ${theme.palette.secondary.dark}`,
      borderRight: '21px solid transparent',
    },
  },
  save: {
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
    padding: '10px 20px',
    borderRadius: 3,
    transition: '0.1s all linear',
    userSelect: 'none',
    background: '#38b58fab',
    border: '2px solid #38b58f',
    color: '#ffffff',
    marginTop: 15,
    '&:hover': {
      background: '#38b58f59',
      border: '2px solid #38b58f',
    },
  },
  rotationbutton: {
    width: '40%',
    height: 42,
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
    background: '#38b58fab',
    border: '2px solid #38b58f',
    color: '#ffffff',
    marginTop: 15,
    '&:hover': {
      background: '#38b58f59',
      border: '2px solid #38b58f',
    },
  },
}));

export default connect()((props) => {
  const classes = useStyles();
  const [value, setValue] = React.useState(0);
  const state = useSelector(state => state.app.state);

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };
  const onRotateLeft = () => {
    Nui.send('RotateLeft');
  };
  const onRotateRight = () => {
    Nui.send('RotateRight');
  };


  const onSave = () => {
    props.dispatch(SavePed(state));
  };

  return (
    <div>
      <div className={classes.header}>
        <div
          style={{
            maxWidth: '100%',
            overflow: 'hidden',
            textOverflow: 'ellipsis',
          }}
        >
          Clothes Shop
        </div>
      </div>
      <AppBar position="static">
        <Tabs
          value={value}
          onChange={handleChange}
          indicatorColor="secondary"
          textColor="secondary"
          variant="scrollable"
        >
          <Tab label="Clothes"/>
          <Tab label="Accessories"/>
        </Tabs>
      </AppBar>
      <TabPanel value={value} index={0}>
        <Clothes showArms/>
      </TabPanel>
      <TabPanel value={value} index={1}>
        <Accessories/>
      </TabPanel>
      <div className={classes.save} onClick={onSave}>Save</div>
      <div className={classes.rotation}>
        <div className={classes.rotationbutton} onClick={onRotateLeft}>{'<'}</div>
        <div className={classes.rotationbutton} onClick={onRotateRight}>{'>'}</div>
      </div>
    </div>
  );
});
