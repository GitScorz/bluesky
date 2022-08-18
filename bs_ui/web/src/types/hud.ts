export enum HUD_EVENTS {
  STATUS_VISIBLE = "status:visible",
  STATUS_UPDATE_DATA = "status:updateData",
  VEHICLE_VISIBLE = "vehicle:visible",
  VEHICLE_UPDATE_DATA = "vehicle:updateData",
  UPDATE_TALKING_STATUS = "voip:updateTalkingStatus",
  TOGGLE_RADIO = "voip:toggleRadio",
}

export interface PlayerHudProps {
  voice: number;
  health: number;
  armor: number;
  hunger: number;
  thirst: number;
}

export interface StatusUpdateData {
  id: "voice" | "health" | "armor" | "hunger" | "thirst";
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