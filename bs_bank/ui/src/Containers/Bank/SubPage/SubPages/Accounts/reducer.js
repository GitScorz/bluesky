const initialState = {
  page: 0,
  selectedAccount: {
    /// #if DEBUG
    '_id': {
      '$oid': '5ee5545e17f90e4664bd91d6',
    },
    'Amount': 1000,
    'History': [],
    'type': 0,
    'Name': 'Savings',
    'AccountNumber': '998654441086128693',
    'Char': '5ee52c1054d3f15724042d48',
    'Enabled': true,
/// #endif
  }
  ,
  list: [
    /// #if DEBUG
    {
      '_id': {
        '$oid': '5ee5545e17f90e4664bd91d6',
      },
      'Amount': 1000,
      'History': [],
      'type': 0,
      'Name': 'Savings',
      'AccountNumber': '998654441086128693',
      'Char': '5ee52c1054d3f15724042d48',
      'Enabled': true,
    },
/// #endif

  ],
};

const accountReducer = (state = initialState, { type, payload }) => {

  switch (type) {
    case 'ACCOUNTS_ADD': {
      return {
        ...state,
        list: [
          ...state.list,
          payload,
        ],
      };
    }
    case 'ACCOUNTS_SET': {
      return {
        ...state,
        list: Object.values(payload),
      };
    }
    case 'ACCOUNTS_REMOVE': {
      return {
        ...state,
        list: state.list.filter(value => value.AccountNumber !== payload.AccountNumber),
      };
    }
    case 'ACCOUNTS_SELECTED': {
      return {
        ...state,
        page: 1,
        selectedAccount: payload,
      };
    }
    case 'ACCOUNTS_RESET_PAGE': {
      return {
        ...state,
        page: 0,
      };
    }
    case 'ACCOUNTS_SET_PAGE': {
      return {
        ...state,
        page: payload,
      };
    }

    case 'ACCOUNT_SET_MONEY': {

      const list = [...state.list];
      list[state.list.indexOf(payload.acc)] = { ...payload.acc, count: payload.money };

      if (state.selectedAccount == payload.acc) {
        state.selectedAccount = { ...payload.acc, count: payload.money };
      }

      return {
        ...state,
        list,
      };
    }

    case 'ACCOUNT_DEPOSIT': {
      const updatedAcc = {
        ...payload.acc, Amount: payload.acc.Amount + payload.amount, History: [
          payload.history,
          ...payload.acc.History,
        ],
      };

      const list = [...state.list];
      list[state.list.indexOf(payload.acc)] = updatedAcc;

      if (state.selectedAccount === payload.acc) {
        state.selectedAccount = updatedAcc;
      }

      return {
        ...state,
        list,
      };
    }

    case 'ACCOUNT_WITHDRAW': {
      const updatedAcc = {
        ...payload.acc, Amount: payload.acc.Amount - payload.amount, History: [
          payload.history,
          ...payload.acc.History,
        ],
      };

      const list = [...state.list];
      list[state.list.indexOf(payload.acc)] = updatedAcc;

      if (state.selectedAccount === payload.acc) {
        state.selectedAccount = updatedAcc;
      }

      return {
        ...state,
        list,
      };
    }

    default:
      return state;
  }
};

export default accountReducer;
