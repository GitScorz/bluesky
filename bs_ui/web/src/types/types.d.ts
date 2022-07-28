namespace UI {
  
  namespace Status {
    interface HudProps {
      voice: number;
      health: number;
      armor: number;
      hunger: number;
      thirst: number;
    }

    interface UpdateData {
      id: string;
      value: number;
    }
  }

  namespace Balance {
    interface BalanceTypes {
      bank: number;
      cash: number;
    }
  }

  namespace Action {
    interface ActionData {
      text: string;
    }
  }
}