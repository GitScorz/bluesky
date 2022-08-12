import { useRecoilState } from 'recoil';
import { ISlot } from '../../../../types/types';
import { inventoryState } from '../../../hooks/state';
import Slot from './slot';
import './slots.styles.css';

export default function Slots({ invItems }: ISlot) {
  // {playerInventory.items.map((item, index) => (
  //   <div key={index} className="inventory-item">
  //     <img src={item.img} alt={item.label} />
  //     <div className="inventory-item-label">{item.label}</div>
  //   </div>
  // ))}

  return (
    <div className="slots-wrapper">
      <div className="slots-container">
        {[...Array(50).keys()].map((value) => {
          let identifier = null;

          for (let i = 0; i < 50; i++) {
            if (invItems[i]) {
              if (invItems[i].slot === value) {
                identifier = i;
                break;
              }
            }
          }

          if (identifier === null) {
            return <Slot key={value} index={value} />;
          } else {
            return (
              <Slot key={value} index={value} item={invItems[identifier]} />
            );
          }
        })}
      </div>
    </div>
  );
}
