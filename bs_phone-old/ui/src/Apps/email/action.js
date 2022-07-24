import Nui from '../../util/Nui';

export const ReadEmail = (id, emails) => (dispatch) => {
	Nui.send('ReadEmail', id)
		.then(() => {
            dispatch({
                type: 'SET_DATA',
                payload: { type: 'emails', data: emails.map(email => {
                    return {
                        ...email,
                        unread: email._id === id ? false : email.unread
                    }
                })}
            });
		})
		.catch((err) => {
			return;
		});
};

export const DeleteEmail = (id) => (dispatch) => {
	Nui.send('DeleteEmail', id)
		.then(() => {
			dispatch({
				type: 'REMOVE_DATA',
				payload: { type: 'emails', id: id },
			});
			return true;
		})
		.catch((err) => {
			return false;
		});
};

export const GPSRoute = (id, location) => (dispatch) => {
	Nui.send('GPSRoute', {
		id,
		location,
	}).then((res) => {
        dispatch({ type: 'ALERT_SHOW', payload: { alert: 'GPS Marked' }});
    }).catch((err) => {
        dispatch({ type: 'ALERT_SHOW', payload: { alert: 'Unable To Mark Location On GPS' }});
    });
};
