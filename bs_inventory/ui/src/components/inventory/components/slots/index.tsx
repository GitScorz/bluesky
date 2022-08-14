import { useRecoilState } from 'recoil';
import { ISlot } from '../../../../types/types';
import { inventoryState } from '../../../hooks/state';
import Slot from './slot';
import './slots.styles.css';

export default function Slots({ invItems, slots }: ISlot) {
  return (
    <div className="slots-wrapper">
      <div className="slots-container">
        {[...Array(slots).keys()].map((value) => {
          let id = null;

          for (let i = 0; i < slots; i++) {
            if (invItems[i]) {
              if (invItems[i].slot === value) {
                id = i;
                break;
              }
            }
          }

          if (id === null) {
            return <Slot key={value} index={value} />;
          } else {
            return <Slot key={value} index={value} item={invItems[id]} />;
          }
        })}
      </div>
    </div>
  );
}
