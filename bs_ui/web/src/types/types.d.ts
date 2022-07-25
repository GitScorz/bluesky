namespace UI {
  
  namespace Status {
    interface HudProps {
      voice: number;
      health: number;
      armor: number;
      hunger: number;
      thirst: number;
    }
  }

  namespace Balance {
    interface BalanceType {
      bank: number;
      cash: number;
    }
  } 
}