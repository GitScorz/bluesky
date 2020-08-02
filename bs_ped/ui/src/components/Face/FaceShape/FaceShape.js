/* eslint-disable react/prop-types */
import React, { Fragment } from 'react';
import { connect, useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/core/styles';
import { Slider, Ticker } from '../../UIComponents';
import { SetPedHeadBlendData } from '../../../actions/pedActions';
import ElementBox from '../../UIComponents/ElementBox/ElementBox';

const useStyles = makeStyles(theme => ({
  body: {
    maxHeight: '100%',
    overflowX: 'hidden',
    overflowY: 'auto',
    display: 'grid',
    gridGap: 0,
    gridTemplateColumns: '50% 50%',
    justifyContent: 'space-between',
    margin: 25,
    background: '#3e4148a3',
    border: '2px solid #3e4148',
  }
}));

export default connect()(() => {
  const classes = useStyles();
  const ped = useSelector(state => state.app.ped);

  return (
    <Fragment>
      <ElementBox label={'Face 1'} bodyClass={classes.body}>
        <Ticker
          label={'Shape'}
          event={SetPedHeadBlendData}
          data={{
            face: 'face1',
            type: 'index',
          }}
          current={ped.customization.face.face1.index}
          min={0}
          max={46}
        />
        <Ticker
          label={'Skin'}
          event={SetPedHeadBlendData}
          data={{
            face: 'face1',
            type: 'texture',
          }}
          current={ped.customization.face.face1.texture}
          min={0}
          max={46}
        />
        <Slider
          label={'Mix'}
          event={SetPedHeadBlendData}
          data={{
            type: 'mix',
            face: 'face1',
          }}
          current={ped.customization.face.face1.mix}
          min={0}
          max={100}
        />
      </ElementBox>
      <ElementBox label={'Face 2'} bodyClass={classes.body}>
        <Ticker
          label={'Shape'}
          event={SetPedHeadBlendData}
          data={{
            face: 'face2',
            type: 'index',
          }}
          current={ped.customization.face.face2.index}
          min={0}
          max={46}
        />
        <Ticker
          label={'Skin'}
          event={SetPedHeadBlendData}
          data={{
            face: 'face2',
            type: 'texture',
          }}
          current={ped.customization.face.face2.texture}
          min={0}
          max={46}
        />
        <Slider
          label={'Skin Mix'}
          event={SetPedHeadBlendData}
          data={{
            type: 'mix',
            face: 'face2',
          }}
          current={ped.customization.face.face2.mix}
          min={0}
          max={100}
        />
      </ElementBox>
    </Fragment>
  );
});
