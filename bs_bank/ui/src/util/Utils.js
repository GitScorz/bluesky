export const formatAccountNumber = (accountNumber) => {
  return accountNumber.match(/\d{3}(?=\d{2,3})|\d+/g).join('-');
};

// yoinked from server script
export const temporarilyCreateAccountNumber = () => {
  let account = '';
  for (let i = 1; i <= 18; i++) {
    const d = Math.floor(Math.random() * 10);
    account = account + d.toString();
  }
  return account;
};

export const isStringEmpty = (str) => {
  return str === null || str.match(/^ *$/) !== null;
};
