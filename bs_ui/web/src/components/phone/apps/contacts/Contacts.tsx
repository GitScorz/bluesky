import { faFaceFrown, faMagnifyingGlass, faPhone, faUser, faUserPlus } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { InputAdornment, TextField, Tooltip } from '@mui/material';
import { useEffect, useState } from 'react';
import { useNuiEvent } from '../../../../hooks/useNuiEvent';
import { fetchNui } from '../../../../utils/fetchNui';
import Modal from '../../components/modal/Modal';
import { PhoneStrings } from '../../config/config';
import ContactContainer from './components/ContactContainer';
import './Contacts.css';

export default function Contacts() {
  const [isOpen, setIsOpen] = useState(false);
  const [search, setSearch] = useState('');
  const [contacts, setContacts] = useState<UI.Phone.PhoneContact[]>([]);

  useEffect(() => {
    fetchNui('hud:phone:getContacts', {}).then(contacts => {
      setContacts(contacts);
    });
  }, []);

  const handleSearch = (event: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const { value } = event.target;
    setSearch(value);
  }

  useNuiEvent('hud:phone:updateContacts', (data: UI.Phone.PhoneContact[]) => {
    setContacts(data);
  });

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
          <ContactContainer key={contact._id} {...contact} />
        ))}

        {contacts.length <= 0 && (
          <div className="contacts-not-found">
            <FontAwesomeIcon icon={faFaceFrown} style={{ fontSize: "5rem" }} />
            <span>{PhoneStrings.NO_CONTACTS}</span>
          </div>
        )}
        
      </div>
      {isOpen && (
        <Modal 
          setIsOpen={setIsOpen}
          callbackEvent="hud:phone:addContact"
          params={[
            {
              id: "contact-name",
              label: PhoneStrings.CONTACT_NAME,
              icon: faUser,
              minLength: 1,
            },
            {
              id: "contact-number",
              label: PhoneStrings.PHONE_NUMBER,
              icon: faPhone,
              expected: "number",
              minLength: 10,
              maxLength: 10,
            },
          ]} 
        />
      )}
    </div>
  )
}