import ElementBox from '../../UIComponents/ElementBox/ElementBox';
import React, { useEffect } from 'react';
import { makeStyles } from '@material-ui/core/styles';
import { SetPedComponentVariation } from '../../../actions/pedActions';
import { Ticker } from '../../UIComponents';
import Nui from '../../../util/Nui';
import { connect, useSelector } from 'react-redux';

const useStyles = makeStyles(theme => ({
  body: {
    maxHeight: '100%',
    overflowX: 'hidden',
    overflowY: 'auto',
    margin: 25,
    display: 'grid',
    gridGap: 0,
    gridTemplateColumns: '49% 49%',
    justifyContent: 'space-around',
    background: '#3e4148a3',
    border: '2px solid #3e4148',
  },
}));

export default connect()(props => {
  const classes = useStyles();
  useEffect(() => {
    Nui.send('GetNumberOfPedDrawableVariations', {
      componentId: props.component.componentId,
    });
  }, []);

  useEffect(() => {
    Nui.send('GetNumberOfPedTextureVariations', {
      componentId: props.component.componentId,
      drawableId: props.component.drawableId,
    });
    props.dispatch(SetPedComponentVariation(0, {
      type: 'textureId',
      name: props.name,
    }));
  }, [props.component.drawableId]);

  const maxDrawables = useSelector(state => state.app.drawables.components[props.component.componentId]);
  const maxTextures = useSelector(state => state.app.textures.components[props.component.componentId]);


  return <ElementBox label={props.label} bodyClass={classes.body}>
    <Ticker
      label={props.label}
      event={SetPedComponentVariation}
      data={{
        type: 'drawableId',
        name: props.name,
      }}
      current={props.component.drawableId}
      min={0}
      max={maxDrawables ? maxDrawables - 1 : 0}
      disabled={props.disabled}
    />
    <Ticker
      label={'Texture'}
      event={SetPedComponentVariation}
      data={{
        type: 'textureId',
        name: props.name,
      }}
      current={props.component.textureId}
      min={0}
      max={maxTextures ? maxTextures - 1 : 0}
      disabled={props.disabled}
    />
  </ElementBox>;
})
