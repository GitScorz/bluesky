import { PhoneContact, PhoneData } from "../../../types/phone";

export const DefaultPhoneTime = {
  hour: "00",
  minute: "00",
}

export const DefaultPhoneData: PhoneData = {
  sid: 1,
  cid: "steam:11000010",
  aliases: {
    email: "scorz@blue.sky",
    twitter: "@Scorz_Dev",
  },
  cash: 500,
  bank: 5000,
  hasDriverLicense: true,
  name: {
    first: "Scorz",
    last: "Dev",
  },
  phoneNumber: "6175555555",
  wallpaper: "https://imgur.com/Lm8aAxI.png",
  brand: "android",
  notifications: true,
}

export const DefaultContacts: PhoneContact[] = []