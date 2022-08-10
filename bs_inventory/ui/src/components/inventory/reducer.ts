import { createSlice, PayloadAction } from '@reduxjs/toolkit';
import type { RootState } from '../../store';

// Define the initial state using that type
const initialState: InventoryState = {
  player: {
    size: 0,
    invType: 1,
    name: "Player",
    inventory: [],
    owner: 0,
  },
  equipment: {
    inventory: [],
  },
  secondary: {
    size: 0,
    name: "Drop",
    invType: 2,
    inventory: [],
    owner: 1,
  },
  showSecondary: false,
  hover: false,
  hoverOrigin: null,
  contextItem: null,
  splitItem: null,
}

export const inventorySlice = createSlice({
  name: 'inventory',
  initialState,
  reducers: {
    // increment: (state) => {
    //   state.value += 1
    // },
    // decrement: (state) => {
    //   state.value -= 1
    // },
    // // Use the PayloadAction type to declare the contents of `action.payload`
    // incrementByAmount: (state, action: PayloadAction<number>) => {
    //   state.value += action.payload
    // },
  },
})

// export const { increment, decrement, incrementByAmount } = inventorySlice.actions;

// Other code such as selectors can use the imported `RootState` type
// export const selectCount = (state: RootState) => state.counter.value;

export default inventorySlice.reducer;