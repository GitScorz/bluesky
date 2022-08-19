import { faAddressBook, faCircleInfo, faGear } from "@fortawesome/free-solid-svg-icons";
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
      background: "linear-gradient(0deg, rgba(15,39,68,1) 0%, rgba(54,90,120,1) 86%)",
    },
    icon: faAddressBook,
    component: Contacts,
  },
  {
    label: PHONE_STRINGS.APP_SETTINGS,
    rootPath: "/settings",
    style: {
      background: "#999999",
    },
    icon: faGear,
    component: Settings,
  },
]