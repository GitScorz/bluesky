import { Slide } from "@mui/material";
import { PropsWithChildren, useEffect, useMemo } from "react";
import { useRecoilState, useRecoilValue } from "recoil";
import { PHONE_EVENTS } from "../../types/phone";
import { fetchNui } from "../../utils/fetchNui";
import { notificationState, phoneState } from "./hooks/state";
import "./phone.css";

export default function PhoneWrapper({ children }: PropsWithChildren) {
  const [visibility, setVisibility] = useRecoilState(phoneState.visibility);
  const isNotificationActive = useRecoilValue(notificationState.active);
  const phoneData = useRecoilValue(phoneState.phoneData);
  const notifications = useRecoilValue(notificationState.notifications);

  useEffect(() => {
    const handleKeyEvent = (event: KeyboardEventInit) => {
      if (event.key === "Escape") {
        setVisibility(false);
        fetchNui(PHONE_EVENTS.CLOSE, false);
      }
    };

    window.addEventListener("keyup", handleKeyEvent);
  }, [setVisibility]);

  return useMemo(
    () => (
      <>
        <Slide
          direction="up"
          timeout={{ enter: 600, exit: 400 }}
          in={visibility}
        >
          <div
            className="phone-wrapper"
            style={{
              bottom:
                notifications.length > 0 && isNotificationActive
                  ? "-550px"
                  : "0",
            }}
          >
            <div
              className="phone-container"
              style={{
                backgroundImage: `url(media/frames/${phoneData.brand}.png)`,
              }}
            />
            <div
              className="phone-background"
              style={{
                backgroundImage: `url(${phoneData.wallpaper})`,
              }}
            >
              {children}
            </div>
          </div>
        </Slide>
      </>
    ),
    [visibility, children, phoneData, isNotificationActive, notifications]
  );
}
