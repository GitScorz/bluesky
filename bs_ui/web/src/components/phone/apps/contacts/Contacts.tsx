import {
  faFaceFrown,
  faMagnifyingGlass,
  faPhone,
  faUser,
  faUserPlus,
} from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { InputAdornment, TextField, Tooltip } from "@mui/material";
import { useEffect, useState } from "react";
import { useNuiEvent } from "../../../../hooks/useNuiEvent";
import { PhoneContact } from "../../../../types/phone";
import { fetchNui } from "../../../../utils/fetchNui";
import Modal from "../../components/modal/Modal";
import { PHONE_STRINGS } from "../../config/config";
import ContactContainer from "./components/ContactContainer";
import "./Contacts.css";

// debugData<PhoneContact[]>([
//   {
//     action: "hud:phone:updateContacts",
//     data: [
//       {
//         _id: "sdasd",
//         name: "John Doe",
//         phoneNumber: "123456789",
//       },
//       {
//         _id: "sdasd",
//         name: "Other Guy",
//         phoneNumber: "123456789",
//       },
//     ],
//   },
// ]);

export default function Contacts() {
  const [isOpen, setIsOpen] = useState(false);
  const [search, setSearch] = useState("");
  const [contacts, setContacts] = useState<PhoneContact[]>([]);

  useEffect(() => {
    fetchNui("hud:phone:getContacts", {}).then((contacts) => {
      setContacts(contacts);
    });
  }, []);

  const filteredContacts =
    search.length > 0
      ? contacts.filter((contact) =>
          contact.name.toLowerCase().includes(search.toLowerCase())
        )
      : contacts;

  const handleSearch = (
    event: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
  ) => {
    const { value } = event.target;
    setSearch(value);
  };

  useNuiEvent("hud:phone:updateContacts", (data: PhoneContact[]) => {
    setContacts(data);
  });

  return (
    <div className="contacts-wrapper">
      <div className="contacts-add-new">
        <Tooltip title={PHONE_STRINGS.ADD_CONTACT} placement="top" arrow>
          <FontAwesomeIcon icon={faUserPlus} onClick={() => setIsOpen(true)} />
        </Tooltip>
      </div>
      <div className="contacts-search">
        <TextField
          label={PHONE_STRINGS.SEARCH}
          value={search}
          onChange={handleSearch}
          fullWidth
          InputProps={{
            startAdornment: (
              <InputAdornment position="start">
                <FontAwesomeIcon
                  icon={faMagnifyingGlass}
                  style={{ color: "#38b58f59" }}
                />
              </InputAdornment>
            ),
          }}
          variant="standard"
        />
      </div>
      <div className="contacts-list">
        {filteredContacts.map((contact: PhoneContact) => {
          return <ContactContainer key={contact._id} {...contact} />;
        })}

        {filteredContacts.length <= 0 && (
          <div className="contacts-not-found">
            <FontAwesomeIcon icon={faFaceFrown} style={{ fontSize: "5rem" }} />
            <span>{PHONE_STRINGS.NO_CONTACTS}</span>
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
              label: PHONE_STRINGS.CONTACT_NAME,
              icon: faUser,
              minLength: 1,
            },
            {
              id: "contact-number",
              label: PHONE_STRINGS.PHONE_NUMBER,
              icon: faPhone,
              expected: "number",
              minLength: 10,
              maxLength: 10,
            },
          ]}
        />
      )}
    </div>
  );
}
