import { faCircleUser, faComments, faPenToSquare, faPhone, faUserMinus } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Tooltip } from '@mui/material';
import { useState } from 'react';
import { PhoneStrings } from '../../../config/config';
import './ContactContainer.css';

export default function ContactContainer(props: UI.Phone.PhoneContact) {
  const [hovered, setHovered] = useState(false);
  const { name, phoneNumber } = props;

  const handleContactDelete = (number: string) => {
    console.log(number);
  }

  const handleContactCall = (number: string) => {
    console.log(number);
  }

  const handleContactMessage = (number: string) => {
    console.log(number);
    // this should open messages app
  }

  const handleContactEdit = (number: string) => {
    console.log(number);
  }

  return (
    <div className="contact-container" 
    onMouseEnter={() =>{
      setHovered(true);
    }}
    onMouseLeave={() => {
      setHovered(false);
    }}>
      <div className="contact-info" 
      style={{
        filter: hovered ? "blur(0.4em)" : undefined
      }}>
        <div className='contact-icon'>
          <FontAwesomeIcon icon={faCircleUser} />
        </div>
        <div className='contact-info-text'>
          <div className="contact-text">{name}</div>
          <div className="contact-text">{phoneNumber}</div>
        </div>
      </div>

      {hovered && (
        <div className="contact-options">
          <Tooltip title={PhoneStrings.DELETE_CONTACT} placement="top" arrow>
            <FontAwesomeIcon icon={faUserMinus} id="contact-options-icon" onClick={() => handleContactDelete(props.phoneNumber) } />
          </Tooltip>
          <Tooltip title={PhoneStrings.CALL_CONTACT} placement="top" arrow>
            <FontAwesomeIcon icon={faPhone} id="contact-options-icon" onClick={() => handleContactCall(props.phoneNumber) } />
          </Tooltip>
          <Tooltip title={PhoneStrings.MESSAGE_CONTACT} placement="top" arrow>
            <FontAwesomeIcon icon={faComments} id="contact-options-icon" onClick={() => handleContactMessage(props.phoneNumber) } />
          </Tooltip>
          <Tooltip title={PhoneStrings.EDIT_CONTACT} placement="top" arrow>
            <FontAwesomeIcon icon={faPenToSquare} id="contact-options-icon" onClick={() => handleContactEdit(props.phoneNumber) } />
          </Tooltip>
        </div>
      )}
    </div>
  )
}