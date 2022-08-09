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

    interface TalkingStatus {
      talking: boolean;
      usingRadio: boolean;
    }
  }

  namespace Vehicle {
    interface HudProps {
      fuel: number;
      speed: number;
      seatbelt: boolean;
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
      sid: number;
      cid: string;
      phoneNumber: string;
      name: CharacterName;
      aliases: CharacterAliases;
      cash: number;
      bank: number;
      hasDriverLicense: boolean;
    }

    interface CharacterName {
      first: string;
      last: string;
    }

    interface CharacterAliases {
      email: string;
      twitter: string;
    }

    interface PhoneContact {
      _id: string;
      name: string;
      phoneNumber: string;
    }

    interface ModalProps {
      setIsOpen: (isOpen: boolean) => void;
      params: ModalParams[];
      text?: string;
      callbackEvent?: string;
      style?: React.CSSProperties;
      id?: string;
    }

    interface ModalParams {
      id: string;
      label: string;
      minLength: number;
      expected?: "string" | "number" | "boolean" | "none";
      input?: string;
      maxLength?: number;
      icon?: IconDefinition;
    }

    interface AppProps {
      label: string;
      rootPath: string;
      style: React.CSSProperties;
      icon: IconDefinition;
      component: React.ComponentType<any>;
    }

    interface NotificationProps {
      id: string;
      title: string;
      description: string;
      icon: NotificationIcon;
      static?: boolean;
    }

    type NotificationIcon = "bell" | "twitter" | "group" | "task" | "message" | "call";
  }
}