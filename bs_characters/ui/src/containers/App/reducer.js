import { APP_SHOW, APP_HIDE, SET_STATE } from '../../actions/types';
import { STATE_SPLASH } from '../../util/States';

export const initialState = {
  hidden: true,
  state: STATE_SPLASH,
};

const appReducer = (state = initialState, action) => {
  switch (action.type) {
    case APP_SHOW:
      return { ...state, hidden: false };
    case APP_HIDE:
      return { ...state, hidden: true };
    case SET_STATE:
      return { ...state, state: action.payload.state };
    default:
      return state;
  }
};

export default appReducer;
