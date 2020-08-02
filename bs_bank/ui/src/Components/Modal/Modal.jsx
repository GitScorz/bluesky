import React from 'react';
import { Backdrop, Fade, makeStyles, Modal as MUIModal, Slide } from '@material-ui/core';

const useStyles = makeStyles(theme => ({
  container: {
    position: 'relative',
    display: 'flex',
    flexFlow: 'row wrap',
    outline: 'none',
    width: 1150 / 2,
    minHeight: 650 / 2,
    maxHeight: 800,
    margin: 'auto',
    background: theme.palette.secondary.dark,
    borderRadius: 5,
  },

  header: {
    marginTop: 10,
    alignSelf: 'flex-start',
    width: '100%',
    background: theme.palette.secondary.main,
    borderRadius: '25px 25px 0 0',
    textAlign: 'center',
    borderBottom: '0.5px solid rgba(200, 200, 200, 0.04)',

    '& #title': {
      margin: 0,
      color: theme.palette.primary.main,
      paddingBottom: 10,
      fontWeight: 'bolder',
    },

    '& #desc': {
      color: theme.palette.secondary.contrastText,
      paddingBottom: 5,
      marginTop: 5,
      fontWeight: 500,
    },
  },

  contentWrapper: {
    alignSelf: 'stretch',
    overflow: 'auto',
    maxHeight: 500,
    minHeight: 150,
    width: '100%',
    marginTop: 0,
  },

  content: {
    width: '100%',
    height: 'auto',
  },

  footer: {
    alignSelf: 'flex-end',
    display: 'flex',
    justifyContent: 'flex-end',
    width: '100%',
    paddingTop: 5,
    minHeight: 50,
    background: theme.palette.secondary.main,
    borderRadius: '0 0 25px 25px',
    borderTop: '0.5px solid rgba(200, 200, 200, 0.04)',
  },

  actions: {
    marginRight: 5,
    marginBottom: 5,
    height: 50,

    '& .MuiButton-root': {
      marginRight: 20,
      marginTop: 7,
      height: '75%',
      paddingLeft: 15,
      paddingRight: 15,

      '&.success': {
        color: theme.palette.success.main,
      },

      '&.error': {
        color: theme.palette.error.main,
      },
    },
  },
}));

const Modal = ({
  children,
  title, desc,
  actions,
  onClose,
  open,
}) => {

  const classes = useStyles();

  return (
    <MUIModal
      aria-labelledby="title"
      aria-describedby="desc"
      open={open}
      onClose={onClose}
      closeAfterTransition
      BackdropComponent={Backdrop}
      BackdropProps={{
        transitionDuration: 100,
        style: {
          backdropFilter: 'blur(3px)',
        },
      }}
      style={{
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}
    >
      <Slide in={open} direction="up" timeout={300}>
        <div style={{ outline: 'none' }}>    {/* fade and slide trick */}
          <Fade in={open} timeout={100}>
            <div className={classes.container}>
              <div className={classes.header}>
                <Fade in={open} timeout={300} style={{ transitionDelay: open ? 100 : 0 }}>
                  <h1 id="title">{title}</h1>
                </Fade>
                {desc && <Fade in={open} timeout={300} style={{ transitionDelay: open ? 100 * 1.5 : 0 }}>
                  <p id="desc">{desc}</p>
                </Fade>}
              </div>

              <Fade in={open} timeout={300} style={{ transitionDelay: open ? 100 * 2.5 : 0 }}>
                <div className={classes.contentWrapper}>
                  <div className={classes.content}>
                    {children}
                  </div>
                </div>
              </Fade>

              <div className={classes.footer}>
                <Fade in={open} timeout={300} style={{ transitionDelay: open ? 100 * 2 : 0 }}>
                  <div className={classes.actions}>
                    {actions}
                  </div>
                </Fade>
              </div>
            </div>
          </Fade>
        </div>
      </Slide>

    </MUIModal>
  );
};

export default Modal;
