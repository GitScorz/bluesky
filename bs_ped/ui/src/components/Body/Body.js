import React, { useState } from 'react';
import Wrapper from '../UIComponents/Wrapper/Wrapper';
import { AppBar, Tab, Tabs } from '@material-ui/core';
import { TabPanel } from '../UIComponents';
import BodyOverlays from './BodyOverlays/BodyOverlays';
import Component from '../PedComponents/Component/Component';
import { useSelector } from 'react-redux';

export default (props) => {
  const ped = useSelector(state => state.app.ped);
  const [value, setValue] = useState(0);

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };
  return <Wrapper>
    <AppBar position="static" color="secondary">
      <Tabs
        value={value}
        onChange={handleChange}
        variant="scrollable"
        indicatorColor="primary"
        textColor="primary"
      >
        <Tab label="Shape"/>
        <Tab label="Skin"/>
      </Tabs>
    </AppBar>
    <TabPanel value={value} index={0}>
      <Component label={'Arms'} component={ped.customization.components.torso} name={'torso'}/>
    </TabPanel>
    <TabPanel value={value} index={1}>
      <BodyOverlays/>
    </TabPanel>
  </Wrapper>;
}
