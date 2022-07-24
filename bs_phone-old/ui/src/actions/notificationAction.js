export const addNotif = (text, icon, color, app) => (dispatch) => {
    dispatch({
        type: 'NOTIF_ADD',
        payload: { notification: { text: text, icon: icon, color: color, time: Date.now(), app: app } }
    });
}

export const dismissNotif = (id) => (dispatch) => {
    dispatch({
        type: 'NOTIF_DISMISS',
        payload: { index: id }
    })
}

export const openedApp = (app) => (dispatch) => {
    dispatch({
        type: 'APP_OPEN',
        payload: app
    });
    dispatch({
        type: 'NOTIF_DISMISS_APP',
        payload: { app: app }
    });
}

export const resetApp = () => (dispatch) => {
    dispatch({
        type: 'NOTIF_RESET_APP'
    })
}

export const dismissNotifAll = () => (dispatch) => {
    dispatch({
        type: 'NOTIF_DISMISS_ALL'
    });
}

export const removeNewNotif = () => (dispatch) => {
    dispatch({
        type: 'REMOVE_NEW_NOTIF'
    });
}