import { ISlot } from '../../../../types/types';
import Slot from './slot';
import './slots.styles.css';

export default function Slots({ invItems, size, invType, owner }: ISlot) {
  return (
    <div className="slots-wrapper">
      <div className="slots-container">
        {[...Array(size).keys()].map((value) => {
          let id = null;

          for (let i = 0; i < size; i++) {
            if (invItems[i]) {
              if (invItems[i].slot === value) {
                id = i;
                break;
              }
            }
          }

          if (id === null) {
            return (
              <Slot
                key={value}
                index={value}
                draggable={false}
                invType={invType}
                owner={owner}
              />
            );
          } else {
            return (
              <Slot
                key={value}
                index={value}
                item={invItems[id]}
                draggable={true}
                invType={invType}
                owner={owner}
              />
            );
          }
        })}
      </div>
    </div>
  );
}
