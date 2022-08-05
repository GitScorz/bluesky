import React from 'react';
import './index.css';
import App from './components/App';
import { createRoot } from 'react-dom/client';
import { HashRouter } from 'react-router-dom';
import { library } from '@fortawesome/fontawesome-svg-core';
import { fas } from '@fortawesome/free-solid-svg-icons';
import { fab } from '@fortawesome/free-brands-svg-icons';
import { far } from '@fortawesome/free-regular-svg-icons';

library.add(fas, far, fab);

const root = createRoot(document.getElementById('root')!);

root.render(
  <HashRouter>
    <App />
  </HashRouter>
);
