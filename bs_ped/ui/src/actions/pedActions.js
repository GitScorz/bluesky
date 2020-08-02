import Nui from '../util/Nui';

export const updatePed = (event, type, index, value) => dispatch => {
  switch (event) {
    case 'SetPedHeadOverlay':
      dispatch({
        type: 'UPDATE_PED_OVERLAY',
        payload: { index, value },
      });
      break;
    case 'SetPedFaceFeature':
      dispatch({
        type: 'UPDATE_PED_FACE_FEATURE',
        payload: { index, value },
      });
      break;
    case '':
      dispatch({
        type: 'UPDATE_PED_FACE',
        payload: { index, value },
      });
      break;
    default:
      dispatch({
        type: 'UPDATE_PED_MODEL',
        payload: { value },
      });
      break;
  }

//   Nui.send(event, {
//     data: {
//       type,
//       index,
//       value,
//     },
//   });
};

export const SavePed = (state) => {
  return dispatch => {
    Nui.send('Save', {
      state: state,
    });
    dispatch({
      type: 'APP_HIDE',
    });
  };
};

export const SetPedHeadBlendData = (value, data) => {
  return dispatch => {
    const payload = { face: data.face, type: data.type, value };
    Nui.send('SetPedHeadBlendData', payload);
    dispatch({
      type: 'UPDATE_PED_FACE',
      payload: payload,
    });
  };
};

export const SetPedFaceFeature = (value, data) => {
  return dispatch => {
    const payload = { index: data.index, value };
    Nui.send('SetPedFaceFeature', payload);
    dispatch({
      type: 'UPDATE_PED_FACE_FEATURE',
      payload: payload,
    });
  };
};

export const SetPedHeadOverlay = (value, data) => {
  return dispatch => {
    const payload = { ...data, value };
    Nui.send('SetPedHeadOverlay', payload);
    dispatch({
      type: 'UPDATE_PED_OVERLAY',
      payload: payload,
    });
  };
};

export const SetPedComponentVariation = (value, data) => {
  return dispatch => {
    const payload = { ...data, value };
    Nui.send('SetPedComponentVariation', payload);
    dispatch({
      type: 'UPDATE_PED_COMPONENT_VARIATION',
      payload: payload,
    });
  };
};

export const SetPedHairColor = (value, data) => {
  return dispatch => {
    const payload = { ...data, value };
    Nui.send('SetPedHairColor', payload);
    dispatch({
      type: 'UPDATE_PED_HAIR_COLOR',
      payload: payload,
    });
  };
};

export const SetPedHeadOverlayColor = (value, data) => {
  return dispatch => {
    const payload = { ...data, value };
    Nui.send('SetPedHeadOverlayColor', payload);
    dispatch({
      type: 'UPDATE_PED_OVERLAY_COLOR',
      payload: payload,
    });
  };
};

export const SetPedPropIndex = (value, data) => {
  return dispatch => {
    const payload = { ...data, value };
    Nui.send('SetPedPropIndex', payload);
    dispatch({
      type: 'UPDATE_PED_PROP',
      payload: payload,
    });
  };
};
