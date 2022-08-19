import { IconDefinition } from "@fortawesome/free-solid-svg-icons";

export enum PHONE_EVENTS {
  TOGGLE_OPEN = "phone:toggle",
  CLOSE = "phone:close",
  UPDATE_PHONE_TIME = "phone:updatePhoneTime",
  UPDATE_PHONE_DATA = "phone:updatePhoneData",
  UPDATE_PHONE_SETTINGS = "phone:updatePhoneSettings",
  UPDATE_PHONE_CONTACTS = "phone:updatePhoneContacts",
  SEND_NOTIFICATION = "phone:sendNotification",
  OPEN_CAMERA = "phone:openCamera",
}

export interface DisplayTime {
  hour: string;
  minute: string;
}

export interface PhoneData {
  sid: number;
  cid: string;
  phoneNumber: string;
  wallpaper: string;
  brand: "android" | "ios";
  notifications: boolean;
  name: CharacterName;
  aliases: CharacterAliases;
  cash: number;
  bank: number;
  hasDriverLicense: boolean;
}

export interface CharacterName {
  first: string;
  last: string;
}

export interface CharacterAliases {
  email: string;
  twitter: string;
}

export interface PhoneContact {
  _id: string;
  name: string;
  phoneNumber: string;
  character: string;
}

export interface ModalProps {
  setIsOpen: (isOpen: boolean) => void;
  params: ModalParams[];
  text?: string;
  callbackEvent?: string;
  style?: React.CSSProperties;
  id?: string;
}

export interface ModalParams {
  id: string;
  label: string;
  minLength: number;
  expected?: "string" | "number" | "boolean" | "none";
  input?: string;
  maxLength?: number;
  icon?: IconDefinition;
}

export interface AppProps {
  label: string;
  rootPath: string;
  style: React.CSSProperties;
  icon: IconDefinition;
  component: React.ComponentType<any>;
}

export interface NotificationProps {
  id: string;
  title: string;
  description: string;
  icon: NotificationIcon;
  static?: boolean;
}

export type NotificationIcon = "bell" | "twitter" | "group" | "task" | "message" | "call";