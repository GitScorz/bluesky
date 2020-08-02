import React from 'react';
import { makeStyles, TextField, MenuItem } from '@material-ui/core';
import Nui from '../../util/Nui';

const useStyles = makeStyles(theme => ({
  div: {
    width: '100%',
    height: 84,
    fontSize: 13,
    fontWeight: 500,
    textAlign: 'center',
    textDecoration: 'none',
    textShadow: 'none',
    whiteSpace: 'nowrap',
    display: 'inline-block',
    verticalAlign: 'middle',
    padding: '10px 20px',
    borderRadius: 3,
    transition: '0.1s all linear',
    userSelect: 'none',
    background: '#3e4148a3',
    border: '2px solid #3e4148',
    color: '#ffffff',
    marginBottom: 5,
    lineHeight: '38px',
    '&:hover:not(.disabled)': {
      background: '#3e414847',
      border: '2px solid #3e4148',
    },
  },
  item: {
    width: '100%',
    textAlign: 'left',
  }
}));

export default props => {
  const classes = useStyles();
  const [value, setValue] = React.useState(props.data.options.current);

  const handleChange = event => {
    setValue(event.target.value);
    Nui.send('Selected', {
        id: props.data.id,
        data: { value: event.target.value }
    });
  };

  const cssClass = props.data.options.disabled
    ? `${classes.div} disabled`
    : classes.div;
  const style = props.data.options.disabled ? { opacity: 0.5 } : {};

  return (
    <div className={cssClass} style={style}>
      <TextField
        className={classes.item}
        select
        disabled={props.data.options.disabled}
        label={props.data.label}
        value={value}
        onChange={handleChange}
      >
        {props.data.options.list.map(option => (
          <MenuItem key={option.value} value={option.value} selected={false}>
            {option.label}
          </MenuItem>
        ))}
      </TextField>
    </div>
  );
};
