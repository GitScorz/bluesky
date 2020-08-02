import React from 'react';
import { makeStyles } from '@material-ui/core';
import { useSelector } from 'react-redux';

import SidebarItem from './SidebarItem';
import Header from '../../../Components/Header/Header';

const useStyles = makeStyles(theme => ({
  container: {
    position: 'relative',
    height: '100%',
    width: '20%',
    background: theme.palette.secondary.main,
    overflow: 'hidden',
    zIndex: 5,
    borderBottomLeftRadius: 25,
    borderTopLeftRadius: 25,
  },

  hr: {
    width: '70%',
    borderColor: 'rgba(200, 200, 200, 0.04)',
    borderWidth: 0.5,
    borderStyle: 'solid',
  },
}));


const Sidebar = ({ mode }) => {
  const classes = useStyles();

  const currSubPage = useSelector(state => state.ATM.currentSubPage);

  return (
    <div className={classes.container}>
      <Header/>
      <hr className={classes.hr}/>
      <SidebarItem
        selected={currSubPage === 0}
        label="Account" id={0}
      />
    </div>
  );
};

export default Sidebar;
