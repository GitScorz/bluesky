const initialState = {
  page: 0,
  selected: {},
  list: [

    /// #if DEBUG
    {
      LoanNumber: '123456789',
      LoanType: 'Vehicle',
      LoanEntity: {
        RegPlate: 'GFH123FGG',
        Make: 'Nissan Gizmo 2020',
      },
      Payments: [],
      RemainingAmount: 12345,
      Due: 1234,
      DueDateTime: new Date(Date.now()),
    },
    {
      LoanNumber: '234567891',
      LoanType: 'Property',
      LoanEntity: {
        Address: '2 Alzar Lane, AlzarIsADick Street, 90210',
      },
      Payments: [],
      RemainingAmount: 12345,
      Due: 1234,
      DueDateTime: new Date(Date.now()),
    },
    /// #endif
  ],
};

const loansReducer = (state = initialState, { type, payload }) => {

  switch (type) {
    case 'LOANS_ADD': {
      return {
        ...state,
        list: [
          ...state.list,
          payload,
        ],
      };
    }
    case 'LOANS_SET': {
      return {
        ...state,
        list: Object.values(payload),
      };
    }
    case 'LOANS_REMOVE': {
      return {
        ...state,
        list: state.list.filter(value => value.CardNumber !== payload.CardNumber),
      };
    }
    case 'LOANS_PAYMENT': {
      console.log(JSON.stringify(payload.loan))
      const updatedLoan = {
        ...payload.loan,
        RemainingAmount: payload.loan.RemainingAmount - payload.amount,
        Due: payload.loan.Due - payload.amount,
        Payments: [
          payload.payment,
          ...payload.loan.Payments,
        ],
      };

      const list = [...state.list];
      list[state.list.indexOf(payload.loan)] = updatedLoan;

      if (state.selected === payload.acc) {
        state.selected = updatedLoan;
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

export default loansReducer;
