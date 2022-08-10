import { combineReducers } from 'redux';

import appReducer from 'containers/App/reducer';
import inventoryReducer from 'components/Inventory/reducer';

export default () =>
  combineReducers({
    app: appReducer,
    inventory: inventoryReducer,
  });
