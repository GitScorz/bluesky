/* eslint-disable react/no-array-index-key */
/* eslint-disable prettier/prettier */
/* eslint-disable react/prop-types */
import React, { useEffect, useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { Button as MButton, makeStyles } from '@material-ui/core';

import CancelIcon from '@material-ui/icons/Cancel';
import Nui from '../../util/Nui';

import {
  AdvancedButton,
  Button,
  Checkbox,
  ColorList,
  ColorPicker,
  Slider,
  SubMenu,
  SubMenuBack,
  Ticker,
  Input,
  Number,
  Select,
  Text,
} from '../MenuItems';

const useStyles = makeStyles(theme => ({
  wrapper: {
    '&::before': {
      content: '" "',
      background: theme.palette.secondary.main,
      height: 25,
      position: 'absolute',
      transform: 'rotate(1deg)',
      zIndex: -1,
      width: '100%',
      margin: '0 auto',
      left: 0,
      right: 0,
      marginTop: -25,
    },
    background: theme.palette.secondary.main,
    maxHeight: 800,
    width: '20%',
    position: 'absolute',
    top: '5%',
    left: '1%',
    margin: 'auto',
    textAlign: 'center',
    fontSize: 30,
    color: theme.palette.text.main,
    zIndex: 1000,
    padding: 20,
  },
  menuHeader: {
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
  menuButton: {
    marginBottom: 10,
  },
  closeButton: {
    position: 'absolute',
    top: -25,
    left: -15,
    color: theme.palette.primary.main,
    padding: 5,
    background: theme.palette.secondary.main,
    minWidth: 32,
    boxShadow: 'none',
    '&:hover': {
      color: theme.palette.primary.main,
      background: theme.palette.secondary.main,
      boxShadow: 'none',
      '& svg': {
        filter: 'brightness(0.6)',
        transition: 'filter ease-in 0.15s',
      },
    },
  },
  buttons: {
    overflowY: 'auto',
    overflowX: 'hidden',
    maxHeight: 695,
    display: 'block',
    '&::-webkit-scrollbar': {
      width: 6,
    },
    '&::-webkit-scrollbar-thumb': {
      background: '#131317',
    },
    '&::-webkit-scrollbar-thumb:hover': {
      background: theme.palette.primary.main,
    },
    '&::-webkit-scrollbar-track': {
      background: theme.palette.secondary.main,
    },
  },
}));

export default connect()((props) => {
  const classes = useStyles();
  const menu = useSelector(state => state.menu.menu);
  const [elements, setElements] = useState([]);
  useEffect(() => {
    setElements(menu.items.map((item, i) => {
      switch (item.type.toUpperCase()) {
        case 'ADVANCED':
          return <AdvancedButton key={`${menu.id}-${i}`} mId={menu.id} id={i} data={item}/>;
        case 'CHECKBOX':
          return <Checkbox key={`${menu.id}-${i}`} mId={menu.id} id={i} data={item}/>;
        case 'SLIDER':
          return <Slider key={`${menu.id}-${i}`} mId={menu.id} id={i} data={item}/>;
        case 'TICKER':
          return <Ticker key={`${menu.id}-${i}`} mId={menu.id} id={i} data={item}/>;
        case 'COLORPICKER':
          return <ColorPicker key={`${menu.id}-${i}`} mId={menu.id} id={i} data={item}/>;
        case 'COLORLIST':
          return <ColorList key={`${menu.id}-${i}`} mId={menu.id} id={i} data={item}/>;
        case 'INPUT':
          return <Input key={`${menu.id}-${i}`} mId={menu.id} id={i} data={item}/>;
        case 'NUMBER':
          return <Number key={`${menu.id}-${i}`} mId={menu.id} id={i} data={item}/>;
        case 'SELECT':
          return <Select key={`${menu.id}-${i}`} mId={menu.id} id={i} data={item}/>;
        case 'TEXT':
          return <Text key={`${menu.id}-${i}`} mId={menu.id} id={i} data={item}/>;
        case 'SUBMENU':
          return <SubMenu key={`${menu.id}-${i}`} id={i} mId={menu.id} data={item}/>;
        case 'GOBACK':
          return <SubMenuBack key={`${menu.id}-${i}`} id={i} mId={menu.id} data={item}/>;
        default:
          return <Button key={`${menu.id}-${i}`} id={i} mId={menu.id} data={item}/>;
      }
    }));
  }, [menu]);

  const onClick = () => {
    Nui.send('Close');
    props.dispatch({
      type: 'CLEAR_MENU',
    });
  };

  return (
    <div className={classes.wrapper}>
      <MButton
        className={classes.closeButton}
        variant="contained"
        color="primary"
        onClick={onClick}
      >
        <CancelIcon/>
      </MButton>
      <div className={classes.menuHeader}>
        <div
          style={{
            maxWidth: '100%',
            overflow: 'hidden',
            textOverflow: 'ellipsis',
          }}
        >
          {menu.label}
        </div>
      </div>
      <div className={classes.buttons}>{elements}</div>
    </div>
  );
})
;
