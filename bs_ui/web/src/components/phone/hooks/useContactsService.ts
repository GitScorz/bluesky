import { useSetRecoilState } from "recoil";
import { useNuiEvent } from "../../../hooks/useNuiEvent";
import { PhoneContact, PHONE_EVENTS } from "../../../types/phone";
import { debugData } from "../../../utils/debugData";
import { contactsState } from "./state";

export const useContactsService = () => {
  const setContacts = useSetRecoilState(contactsState.contacts);

  useNuiEvent(PHONE_EVENTS.UPDATE_PHONE_CONTACTS, setContacts);
}

debugData<PhoneContact[]>([
  {
    action: PHONE_EVENTS.UPDATE_PHONE_CONTACTS,
    data: [
      {
        _id: "1",
        name: "John Doe",
        phoneNumber: "1234567890",
        character: "1",
      },
      {
        _id: "2",
        name: "Jane Doe",
        phoneNumber: "0987654321",
        character: "2",
      },
    ],
  },
]);