import { faCheckCircle, faXmarkCircle } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Button, CircularProgress, Fade, InputAdornment, Slide, TextField } from '@mui/material';
import React, { useEffect, useRef, useState } from 'react';
import { Link } from 'react-router-dom';
import { SendAlert } from '../../utils/utils';
import './Modal.css';

export default function Modal({ 
  setIsOpen,
  params
}: UI.Phone.ModalProps) {
  const [pParams, setpParams] = useState(params);
  const [disabledButtons, setDisabledButtons] = useState(false);
  const [loading, setLoading] = useState(false);
  const [success, setSuccess] = useState(false);
  const [error, setError] = useState(false);
  const [state, setState] = useState(pParams);

  const timer = useRef<number>();

  useEffect(() => {
    return () => {
      clearTimeout(timer.current);
    };
  }, []);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>, i: number) => {
    const { value, name } = e.target;

    const newState = [...state];
    newState[i] = {
      ...newState[i],
      [name]: value
    };

    setState(newState);
  };

  const handleSubmit = () => {
    let isValid = true;
    let msg = "";

    state.forEach((item) => {
      if (item.expected) {
        switch (item.expected) {
          case 'number':
            if (isNaN(Number(item.input))) {
              msg = "The input is not a number.";
              isValid = false;
              return;
            }

            if (item.input && item.minLength && item.maxLength && (item.input.length > item.maxLength || item.input.length < item.minLength)) {
              msg = "The input length is not valid.";
              isValid = false;
              return;
            }
            break;
          case 'boolean':
            if (item.input !== 'true' && item.input !== 'false') {
              msg = "The input is not a boolean.";
              isValid = false;
            }
            break;
        }
      }
    });

    setpParams([]);
    setDisabledButtons(true);

    const time = 3000;

    if (!loading) {
      setError(false);
      setSuccess(false);
      setLoading(true);
      timer.current = window.setTimeout(() => {
        if (isValid) {
          setSuccess(true);
        } else {
          setError(true);
          SendAlert(msg, "error");
        }

        setLoading(false);
        timer.current = window.setTimeout(() => {
          setIsOpen(false);
        }, 2000);
      }, time);
    }
  }

  return (
    <div className="modal-wrapper">
      <Fade in={true}> 
        <div className="modal-content">
          {pParams.map((param: UI.Phone.ModalParams, i: number) => (
            <div className="modal-params">
              <TextField
                name="input"
                label={param.title} 
                onChange={(e) => handleChange(e, i)}
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
                <FontAwesomeIcon icon={faCheckCircle} style={{ color: "#42f57b", fontSize: "5rem" }} /> 
              )}
              {error && (
                <FontAwesomeIcon icon={faXmarkCircle} style={{ color: "#f44336", fontSize: "5rem" }} /> 
              )}
              {loading && (
                <CircularProgress
                  size={68}
                  sx={{
                    color: "white",
                  }}
                />
              )}
            </div>
          )}
        </div>
      </Fade>
    </div>
  )
}
