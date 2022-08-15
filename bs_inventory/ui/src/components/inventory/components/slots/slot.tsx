import { DragEvent, useState } from 'react';
import { PropSlot } from '../../../../types/types';
import './slots.styles.css';

export default function Slot({ index, item }: PropSlot) {
  const [hovered, setHovered] = useState(false);

  return (
    <div
      id={index.toString()}
      className="slot"
      onMouseEnter={() => {
        setHovered(true);
      }}
      onMouseLeave={() => {
        setHovered(false);
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

      {item && hovered && (
        <div className="item-info">
          <h2>{item?.label}</h2>
          {item?.description && (
            <div className="item-description">{item.description}</div>
          )}
          <hr />
          <strong>Weight</strong>: {item?.weight} | <strong>Amount</strong>:{' '}
          {item?.quantity} | <strong>Quality</strong>: Good
        </div>
      )}
    </div>
  );
}
