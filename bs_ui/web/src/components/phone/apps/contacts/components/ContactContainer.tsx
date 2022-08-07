import { faCircleUser, faComments, faPenToSquare, faPhone, faUser, faUserSlash } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Tooltip } from '@mui/material';
import { useState } from 'react';
import { fetchNui } from '../../../../../utils/fetchNui';
import Modal from '../../../components/modal/Modal';
import { PhoneStrings } from '../../../config/config';
import { FormatPhoneNumber } from '../../../utils/utils';
import './ContactContainer.css';

export default function ContactContainer(props: UI.Phone.PhoneContact) {
  const [hovered, setHovered] = useState(false);
  const [isEditOpen, setIsEditOpen] = useState(false);
  const [isDeleteOpen, setIsDeleteOpen] = useState(false);
  
  let { _id, name, phoneNumber } = props;

  const handleContactDelete = () => {
    setIsDeleteOpen(true);
    setHovered(false);
  }
  const handleContactCall = () => {
    // TODO: notification bar
    // fetchNui('hud:phone:contactCall', { number: number });
  }

  const handleContactMessage = () => {
    // this should open modal to send message
    // fetchNui('hud:phone:messageContact', { number: number });
  }
  
  const handleContactEdit = () => {
    setIsEditOpen(true);
    setHovered(false);
  }

  if (name.length > 16) {
    name = name.substring(0, 16) + '...';
  }

  return (
    <>
      <div className="contact-container" 
        onMouseEnter={() =>{
          setHovered(true);
        }}
        onMouseLeave={() => {
          setHovered(false);
        }}
      >
        <div className="contact-info" 
        style={{
          filter: hovered ? "blur(0.4em)" : undefined
        }}>
          <div className='contact-icon'>
            <FontAwesomeIcon icon={faCircleUser} />
          </div>
          <div className='contact-info-text'>
            <div className="contact-text">{name}</div>
            <div className="contact-text">{FormatPhoneNumber(phoneNumber)}</div>
          </div>
        </div>

        {hovered && (
          <div className="contact-options">
            <Tooltip title={PhoneStrings.DELETE_CONTACT} placement="top" arrow>
              <FontAwesomeIcon icon={faUserSlash} id="contact-options-icon" onClick={() => handleContactDelete() } />
            </Tooltip>
            <Tooltip title={PhoneStrings.CALL_CONTACT} placement="top" arrow>
              <FontAwesomeIcon icon={faPhone} id="contact-options-icon" onClick={() => handleContactCall() } />
            </Tooltip>
            <Tooltip title={PhoneStrings.MESSAGE_CONTACT} placement="top" arrow>
              <FontAwesomeIcon icon={faComments} id="contact-options-icon" onClick={() => handleContactMessage() } />
            </Tooltip>
            <Tooltip title={PhoneStrings.EDIT_CONTACT} placement="top" arrow>
              <FontAwesomeIcon icon={faPenToSquare} id="contact-options-icon" onClick={() => handleContactEdit() } />
            </Tooltip>
          </div>
        )}
      </div>

      {/* 
        Idk dude 
        I think everybody's all jealous and shit
        Cause I'm like, the lead singer of the band, dude
        And I think everybody's got a fuckin' problem with me, dude
      */}

      {isDeleteOpen && (
        <Modal
          setIsOpen={setIsDeleteOpen}
          callbackEvent="hud:phone:deleteContact"
          style={{
            position: 'fixed',
            width: '16%',
            height: '62.5%',
            right: '15px',
            bottom: '20px',
            top: 'auto',
          }}
          text={PhoneStrings.DELETE_CONTACT_CONFIRM}
          id={_id}
          params={[]}
        /> 
      )}

      {isEditOpen && (
        <Modal
          setIsOpen={setIsEditOpen}
          callbackEvent="hud:phone:editContact"
          style={{
            position: 'fixed',
            width: '16%',
            height: '62.5%',
            right: '15px',
            bottom: '20px',
            top: 'auto',
          }}
          params={[
            {
              id: _id,
              label: PhoneStrings.CONTACT_NAME,
              icon: faUser,
              minLength: 1,
            }
          ]}
        /> 
      )}
    </>
  )
}