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
      colorType: "default" | "success" | "error";
    }
  }

  namespace Phone {
    interface DisplayTime {
      hour: number;
      minute: number;
    }

    interface PhoneData {
      serverId: number;
      phoneNumber: string;
      cash: number;
      bank: number;
      hasDriverLicense: boolean;
    }

    interface PhoneContact {
      name: string;
      phoneNumber: string;
    }

    interface ModalProps {
      setIsOpen: (isOpen: boolean) => void;
      params: ModalParams[];
    }

    interface ModalParams {
      id: string;
      title: string;
      icon?: IconDefinition;
    }
  }
}