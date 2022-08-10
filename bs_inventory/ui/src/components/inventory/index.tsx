import { useAppDispatch, useAppSelector } from '../../hooks/dispatch';
import './index.css';

export default function Inventory() {
  const count = useAppSelector((state) => state.counter.value);
  const dispatch = useAppDispatch();

  return (
    <div className="inventory-wrapper">
      <div className="inventory-grid"></div>
    </div>
  );
}
