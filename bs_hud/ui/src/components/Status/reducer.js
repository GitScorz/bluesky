export const initialState = {
  health: 0,
  armor: 0,
  statuses: [],
};

export default (state = initialState, action) => {
  switch (action.type) {
    case 'UPDATE_HP':
      return {
        ...state,
        health: action.payload.hp,
        armor: action.payload.armor,
      };
    case 'REGISTER_STATUS':
      return {
        ...state,
        statuses: [...state.statuses, action.payload.status],
      };
    case 'RESET_STATUSES':
      return {
        ...state,
        statuses: Array(),
      };
    case 'UPDATE_STATUS':
      return {
        ...state,
        statuses: state.statuses.map((status, i) => status.name == action.payload.status.name ? 
          {...status, ...action.payload.status} :
          status
        )
      };
    case 'UPDATE_STATUS_VALUE':
      return {
        ...state,
        statuses: state.statuses.map((status, i) => status.name == action.payload.name ? 
          {...status, value: action.payload.value} :
          status
        )
      };
    case 'UPDATE_STATUSES':
      return {
        ...state,
        statuses: action.payload.statuses,
      };
  default:
    return state;
  }
};
