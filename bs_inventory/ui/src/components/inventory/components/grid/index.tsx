import { useEffect, useMemo } from 'react';
import { ISlot } from '../../../../types/types';
import Slot from './slot';
import './slots.styles.css';

export default function Slots({ invItems, size, invType, owner }: ISlot) {
  return useMemo(
    () => (
      <div className="slots-wrapper">
        <div className="slots-container">
          {[...Array(size).keys()].map((value) => {
            let id = null;

            for (let i = 0; i < size; i++) {
              if (invItems[i]) {
                if (invItems[i].slot === value + 1) {
                  id = i;
                  break;
                }
              }
            }

            if (id === null) {
              return (
                <Slot
                  key={value + 1}
                  index={value + 1}
                  draggable={false}
                  invType={invType}
                  owner={owner}
                />
              );
            } else {
              return (
                <Slot
                  key={value + 1}
                  index={value + 1}
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
    ),
    [invItems, size, invType, owner],
  );
}
