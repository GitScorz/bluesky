import './index.css';
import App from './components/App';
import { createRoot } from 'react-dom/client';
import { Provider } from 'react-redux';
import store from './store';

const root = createRoot(document.getElementById('root')!);
root.render(
  <Provider store={store}>
    <App />
  </Provider>,
);
