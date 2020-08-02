import React from 'react';
import { makeStyles } from '@material-ui/core';
import { useSelector } from 'react-redux';
import CardItem from './CardItem';
import CardCreate from './CardCreate';


const useStyles = makeStyles(theme => ({
  accounts: {
    width: '80%',
    height: '100%',
    overflow: 'hidden',
  },

  title: {
    marginLeft: 24,
    color: theme.palette.primary.main,
    fontWeight: 500,
    paddingBottom: 0,
    marginBottom: 0,
  },

  hr: {
    width: '93.75%',
    borderColor: 'rgba(200, 200, 200, 0.04)',
    borderWidth: 0.5,
    borderStyle: 'solid',
    marginLeft: 24,
    marginTop: 6,
  },

  section: {
    display: 'flex',
    flexFlow: 'row wrap',
    alignContent: 'flex-start',
    width: '97.5%',
    height: '80%',
    overflow: 'auto',

    '& > div:nth-child(2n + 1)': {
      marginLeft: '12.5%',
    },
  },
}));

const CardSelect = () => {

  const classes = useStyles();

  const cards = useSelector(state => state.Cards.list);

  return (
    <>
      <div className={classes.accounts}>
        <h2 className={classes.title}>Cards</h2>
        <hr className={classes.hr}/>
        <div className={classes.section}>
          {
            cards.map(card =>
              <CardItem card={card} key={card.CardNumber}/>,
            )
          }
          <CardCreate/>
        </div>
      </div>
    </>
  );
};

export default CardSelect;
