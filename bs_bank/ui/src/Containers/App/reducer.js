export const initialState = {
  hidden: process.env.NODE_ENV != 'development',
  page: 0,
  selfData: {
    wallet: 5000,
  },
};

const appReducer = (state = initialState, { type, payload }) => {
  switch (type) {
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
    case 'APP_PAGE_SET': {
      return {
        ...state,
        page: payload.page,
      };
    }

    case 'SELF_SET_WALLET': {
      return {
        ...state,
        selfData: {
          ...state.selfData,
          wallet: payload.cash,
        },
      };
    }
    default:
      return state;
  }
};

export default appReducer;
