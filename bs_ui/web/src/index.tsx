import React from 'react';
import './index.css';
import App from './components/App';
import { createRoot } from 'react-dom/client';
import { HashRouter } from 'react-router-dom';

const root = createRoot(document.getElementById('root')!);

root.render(
  <HashRouter>
    <React.StrictMode>
      <App />
    </React.StrictMode>
  </HashRouter>
);
