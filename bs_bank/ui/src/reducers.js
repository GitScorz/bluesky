import { combineReducers } from 'redux';

import App from './containers/App/reducer';
import Bank from './containers/Bank/reducer';
import ATM from './containers/ATM/reducer';
import Accounts from './Containers/Bank/SubPage/SubPages/Accounts/reducer';
import Cards from './Containers/Bank/SubPage/SubPages/Cards/reducer';
import Loans from './Containers/Bank/SubPage/SubPages/Loans/reducer';

export default () => combineReducers({
  App, Bank, Accounts, Cards, ATM, Loans,
})
