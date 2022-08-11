import './index.css';
import App from './components/App';
import { createRoot } from 'react-dom/client';
import { RecoilRoot } from 'recoil';

const root = createRoot(document.getElementById('root')!);
root.render(
  <RecoilRoot>
    <App />
  </RecoilRoot>,
);
