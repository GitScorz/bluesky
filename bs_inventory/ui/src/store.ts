import { configureStore } from '@reduxjs/toolkit';
import inventoryReducer from "../src/components/inventory/reducer";

const store = configureStore({
  reducer: {
    inventory: inventoryReducer,
  },
})

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;

export default store;