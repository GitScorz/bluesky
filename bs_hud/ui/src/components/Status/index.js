/* eslint-disable react/no-array-index-key */
/* eslint-disable react/prop-types */
/* eslint-disable global-require */
/* eslint-disable react/no-danger */
import React, { useState, useEffect } from 'react';
import { useSelector } from 'react-redux';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { library } from '@fortawesome/fontawesome-svg-core';
import { fas } from '@fortawesome/free-solid-svg-icons';
import { fab } from '@fortawesome/free-brands-svg-icons';
import { makeStyles } from '@material-ui/core';

const useStyles = makeStyles(theme => ({
  status: {
    position: 'absolute',
    bottom: '1%',
    right: 0,
    left: 0,
    margin: 'auto',
    fontSize: 30,
    width: 'fit-content',
    maxWidth: '20%',
    textAlign: 'center',
    filter: 'drop-shadow(0 0 2px #000000)',
    whiteSpace: 'nowrap',
    overflow: 'hidden',
    '& svg': {
      margin: 15,
    },
  },
  status100: {
    color: theme.palette.error.dark,
  },
  status75: {
    color: theme.palette.error.light,
  },
  status50: {
    color: '#d8c14f',
  },
  status25: {
    color: theme.palette.error.main,
  },
  status10: {
    color: theme.palette.error.main,
    animation: '$flash linear 1s infinite',
  },
  status10Static: {
    color: theme.palette.error.main,
  },
  status0: {
    color: theme.palette.text.main,
    animation: '$flash linear 0.5s infinite',
  },
  status0Static: {
    color: theme.palette.text.main,
    opacity: 0.25,
  },
  statIcon: {
    display: 'inline-block',
  },
  '@keyframes flash': {
    '0%': {
      opacity: 1,
    },
    '50%': {
      opacity: 0.1,
    },
    '100%': {
      opacity: 1,
    },
  },
}));

library.add(fab, fas);

export default () => {
  const classes = useStyles();
  const health = useSelector(state => state.status.health);
  const armor = useSelector(state => state.status.armor);
  const statuses = useSelector(state => state.status.statuses);

  const GetHealth = () => {
    let css = classes.status100;
    if (health <= 0) {
      css = classes.status0;
    } else if (health <= 75 && health > 50) {
      css = classes.status75;
    } else if (health <= 50 && health > 25) {
      css = classes.status50;
    } else if (health <= 25 && health > 10) {
      css = classes.status25;
    } else if (health <= 10 && health > 0) {
      css = classes.status10;
    }
    return <FontAwesomeIcon className={css} icon="heart" />;
  };

  const GetArmor = () => {
    let css = classes.status100;
    if (armor <= 0) {
      css = classes.status0Static;
    } else if (armor <= 75 && armor > 50) {
      css = classes.status75;
    } else if (armor <= 50 && armor > 25) {
      css = classes.status50;
    } else if (armor <= 25 && armor > 10) {
      css = classes.status25;
    } else if (armor <= 10 && armor > 0) {
      css = classes.status10Static;
    }
    return <FontAwesomeIcon className={css} icon="shield-alt" />;
  };

  const elements = statuses.map((status, i) => {
    let css = classes.status100;
    if (status.value <= 0) {
      if(status.flash) {
        css = classes.status0;
      } else {
        css = classes.status0Static;
      }
    } else if (status.value <= Math.ceil(0.75 * status.max) && status.value > Math.ceil(0.5 * status.max)) {
      css = classes.status75;
    } else if (status.value <= Math.ceil(0.5 * status.max) && status.value > Math.ceil(0.25 * status.max)) {
      css = classes.status50;
    } else if (status.value <= Math.ceil(0.25 * status.max) && status.value > Math.ceil(0.1 * status.max)) {
      css = classes.status25;
    } else if (status.value <= Math.ceil(0.1 * status.max) && status.value > 0) {
      if(status.flash) {
        css = classes.status10;
      } else {
        css = classes.status10Static;
      }
    }
    return <FontAwesomeIcon key={i} className={css} icon={status.icon} />;
  });

  elements.unshift(GetArmor());
  elements.unshift(GetHealth());

  return (
    <div className={classes.status}>
      {elements}
    </div>
  );
};
