const initialState = {
  page: 0,
  selected: {},
  list: [
    /// #if DEBUG
    {
      CardNumber: '123456789789',
      AccountNumber: '998654441086128693',
    }, {
      CardNumber: '123456789789',
      AccountNumber: '998654441086128693',
    }, {
      CardNumber: '123456789789',
      AccountNumber: '998654441086128693',
    }, {
      CardNumber: '123456789789',
      AccountNumber: '998654441086128693',
    }, {
      CardNumber: '123456789789',
      AccountNumber: '998654441086128693',
    },
/// #endif

  ],
};

const cardReducer = (state = initialState, { type, payload }) => {

  switch (type) {
    case 'CARDS_ADD': {
      return {
        ...state,
        list: [
          ...state.list,
          payload,
        ],
      };
    }
    case 'CARDS_SET': {
      return {
        ...state,
        list: Object.values(payload),
      };
    }
    case 'CARDS_REMOVE': {
      return {
        ...state,
        list: state.list.filter(value => value.CardNumber !== payload.CardNumber),
      };
    }
    default:
      return state;
  }
};

export default cardReducer;
