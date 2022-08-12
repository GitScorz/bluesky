import './weightbar.styles.css';

export default function WeightBar({
  weight,
  maxWeight,
}: {
  weight: number;
  maxWeight: number;
}) {
  return (
    <div className="weightBar">
      <div
        className="weightFill"
        style={{
          width: `${(weight / maxWeight) * 100}%`,
        }}
      ></div>
    </div>
  );
}
