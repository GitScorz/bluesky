import Nui from '../util/Nui';

import { LOADING_SHOW, SELECT_CHARACTER, UPDATE_PLAYED } from './types';
import {
  CreateCharacter,
  DeleteCharacter,
  SelectCharacter,
  PlayCharacter,
} from '../util/NuiEvents';

export const createCharacter = (data, dispatch) => {
  Nui.send(CreateCharacter, data);
  dispatch({
    type: LOADING_SHOW,
    payload: { message: 'Creating Character' },
  });
};

export const deleteCharacter = (index, charId) => dispatch => {
  Nui.send(DeleteCharacter, { id: charId, index });
  dispatch({
    type: LOADING_SHOW,
    payload: { message: 'Deleting Character' },
  });
};

export const getCharacterSpawns = character => dispatch => {
  Nui.send(SelectCharacter, { id: character.ID });
  dispatch({
    type: SELECT_CHARACTER,
    payload: { character },
  });
  dispatch({
    type: LOADING_SHOW,
    payload: { message: 'Getting Spawn Points' },
  });
};

export const spawnToWorld = (spawn, character) => dispatch => {
  Nui.send(PlayCharacter, { spawn, character });
  dispatch({
    type: LOADING_SHOW,
    payload: { message: 'Spawning' },
  });
  dispatch({
    type: UPDATE_PLAYED,
  });
};
