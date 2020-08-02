import React, { useEffect } from 'react';
import { connect, useSelector } from 'react-redux';

export default connect()((props) => {
    let duration = useSelector(state => state.call.duration);

    useEffect(() => {
        let timer = setInterval(() => {
            props.dispatch({
                type: 'UPDATE_CALL_TIMER',
                payload: { timer: duration++ }
            });
        }, 1000);

        return () => {
            clearInterval(timer);
        }
    }, []);

    return (
        <span />
    );
});
