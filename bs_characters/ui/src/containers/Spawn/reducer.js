import { SET_SPAWNS } from '../../actions/types';

export const initialState = {
  spawns: [],
};

const spawnReducer = (state = initialState, action) => {
  switch (action.type) {
    case SET_SPAWNS:
      return { ...state, spawns: action.payload.spawns };
    default:
      return state;
  }
};

export default spawnReducer;
