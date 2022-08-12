import { useState } from 'react';
import { useRecoilState } from 'recoil';
import { ISlot } from '../../../../types/types';
import { inventoryState } from '../../../hooks/state';

export default function Slot({ slot, invName, hotkeys }: ISlot) {
  const [playerInventory, setPlayerInventory] = useRecoilState(
    inventoryState.playerInventory,
  );

  return <div></div>;
}
