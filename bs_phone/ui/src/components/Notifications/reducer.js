export const initialState = {
    open: null,
    new: [],
    notifications: [],
};

export default  (state = initialState, action) => {
    switch (action.type) {
        case 'NOTIF_RESET_APP':
            return {
                ...state,
                open: null
            }
        case 'APP_OPEN':
            return {
                ...state,
                open: action.payload
            }
        case 'NOTIF_ADD':
            if (state.open === action.payload.notification.app)
                return {
                    ...state,
                }
            else
                return {
                    ...state,
                    new: action.payload.noBanner ? state.new : [
                        ...state.new,
                        action.payload.notification,
                    ],
                    notifications: [
                        action.payload.notification,
                        ...state.notifications,
                    ],
                };
        case 'REMOVE_NEW_NOTIF':
            return {
                ...state,
                new: state.new.filter((a, i) => i > 0)
            }
        case 'NOTIF_DISMISS':
            return {
            ...state,
            notifications: state.notifications.filter((n, i) => (i != action.payload.index))
            };
        case 'NOTIF_DISMISS_APP':
            return {
            ...state,
            notifications: state.notifications.filter(n => n.app != action.payload.app)
            };
        case 'NOTIF_DISMISS_ALL':
            return {
                ...state,
                notifications: [],
            };
        default:
            return state;
    }
};