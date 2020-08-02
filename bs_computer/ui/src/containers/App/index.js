import React, { useState } from 'react';
import { connect } from 'react-redux';
import Typography from '@material-ui/core/Typography';

export default connect()((props) => {
  const hidden = useState(state => state.app.hidden);

  return <div hidden={hidden}>
    <Typography variant={'h1'}>
      This is a boiler plate
    </Typography>
  </div>;
});
