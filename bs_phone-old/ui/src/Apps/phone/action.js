import Nui from '../../util/Nui';

export const createCall = (number) => (dispatch) => {
    Nui.send('CreateCall', number);
}

export const addToCall = (number) => (dispatch) => {
    Nui.send('CreateCall', number);
}

export const acceptCall = (number) => (dispatch) => {
    Nui.send('AcceptCall', number);
}

export const endCall = () => (dispatch) => {
    Nui.send('EndCall', null);
}

export const readCalls = () => (dispatch) => {
    Nui.send('ReadCalls', null);
}

export const dismissIncoming = () => (dispatch) => {
    dispatch({
        type: 'DISMISS_INCOMING'
    });
}

export const showIncoming = () => (dispatch) => {
    dispatch({
        type: 'SHOW_INCOMING'
    });
}