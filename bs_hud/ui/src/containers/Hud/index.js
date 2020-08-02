/* eslint-disable react/prop-types */
/* eslint-disable global-require */
/* eslint-disable react/no-danger */
import React from 'react';
import { useSelector } from 'react-redux';
import { Fade } from '@material-ui/core';

import { Location, Status, Vehicle } from '../../components';

export default () => {
  const showing = useSelector(state => state.hud.showing);

  return (
    <Fade in={showing}>
      <div>
        <Location />
        <Status />
        <Vehicle />
      </div>
    </Fade>
  );
};
