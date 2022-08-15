import { Fade } from '@mui/material';
import { useRecoilState } from 'recoil';
import { inventoryState } from '../../../hooks/state';
import './info.styles.css';

export default function ItemInfo() {
  const [hoveredItem, setHoveredItem] = useRecoilState(
    inventoryState.hoverItem,
  );

  return (
    <Fade in={hoveredItem.id !== ''} timeout={{ enter: 200, exit: 200 }}>
      <div className="item-info">
        <h2>{hoveredItem.label}</h2>
        {hoveredItem.description && (
          <div className="item-description">{hoveredItem.description}</div>
        )}
        <hr />
        <strong>Weight</strong>: {hoveredItem.weight} | <strong>Amount</strong>:{' '}
        {hoveredItem.quantity} | <strong>Quality</strong>: Good
      </div>
    </Fade>
  );
}
