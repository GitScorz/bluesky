import './index.css';
import App from './components/App';
import { createRoot } from 'react-dom/client';
import { RecoilRoot } from 'recoil';
import { DndProvider } from 'react-dnd';
import { TouchBackend } from 'react-dnd-touch-backend';
import { StrictMode } from 'react';

const root = createRoot(document.getElementById('root')!);
root.render(
  <StrictMode>
    <DndProvider
      backend={TouchBackend}
      debugMode={true}
      options={{ enableMouseEvents: true, enableHoverOutsideTarget: true }}
    >
      <RecoilRoot>
        <App />
      </RecoilRoot>
    </DndProvider>
  </StrictMode>,
);
