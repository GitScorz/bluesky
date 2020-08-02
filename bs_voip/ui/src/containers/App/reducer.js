
export const initialState = {
  hidden: true,
  warningScreen: false,
  serverUrl: '',
  website: '',
  channel: '',
  support: '',
  currentMessage: 'Pending Connection',
  messageColor: 'negative',
  pluginColor: '#672626',
  pluginText: 'Checking Version',
  currentlyTalking: 0,
  currentlyRadio: 0,
  currentlyCall: 0,
  currentRadioChannel: -1,
  currentCallChan: -1,
  currentRange: 0,  
  currentRadioChannelName: '',
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
    case 'WARNING_SCREEN':
      return {
        ...state,
        warningScreen: action.payload.toggle,
      };
    case 'SERVER_INFO':
      return {
        ...state,
        serverUrl: action.payload.serverUrl,
        website: action.payload.website,
        channel: action.payload.channel,
        support: action.payload.support,
        currentMessage: action.payload.currentMessage
      };
    case 'PLUGIN_VER':
      return {
        ...state,
        pluginColor: action.payload.pluginColor,
        pluginText: action.payload.pluginText
      };
    case 'SET_TALKING':
      return {
        ...state,
        currentlyTalking: action.payload.currentlyTalking,
      }
    case 'SET_RADIO_TALK':
      return {
        ...state,
        currentlyRadio: action.payload.toggle,
      };
    case 'SET_CALL_TALK':
      return {
        ...state,
        currentlyCall: action.payload.toggle,
      };
    case 'SET_RANGE':
      return {
        ...state,
        currentRange: action.payload.range,
      };
    case 'SET_CALL_CHAN':
      if(action.payload.currentCall > 0) {
        return {
          ...state,
          currentCallChan: action.payload.currentChan,
        };
      } else {
        return {
          ...state,
          currentlyCall: -1,
        };
      };
    case 'SET_RADIO_CHAN':
      if(action.payload.currentChan > 0) {
        return {
          ...state,
          currentRadioChannel: action.payload.currentChan,
          currentRadioChannelName: action.payload.currentChanName
        };
      } else {
        return {
          ...state,
          currentRadioChannel: -1,
          currentRadioChannelName: ''
        };
      };
    default:
      return state;
  }
};

export default appReducer;
