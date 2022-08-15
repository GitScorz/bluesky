import { useRecoilState } from 'recoil';
import { PropSlot } from '../../../../types/types';
import { DefaultHoveredItem } from '../../../../utils/constants';
import { inventoryState } from '../../../hooks/state';
import './slots.styles.css';

export default function Slot({ index, item }: PropSlot) {
  const [hoveredItem, setHoveredItem] = useRecoilState(
    inventoryState.hoverItem,
  );

  const handleHover = (toggle: boolean) => {
    if (toggle && item) {
      setHoveredItem(item);
    } else {
      setHoveredItem(DefaultHoveredItem);
    }
  };

  return (
    <div
      id={index.toString()}
      className="slot"
      onMouseEnter={() => {
        handleHover(true);
      }}
      onMouseLeave={() => {
        handleHover(false);
      }}
    >
      {item && (
        <div>
          <img src={`images/items/${item.id}.png`} alt={item.label} />
          <div id="item-name">{item.label}</div>
          <div id="item-quantity">{item.quantity}x</div>
          <div id="item-weight">{item.weight}</div>
          <div id="item-quality"></div>
        </div>
      )}
    </div>
  );
}
