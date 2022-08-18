export interface PlayerHudProps {
  voice: number;
  health: number;
  armor: number;
  hunger: number;
  thirst: number;
}

export interface UpdateData {
  id: string;
  value: number;
}

export interface TalkingStatus {
  talking: boolean;
  usingRadio: boolean;
}

export interface VehicleHudProps {
  fuel: number;
  speed: number;
  seatbelt: boolean;
}