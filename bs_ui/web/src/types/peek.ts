import { IconProp } from "@fortawesome/fontawesome-svg-core";

export enum PEEK_EVENTS {
  TOGGLE = "peek:toggle",
  ENTER_TARGET = "peek:enterTarget",
  LEAVE_TARGET = "peek:leaveTarget",
  TRIGGER_EVENT = "peek:triggerEvent",
  CLOSE = "peek:close",
}

export interface PeekData {
  icon: IconProp;
  label: string;
  event: string;
}