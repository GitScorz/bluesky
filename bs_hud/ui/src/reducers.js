import { combineReducers } from 'redux';

import appReducer from 'containers/App/reducer';
import actionReducer from './containers/Action/reducer';
import hudReducer from './containers/Hud/reducer';
import locationReducer from './components/Location/reducer';
import statusReducer from './components/Status/reducer';
import vehicleReducer from './components/Vehicle/reducer';

export default () =>
  combineReducers({
    app: appReducer,
    action: actionReducer,
    hud: hudReducer,
    location: locationReducer,
    status: statusReducer,
    vehicle: vehicleReducer,
  });
