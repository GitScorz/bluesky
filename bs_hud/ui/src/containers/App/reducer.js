/* eslint-disable no-case-declarations */
import { toast } from 'react-toastify';
import { css } from 'glamor';

export const initialState = {
  hidden: false,
  persistent: {},
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
    case 'CLEAR_ALERTS':
      toast.dismiss();
      return {
        persistent: {}
      }
    case 'REMOVE_PERSISTENT_ALERT':
      if (state.persistent[action.payload.id] != null) {
        toast.dismiss(state.persistent[action.payload.id].toast);
        const nPers = state.persistent;
        nPers[action.payload.id] = null;
        return {
          ...state,
          persistent: nPers,
        };
      }
      return { ...state };

    case 'SHOW_PERSISTENT_ALERT':
      switch (action.payload.type) {
        case 'error':
          if (state.persistent[action.payload.id] != null) {
            toast.update(state.persistent[action.payload.id].toast, {
              render: action.payload.message,
            });
            return { ...state };
          }
          return {
            ...state,
            persistent: {
              ...state.persistent,
              [action.payload.id]: {
                id: action.payload.id,
                toast: toast.error(action.payload.message, {
                  pauseOnFocusLoss: false,
                  autoClose: false,
                  hideProgressBar: true,
                }),
              },
            },
          };
        case 'warn':
          if (state.persistent[action.payload.id] != null) {
            toast.update(state.persistent[action.payload.id].toast, {
              render: action.payload.message,
            });
            return { ...state };
          }
          return {
            ...state,
            persistent: {
              ...state.persistent,
              [action.payload.id]: {
                id: action.payload.id,
                toast: toast.warn(action.payload.message, {
                  pauseOnFocusLoss: false,
                  autoClose: false,
                  hideProgressBar: true,
                }),
              },
            },
          };
        case 'success':
          if (state.persistent[action.payload.id] != null) {
            toast.update(state.persistent[action.payload.id].toast, {
              render: action.payload.message,
            });
            return { ...state };
          }
          return {
            ...state,
            persistent: {
              ...state.persistent,
              [action.payload.id]: {
                id: action.payload.id,
                toast: toast.success(action.payload.message, {
                  pauseOnFocusLoss: false,
                  autoClose: false,
                  hideProgressBar: true,
                }),
              },
            },
          };
        case 'info':
          if (state.persistent[action.payload.id] != null) {
            toast.update(state.persistent[action.payload.id].toast, {
              render: action.payload.message,
            });
            return { ...state };
          }
          return {
            ...state,
            persistent: {
              ...state.persistent,
              [action.payload.id]: {
                id: action.payload.id,
                toast: toast.info(action.payload.message, {
                  pauseOnFocusLoss: false,
                  autoClose: false,
                  hideProgressBar: true,
                }),
              },
            },
          };
        case 'custom':
          if (state.persistent[action.payload.id] != null) {
            toast.update(state.persistent[action.payload.id].toast, {
              render: action.payload.message,
            });
            return { ...state };
          }
          return {
            ...state,
            persistent: {
              ...state.persistent,
              [action.payload.id]: {
                id: action.payload.id,
                toast: toast(action.payload.message, {
                  pauseOnFocusLoss: false,
                  autoClose: false,
                  hideProgressBar: true,
                  className: css(action.payload.style.class),
                  bodyClassName: css(action.payload.style.body),
                  progressClassName: css(action.payload.style.progress),
                }),
              },
            },
          };
        default:
          if (state.persistent[action.payload.id] != null) {
            toast.update(state.persistent[action.payload.id].toast, {
              type: toast.TYPE.DEFAULT,
              render: action.payload.message,
              className: css({
                background: '#18191e',
                color: '#cecece',
              }),
              progressClassName: css({
                background: '#3aaaf9',
              }),
            });
            return { ...state };
          }
          return {
            ...state,
            persistent: {
              ...state.persistent,
              [action.payload.id]: {
                id: action.payload.id,
                toast: toast(action.payload.message, {
                  pauseOnFocusLoss: false,
                  autoClose: false,
                  hideProgressBar: true,
                  className: css({
                    background: '#18191e',
                    color: '#cecece',
                  }),
                  progressClassName: css({
                    background: '#3aaaf9',
                  }),
                }),
              },
            },
          };
      }
    case 'SHOW_ALERT':
      switch (action.payload.type) {
        case 'error':
          toast.error(action.payload.message, {
            pauseOnFocusLoss: false,
            autoClose: action.payload.duration,
          });
          break;
        case 'warn':
          toast.warn(action.payload.message, {
            pauseOnFocusLoss: false,
            autoClose: action.payload.duration,
          });
          break;
        case 'success':
          toast.success(action.payload.message, {
            pauseOnFocusLoss: false,
            autoClose: action.payload.duration,
          });
          break;
        case 'info':
          toast.info(action.payload.message, {
            pauseOnFocusLoss: false,
            autoClose: action.payload.duration,
          });
          break;
        case 'custom':
          toast(action.payload.message, {
            pauseOnFocusLoss: false,
            autoClose: action.payload.duration,
            className: css(action.payload.style.class),
            bodyClassName: css(action.payload.style.body),
            progressClassName: css(action.payload.style.progress),
          });
          break;
        default:
          toast(action.payload.message, {
            pauseOnFocusLoss: false,
            autoClose: action.payload.duration,
            className: css({
              background: '#18191e',
              color: '#cecece',
            }),
            progressClassName: css({
              background: '#3aaaf9',
            }),
          });
          break;
      }
      return { ...state };
    default:
      return state;
  }
};

export default appReducer;
