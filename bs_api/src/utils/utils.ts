import { GROUPS } from "../config/config";

export function b64enc(key: string) {  // Convert string to base64
  return Buffer.from(key).toString('base64');
}

export function getGroups(identifier: string) {  // Get groups from identifier
  let isAdmin = false;
  let isDev = false;

  Object.keys(GROUPS).map((group) => {
    if (GROUPS[group].includes(identifier)) {
      if (group === 'developers') {
        isDev = true;
      } else if (group === 'admins') {
        isAdmin = true;
      }
    }
  });

  return {
    isDev: isDev,
    isAdmin: isAdmin,
  }
}

export function getPlayerSID(identifier: string) {
  return `${identifier.substring(7)}@bluesky.com`;
}