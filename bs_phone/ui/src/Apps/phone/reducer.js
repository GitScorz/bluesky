export const initialState = {
    call: null,
    duration: null,
    incomingDismissed: false,
};

export default (state = initialState, action) => {
    switch (action.type) {
        case 'DISMISS_INCOMING':
            return {
                ...state,
                incomingDismissed: true,
            };
        case 'SHOW_INCOMING':
            return {
                ...state,
                incomingDismissed: false,
            };
        case 'SET_CALL_PENDING':
            return {
                ...state,
                call: {
                    state: 0,
                    number: action.payload.number
                },
                duration: -1
            };
        case 'SET_CALL_INCOMING':
            return {
                ...state,
                call: {
                    state: 1,
                    number: action.payload.number
                },
                duration: -1
            };
        case 'SET_CALL_ACTIVE':
            return {
                ...state,
                call: {
                    state: 2,
                    number: action.payload.number
                },
                duration: 0,
                incomingDismissed: false,
            };
        case 'UPDATE_CALL_TIMER':
            return {
                ...state,
                duration: action.payload.timer
            };
        case 'END_CALL':
            return {
                ...state,
                call: null,
                duration: null,
                incomingDismissed: false,
            };
        default:
            return state;
    }
};
