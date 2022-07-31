import { faCheck, faCheckCircle } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Button, CircularProgress, InputAdornment, TextField } from '@mui/material';
import React, { useEffect, useRef, useState } from 'react';
import { Link } from 'react-router-dom';
import './Modal.css';

export default function Modal({ 
  setIsOpen,
  params
}: UI.Phone.ModalProps) {
  const [pParams, setpParams] = useState(params);
  const [disabledButtons, setDisabledButtons] = useState(false);
  const [loading, setLoading] = useState(false);
  const [success, setSuccess] = useState(false);
  const timer = useRef<number>();

  useEffect(() => {
    return () => {
      clearTimeout(timer.current);
    };
  }, []);

  const handleSubmit = () => {
    setpParams([]);
    setDisabledButtons(true);

    const time = 1000;

    if (!loading) {
      setSuccess(false);
      setLoading(true);
      timer.current = window.setTimeout(() => {
        setSuccess(true);
        setLoading(false);
      }, time);
      timer.current = window.setTimeout(() => {
        setIsOpen(false);
      }, time*2.4);
    }
  }

  return (
    <div className="modal-wrapper">
      <div className="modal-content">
        {pParams.map((param: UI.Phone.ModalParams) => (
          <div className="modal-params">
            <TextField
              label={param.title}
              fullWidth
              InputProps={{
                startAdornment: (
                  <InputAdornment position="start">
                    <FontAwesomeIcon icon={param.icon} style={{ color: "white" }} />
                  </InputAdornment>
                ),
              }}
              variant="standard"
            />
          </div>
        ))}
        {!disabledButtons && (
          <div className="modal-buttons">
            <Button style={{ backgroundColor: '#f44336'}} onClick={() => setIsOpen(false)}>CANCEL</Button>
            <Link to={'/contacts'}>
              <Button style={{ backgroundColor: '#408d3d'}} onClick={() => handleSubmit()}>SUBMIT</Button>
            </Link>
          </div>
        )}

        {disabledButtons && pParams.length === 0 && (
          <div className="modal-success">
            {success && (
             <FontAwesomeIcon icon={faCheckCircle} style={{ color: "green", fontSize: "5rem" }} /> 
            )}
            {loading && (
              <CircularProgress
                size={68}
                sx={{
                  color: "green",
                }}
              />
            )}
          </div>
        )}
      </div>
    </div>
  )
}
