import { useRecoilState, useSetRecoilState } from "recoil";
import { useNuiEvent } from "../../../hooks/useNuiEvent";
import { HUD_EVENTS, StatusUpdateData, VehicleHudProps } from "../../../types/hud";
import { debugData } from "../../../utils/debugData";
import { statusState, vehicleState } from "./state";

export const useHudService = () => {
  const [statusVisibility, setStatusVisibility] = useRecoilState(statusState.visibility);
  const [status, setStatus] = useRecoilState(statusState.status);
  
  const [vehicleVisible, setVehicleVisibility] = useRecoilState(vehicleState.visibility);
  const setVehicleData = useSetRecoilState(vehicleState.vehicle);

  const setTalkingStatus = useSetRecoilState(statusState.talkingStatus);
  const setOnRadio = useSetRecoilState(statusState.onRadio);

  useNuiEvent(HUD_EVENTS.STATUS_VISIBLE, setStatusVisibility);
  useNuiEvent(HUD_EVENTS.STATUS_UPDATE_DATA, (data: StatusUpdateData) => {
    if (!statusVisibility) return;

    switch (data.id) {
      case "voice":
        const voiceStates = [30, 70, 100];
        setStatus({ ...status, voice: voiceStates[data.value] });
        break;
      case "health":
        setStatus({ ...status, health: data.value });
        break;
      case "armor":
        setStatus({ ...status, armor: data.value });
        break;
      case "hunger":
        setStatus({ ...status, hunger: data.value });
        break;
      case "thirst":
        setStatus({ ...status, thirst: data.value });
        break;
      default:
        break;
    }
  });

  useNuiEvent(HUD_EVENTS.VEHICLE_UPDATE_DATA, (data: VehicleHudProps) => {
    if (!vehicleVisible) return;
    setVehicleData(data);
  });

  useNuiEvent(HUD_EVENTS.STATUS_VISIBLE, setStatusVisibility);
  useNuiEvent(HUD_EVENTS.VEHICLE_VISIBLE, setVehicleVisibility);

  useNuiEvent(HUD_EVENTS.TOGGLE_RADIO, setOnRadio);
  useNuiEvent(HUD_EVENTS.UPDATE_TALKING_STATUS, setTalkingStatus);
}

debugData<any>([
  {
    action: HUD_EVENTS.STATUS_VISIBLE,
    data: true,
  },
  {
    action: HUD_EVENTS.VEHICLE_VISIBLE,
    data: true,
  },
  {
    action: HUD_EVENTS.STATUS_UPDATE_DATA,
    data: {
      id: "voice",
      value: 1,
    },
  },
  {
    action: HUD_EVENTS.STATUS_UPDATE_DATA,
    data: {
      id: "health",
      value: 50,
    },
  },
  {
    action: HUD_EVENTS.STATUS_UPDATE_DATA,
    data: {
      id: "armor",
      value: 1,
    },
  },
  {
    action: HUD_EVENTS.STATUS_UPDATE_DATA,
    data: {
      id: "hunger",
      value: 50,
    },
  },
  {
    action: HUD_EVENTS.STATUS_UPDATE_DATA,
    data: {
      id: "thirst",
      value: 50,
    },
  },
  {
    action: HUD_EVENTS.VEHICLE_UPDATE_DATA,
    data: {
      speed: 100,
      fuel: 50,
      seatbelt: false,
    },
  },
])