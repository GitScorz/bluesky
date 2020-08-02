import React from 'react';
import { useSelector } from 'react-redux';
import CardSelect from './CardSelect/CardSelect';


const CardsPages = () => {

  const page = useSelector(state => state.Cards.page);

  return (
    <>
      {page ? <div></div> : <CardSelect/>}
    </>
  );
};

export default CardsPages;
