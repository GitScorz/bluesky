import Fade from '@mui/material/Fade';
import { useRecoilState } from 'recoil';
import { inventoryState } from '../hooks/state';
import './notification.styles.css';

export default function Notification() {
  const [visibility, setVisibility] = useRecoilState(
    inventoryState.notificationVisibility,
  );

  // TODO
  return (
    <Fade in={visibility}>
      <></>
    </Fade>
  );
}
