import React from 'react';
import { useSelector } from 'react-redux';
import LoanSelect from './LoanSelect/LoanSelect';


const LoansPages = () => {

  const page = useSelector(state => state.Loans.page);

  return (
    <>
      {page ? <div></div> : <LoanSelect/>}
    </>
  );
};

export default LoansPages;
