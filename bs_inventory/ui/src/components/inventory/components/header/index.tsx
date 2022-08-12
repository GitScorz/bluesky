import WeightBar from '../weightbar';
import './header.styles.css';

export default function Header({
  invName,
  weight,
  maxWeight,
}: {
  invName: string;
  weight: number;
  maxWeight: number;
}) {
  return (
    <div className="inventory-header">
      <h1 className="inventory-name">{invName}</h1>
      <div className="inventory-weight">
        <span>
          {weight}/{maxWeight}
        </span>
      </div>
      <WeightBar weight={weight} maxWeight={maxWeight} />
    </div>
  );
}
