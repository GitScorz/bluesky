import './weightbar.styles.css';

export default function WeightBar({
  weight,
  maxWeight,
}: {
  weight: number;
  maxWeight: number;
}) {
  return (
    <div className="weight-bar">
      <div
        className="weight-fill"
        style={{
          width: `${(weight / maxWeight) * 100}%`,
        }}
      ></div>
    </div>
  );
}
