import { faCircleInfo, faIdBadge } from "@fortawesome/free-solid-svg-icons";
import { AppProps } from "../../../types/phone";
import Contacts from "../apps/contacts/Contacts";
import Details from "../apps/details/Details";
import Settings from "../apps/settings/Settings";
import { PHONE_STRINGS } from "./config";

export const APPS: AppProps[] = [
  {
    label: PHONE_STRINGS.APP_DETAILS,
    rootPath: "/details",
    style: {
      background: "linear-gradient(323deg, rgba(19,115,189,1) 0%, rgba(158,213,255,1) 100%)",
    },
    icon: faCircleInfo,
    component: Details,
  },
  {
    label: PHONE_STRINGS.APP_CONTACTS,
    rootPath: "/contacts",
    style: {
      background: "linear-gradient(356deg, rgba(0,44,74,1) 9%, rgba(0,65,110,1) 55%)",
    },
    icon: faIdBadge,
    component: Contacts,
  },
  {
    label: PHONE_STRINGS.APP_SETTINGS,
    rootPath: "/settings",
    style: {
      width: "20.5%",
      height: "10.5%"
    },
    image: "media/apps/settings.png",
    component: Settings,
  },
]