import '@babel/polyfill';

import React from 'react';
import ReactDOM from 'react-dom/client';
import { Provider } from 'react-redux';

import App from './containers/App';

import WindowListener from 'containers/WindowListener';
import KeyListener from 'containers/KeyListener';

import configureStore from './configureStore';

const initialState = {};
const store = configureStore(initialState);
const MOUNT_NODE = document.getElementById('app');

const root = ReactDOM.createRoot(
  MOUNT_NODE
);

const render = () => {
  root.render(
    <Provider store={store}>
      <KeyListener>
        <WindowListener>
          <App />
        </WindowListener>
      </KeyListener>
    </Provider>,
  );
};

if (module.hot) {
  module.hot.accept(['containers/App'], () => {
    root.unmount();
    render();
  });
}

render();