import { faFaceFrown, faMagnifyingGlass, faUserPlus } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { InputAdornment, TextField, Tooltip } from '@mui/material';
import { useState } from 'react';
import { Link } from 'react-router-dom';
import { debugData } from '../../../../utils/debugData';
import { fetchNui } from '../../../../utils/fetchNui';
import { PhoneStrings } from '../../config/config';
import ContactContainer from './components/ContactContainer';
import './Contacts.css';

export default function Contacts() {
  const [contacts, setContacts] = useState<UI.Phone.PhoneContact[]>([
    {
      name: "John Doe",
      phoneNumber: "987654321",
    },
    {
      name: "Jane Doe",
      phoneNumber: "123456789",
    },
]);

  fetchNui('hud:phone:getPhoneContacts').then((data: UI.Phone.PhoneContact[]) => {
    console.log(data);
    setContacts(data);
  });

  const handleSearch = (event: React.ChangeEvent<HTMLInputElement>) => {
    const search = event.target.value;
    
  }

  return (
    <div className="contacts-wrapper">
      <div className="contacts-add-new">
        <Tooltip title={PhoneStrings.ADD_CONTACT} placement="top" arrow>
          <FontAwesomeIcon icon={faUserPlus} />
        </Tooltip>
      </div>
      <div className="contacts-search">
        <TextField
          label={PhoneStrings.SEARCH}
          onChange={handleSearch}
          fullWidth
          InputProps={{
            startAdornment: (
              <InputAdornment position="start">
                <FontAwesomeIcon icon={faMagnifyingGlass} style={{ color: "#38b58f59" }} />
              </InputAdornment>
            ),
          }}
          variant="standard"
        />
      </div>
      <div className="contacts-list">
        {contacts.map((contact: UI.Phone.PhoneContact) => (
          <ContactContainer key={contact.phoneNumber} {...contact} />
        ))}

        {contacts.length <= 0 && (
          <div className="contacts-not-found">
            <FontAwesomeIcon icon={faFaceFrown} style={{ fontSize: "5rem" }} />
            <span>{PhoneStrings.NO_CONTACTS}</span>
          </div>
        )}
      </div>
    </div>
  )
}