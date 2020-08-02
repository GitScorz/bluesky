import React from 'react';
import { makeStyles } from '@material-ui/core';
import { store } from '../../../Index';

const useStyles = makeStyles(theme => ({
  item: {
    height: 38,
    width: '70%',
    margin: 'auto',
    lineHeight: 0.75,
    color: theme.palette.secondary.contrastText,
    overflow: 'hidden',
    transition: '200ms',
    paddingBottom: 50,

    '&.selected': {
      color: theme.palette.primary.main,
    },

    '&:hover': {
      color: theme.palette.primary.main,
      cursor: 'pointer',
    },

    '& h2': {
      fontSize: 16,
      fontWeight: '400',
    },
  },
}));

const SidebarItem = ({ selected = false, label, id }) => {

  const classes = useStyles();

  const handleClick = (e) => {
    store.dispatch({ type: 'BANK_SUBPAGE_SET', payload: id });

    if (id === 0) store.dispatch({ type: 'ACCOUNTS_SET_PAGE', payload: 0 });
  };

  return (
    <div className={`${classes.item} ${selected ? 'selected' : ''}`} onClick={handleClick} style={{
      paddingTop: (id == 0) ? 16 : 0,
    }}>
      <h2>{label}</h2>
    </div>
  );
};

export default SidebarItem;
