// Will return whether the current environment is in a regular browser

import { UI_EVENTS } from "../types/ui";
import { fetchNui } from "./fetchNui";

// and not CEF
export const isEnvBrowser = (): boolean => !(window as any).invokeNative

// Basic no operation function
export const noop = () => {}

export function SendAlert(message: string, type: "default" | "error") {
  fetchNui(UI_EVENTS.SEND_ALERT, { 
    message: message, 
    type: type 
  });
}