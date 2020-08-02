const initialState = {
  currentSubPage: 0,
};

const atmReducer = (state = initialState, { type, payload }) => {
  switch (type) {
    case 'ATM_SUBPAGE_SET': {
      return {
        ...state,
        currentSubPage: payload,
      };
    }
    default: {
      return state;
    }
  }
};

export default atmReducer;
