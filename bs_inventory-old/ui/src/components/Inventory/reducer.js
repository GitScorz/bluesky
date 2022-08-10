/*export const initialState = {
  player: {
    size: 40,
    invType: 1,
    name: "Player Storage",
    inventory: [ { Name: 'water', Label: 'Water', Slot: 0, invType: 1, Image: 'water.png', Count: 10 }, { Name: 'water', Label: 'Water gdsd  dsg sdg sdg', Slot: 1, invType: 1, Image: 'water.png', Count: 10 }, { Name: 'bread', Label: 'Bread', Slot: 2, invType: 1, Image: 'bread.png', Count: 10 },{ Name: 'bread', Label: 'Bread', Slot: 3, invType: 1, Image: 'bread.png', Count: 10 },{ Name: 'bread', Label: 'Bread', Slot: 4, invType: 1, Image: 'bread.png', Count: 10 },{ Name: 'bread', Label: 'Bread', Slot: 5, invType: 1, Image: 'bread.png', Count: 10 }],
    owner: '12214124',
  },
  equipment: {
    inventory: [],
  },
  secondary: {
    size: 40,
    name: "Second Storage",
    invType: 2,
    inventory: [ { Name: 'water', Label: 'Water', Image: 'water.png', Slot: 0, invType: 2, Count: 10 }, { Name: 'water', Image: 'water.png', Label: 'Water sadadsg  adga as g', Slot: 1, invType: 2, Count: 10 }, { Name: 'bread', Label: 'Bread', invType: 2, Slot: 3, Image: 'bread.png', Count: 10 } ],
    owner: '346346346',
  },
  showSecondary: true,
  hover: false,
  hoverOrigin: null,
  contextItem: null,
  splitItem: null,
};*/

export const initialState = {
  player: {
    size: 0,
    invType: 1,
    name: null,
    inventory: [],
    owner: 0,
  },
  equipment: {
    inventory: [],
  },
  secondary: {
    size: 0,
    name: null,
    invType: 2,
    inventory: [ ],
    owner: 0,
  },
  showSecondary: false,
  hover: false,
  hoverOrigin: null,
  contextItem: null,
  splitItem: null,
};


const appReducer = (state = initialState, action) => {
  switch (action.type) {
    case 'SET_PLAYER_INVENTORY': {
      return {
        ...state,
        player: action.payload,
      };
    }
    case 'SET_SECONDARY_INVENTORY': {
      return {
        ...state,
        secondary: action.payload,
      };
    }
    case 'SET_AVALIABLE_ITEMS':{
      return {
        ...state,
        items: action.payload,
      }
    }
    case 'SET_EQUIPMENT': {
      return {
        ...state,
        equipment: action.payload,
      };
    }
    case 'SHOW_SECONDARY_INVENTORY': {
      return {
        ...state,
        showSecondary: true,
      };
    }
    case 'HIDE_SECONDARY_INVENTORY': {
      return {
        ...state,
        showSecondary: false,
      };
    }
    case 'SET_HOVER': {
      return {
        ...state,
        hover: action.payload,
      };
    }
    case 'SET_HOVER_ORIGIN': {
      return {
        ...state,
        hoverOrigin: action.payload,
      };
    }
    case 'SET_CONTEXT_ITEM': {
      return {
        ...state,
        contextItem: action.payload,
      };
    }
    case 'SET_SPLIT_ITEM': {
      return {
        ...state,
        splitItem: action.payload,
      };
    }
    default:
      return state;
  }
};

export default appReducer;
