import {
  SET_CHARACTERS,
  CREATE_CHARACTER,
  DELETE_CHARACTER,
  SELECT_CHARACTER,
  DESELECT_CHARACTER,
  SET_DATA,
  UPDATE_PLAYED,
} from '../../actions/types';

export const initialState = {
  characters: [],
  changelog: null,
  motd: '',
  selected: null,
};

const charReducer = (state = initialState, action) => {
  switch (action.type) {
    case SET_CHARACTERS:
      return { ...state, characters: action.payload, selected: null };
    case CREATE_CHARACTER:
      state.characters.push(action.payload.character);
      return state;
    case DELETE_CHARACTER:
      return {
        ...state,
        characters: [
          ...state.characters.slice(0, action.payload.index),
          ...state.characters.slice(action.payload.index + 1),
        ],
      };
    case SELECT_CHARACTER:
      return { ...state, selected: action.payload.character };
    case DESELECT_CHARACTER:
      return { ...state, selected: null };
    case SET_DATA:
      return {
        ...state,
        characters: action.payload.characters,
        changelog: action.payload.changelog,
        motd: action.payload.motd,
      };
    case UPDATE_PLAYED:
      return {
        ...state,
        characters: state.characters.map(char =>
          char.ID === state.selected.ID
            ? { ...char, LastPlayed: Date.now() }
            : char,
        ),
      };
    default:
      return state;
  }
};

export default charReducer;
