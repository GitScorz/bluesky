import { faFaceFrown, faMagnifyingGlass, faPhone, faUser, faUserPlus } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { InputAdornment, TextField, Tooltip } from '@mui/material';
import { useState } from 'react';
import { fetchNui } from '../../../../utils/fetchNui';
import Modal from '../../components/modal/Modal';
import { PhoneStrings } from '../../config/config';
import ContactContainer from './components/ContactContainer';
import './Contacts.css';

export default function Contacts() {
  const [isOpen, setIsOpen] = useState(false);
  const [search, setSearch] = useState('');
  const [contacts, setContacts] = useState<UI.Phone.PhoneContact[]>([
    {
      name: "John Doesadasdadsda",
      phoneNumber: "8887776666",
    },
    {
      name: "Jane Doe",
      phoneNumber: "2484567898",
    },
  ]);

  // fetchNui('hud:phone:getPhoneContacts').then((data: UI.Phone.PhoneContact[]) => {
  //   console.log(data);
  //   setContacts(data);
  // });

  const handleSearch = (event: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const { value } = event.target;
    setSearch(value);
  }

  return (
    <div className="contacts-wrapper">
      <div className="contacts-add-new">
        <Tooltip title={PhoneStrings.ADD_CONTACT} placement="top" arrow>
          <FontAwesomeIcon icon={faUserPlus} onClick={() => setIsOpen(true)} />
        </Tooltip>
      </div>
      <div className="contacts-search">
        <TextField
          label={PhoneStrings.SEARCH}
          value={search}
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
        {contacts.filter((contact) => {
          if (search === '') {
            return contact;
          } else if (contact.name.toLowerCase().includes(search.toLowerCase())) {
            return contact;
          }
        }).map((contact: UI.Phone.PhoneContact) => (
          <ContactContainer key={contact.phoneNumber} {...contact} />
        ))}

        {contacts.length <= 0 && (
          <div className="contacts-not-found">
            <FontAwesomeIcon icon={faFaceFrown} style={{ fontSize: "5rem" }} />
            <span>{PhoneStrings.NO_CONTACTS}</span>
          </div>
        )}
        
      </div>
      {isOpen && (
        <Modal setIsOpen={setIsOpen} params={[
          {
            id: "contact-name",
            title: PhoneStrings.CONTACT_NAME,
            icon: faUser
          },
          {
            id: "contact-number",
            title: PhoneStrings.PHONE_NUMBER,
            icon: faPhone,
            expected: "number",
            minLength: 10,
            maxLength: 10,
          }
        ]} />
      )}
    </div>
  )
}