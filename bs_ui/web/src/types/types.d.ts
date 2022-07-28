namespace UI {
  
  namespace Status {
    interface HudProps {
      voice: number;
      health: number;
      armor: number;
      hunger: number;
      thirst: number;
    }

    interface Data {
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

  namespace Interaction {
    interface Data {
      action: string;
      colorType: string;
    }
  }
}