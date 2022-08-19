export function FormatPhoneNumber(phoneNumber: string) {
  // (888) 888-8888
  const formattedNumber = `(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6, 11)}`;
  return formattedNumber;
}