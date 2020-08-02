export const initialState = {
  hidden: true,
  showHotbar: false,
  showing: null
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
    case 'HOTBAR_HIDE':
      return {
        ...state,
        showHotbar: false,
      };
    case 'HOTBAR_SHOW':
      return {
        ...state,
        showHotbar: true,
        showing: action.payload.hotkey
      };
    case 'RESET_SLOT':
      return {
        ...state,
        showing: null
      }
    default:
      return state;
  }
};

export default appReducer;
