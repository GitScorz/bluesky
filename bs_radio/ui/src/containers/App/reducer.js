export const initialState = {
  hidden: true,
  frequency: '',
  volume: -6,
  frequencyName: '',
};

const appReducer = (state = initialState, action) => {
  switch (action.type) {
    case 'APP_SHOW':
      return {
        ...state,
        hidden: false,
      };
    case 'APP_HIDE':
      return {
        ...state,
        hidden: true,
      };
    case 'SET_FREQ':
      return {
        ...state,
        frequency: action.payload.frequency,
        frequencyName: action.payload.frequencyName
      }
    case 'SET_VOLUME':
      return {
        ...state,
        volume: action.payload.volume
      }
    default:
      return state;
  }
};

export default appReducer;
