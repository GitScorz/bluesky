import Nui from '../../util/Nui';

export const initialState = {
  prevMenu: [],
  menu: {
    id: null,
    label: null,
    items: []
  },
};

const reducer = (state = initialState, action) => {
  switch (action.type) {
    case 'CLEAR_MENU': {
      return {
        ...state,
        menu: {
          id: null,
          label: null,
          items: []
        },
        prevMenu: [],
      };
    }
    case 'SETUP_MENU':
      return {
        ...state,
        prevMenu: [],
        menu: action.payload.data
      }
    case 'UPDATE_MENU':
      return {
        ...state,
        menu: action.payload.data
      }
    case 'SUBMENU_OPEN': {
      if(action.payload.addHistroy) {
        var old = state.prevMenu;
        old.push(state.menu);

        return {
          ...state,
          prevMenu: old,
          menu: action.payload.data,
        };
      } else {
        return {
          ...state,
          menu: action.payload.data,
        };
      }
    }
    case 'SUBMENU_BACK': {
      Nui.send('MenuClose', {
        id: state.menu.id
      });

      if (state.prevMenu.length > 0) {
        Nui.send('MenuOpen', {
          id: state.prevMenu[state.prevMenu.length - 1].id,
          back: true
        });
        return {
          ...state,
          prevMenu: state.prevMenu.filter( (_,i) =>
            i !== state.prevMenu.length - 1
          ),
        };
      } else {
        Nui.send('Close');
        return {
          ...state,
          menu: {
            id: null,
            label: null,
            items: []
          },
          prevMenu: [],
        };
      }
    }
    default:
      return state;
  }
};

export default reducer;
