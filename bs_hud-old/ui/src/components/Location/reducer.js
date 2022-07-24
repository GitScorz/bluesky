export const initialState = {
  location: {
    main: 'Alta St',
    cross: 'Forum Dr',
    area: 'Rancho',
    direction: 'W',
    shifted: false,
  },
};

export default (state = initialState, action) => {
  switch (action.type) {
    case 'UPDATE_LOCATION':
      return {
        ...state,
        location: action.payload.location,
      };
    case 'SHIFT_LOCATION':
      console.log(action.payload.shift)
      return {
        ...state,
        shifted: action.payload.shift,
      };
    default:
      return state;
  }
};
