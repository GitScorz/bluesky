import { useState } from 'react';
import WeightBar from '../weightbar';
import './header.styles.css';

export default function Header({
  invName,
  weight,
  maxWeight,
  invType,
}: {
  invName: string;
  weight: number;
  maxWeight: number;
  invType: number;
}) {
  const [cash, setCash] = useState(0);

  if (invType === 11) {
    // TODO - when cash is implemented
    // fetchNui('inventory:getPlayerCash', {}).then((res) => {
    //   setCash(res);
    // });
  }

  const formatter = new Intl.NumberFormat(undefined, {
    style: 'currency',
    currency: 'USD',
    maximumFractionDigits: 0,
    minimumFractionDigits: 0,
  });

  return (
    <div className="inventory-header">
      <h1 className="inventory-name">{invName}</h1>
      <div className="inventory-weight">
        <span>
          {weight}/{maxWeight}
        </span>
      </div>
      {invType !== 11 && <WeightBar weight={weight} maxWeight={maxWeight} />}

      {invType === 11 && (
        <>
          <div className="self-cash">
            You got{' '}
            <span style={{ color: '#3e9c35' }}>{formatter.format(cash)}</span>{' '}
            to spend.
          </div>
        </>
      )}
    </div>
  );
}
