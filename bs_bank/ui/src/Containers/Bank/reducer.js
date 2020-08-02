const initialState = {
  currentSubPage: 0,
};

const bankReducer = (state = initialState, { type, payload }) => {
  switch (type) {
    case 'BANK_SUBPAGE_SET': {
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

export default bankReducer;
