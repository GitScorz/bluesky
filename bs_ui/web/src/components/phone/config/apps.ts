import { faBookBookmark, faCircleInfo } from "@fortawesome/free-solid-svg-icons";
import Contacts from "../apps/contacts/Contacts";
import Details from "../apps/details/Details";
import { PhoneStrings } from "./config";

export const APPS: UI.Phone.AppProps[] = [
  {
    label: PhoneStrings.APP_DETAILS,
    rootPath: "/details",
    style: {
      background: "linear-gradient(323deg, rgba(19,115,189,1) 0%, rgba(158,213,255,1) 100%)",
    },
    icon: faCircleInfo,
    component: Details,
  },
  {
    label: PhoneStrings.APP_CONTACTS,
    rootPath: "/contacts",
    style: {
      background: "linear-gradient(323deg, rgba(18,147,10,1) 0%, rgba(181,236,207,1) 100%)",
    },
    icon: faBookBookmark,
    component: Contacts,
  }
]