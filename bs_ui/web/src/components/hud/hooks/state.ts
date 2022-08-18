import { atom } from "recoil";
import { PlayerHudProps, TalkingStatus, VehicleHudProps } from "../../../types/hud";

export const statusState = {
  visibility: atom<boolean>({
    key: "hud.visibility",
    default: false,
  }),

  status: atom<PlayerHudProps>({
    key: "hud.status",
    default: {
      voice: 0,
      health: 0,
      armor: 0,
      hunger: 0,
      thirst: 0,
    },
  }),

  talkingStatus: atom<TalkingStatus>({
    key: "hud.onRadio",
    default: {
      talking: false,
      usingRadio: false,
    },
  }),

  onRadio: atom<boolean>({
    key: "hud.onRadio",
    default: false,
  }),
}

export const vehicleState = {
  visibility: atom<boolean>({
    key: "hud.vehicle.visibility",
    default: false,
  }),

  vehicle: atom<VehicleHudProps>({
    key: "hud.vehicle",
    default: {
      fuel: 0,
      speed: 0,
      seatbelt: false,
    },
  }),
}