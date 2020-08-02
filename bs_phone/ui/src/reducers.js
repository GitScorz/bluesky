import { combineReducers } from 'redux';

import dataReducer from 'dataReducer';
import phoneReducer from 'containers/Phone/reducer';
import notifReducer from 'components/Notifications/reducer';
import alertsReducer from 'components/Alerts/reducer';
import callReducer from 'Apps/phone/reducer';
import storeReducer from 'Apps/store/reducer';

export default () =>
  combineReducers({
    data: dataReducer,
    phone: phoneReducer,
    alerts: alertsReducer,
    notifications: notifReducer,
    call: callReducer,
    store: storeReducer,
  });
