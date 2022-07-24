import Nui from "../util/Nui";

export const addToHome = (app) => (dispatch) => {
    Nui.send('Home', {
        app,
        action: 'add'
    }).then((res) => {
        dispatch({
            type: 'ADD_DATA',
            payload: { type: 'home', data: app }
        });
    });
}

export const removeFromHome = (app) => (dispatch) => {
    Nui.send('Home', {
        app,
        action: 'remove'
    }).then((res) => {
        dispatch({
            type: 'REMOVE_DATA',
            payload: { type: 'home', id: app }
        });
    });
}

export const addToDock = (app) => (dispatch) => {
    Nui.send('Dock', {
        app,
        action: 'add'
    }).then((res) => {
        dispatch({
            type: 'ADD_DATA',
            payload: { type: 'docked', data: app }
        });
    });
}

export const removeFromDock = (app) => (dispatch) => {
    Nui.send('Dock', {
        app,
        action: 'remove'
    }).then((res) => {
        dispatch({
            type: 'REMOVE_DATA',
            payload: { type: 'docked', id: app }
        });
    });
}

export const reorderApp = (qry) => (dispatch) => {
    Nui.send('Reorder', {
        type: qry.type,
        apps: qry.data
    }).then((res) => {
        dispatch({
            type: 'SET_DATA',
            payload: qry
        });
    });
}