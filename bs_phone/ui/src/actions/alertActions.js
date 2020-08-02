export const showAlert = (message) => (dispatch) => {
    dispatch({
        type: 'ALERT_SHOW',
        payload: { alert: message }
    });
}

export const expireAlert = () => (dispatch) => {
    dispatch({
        type: 'ALERT_SHOW'
    });
}