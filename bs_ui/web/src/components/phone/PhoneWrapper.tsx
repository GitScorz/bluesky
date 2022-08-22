import { Slide } from "@mui/material";
import { PropsWithChildren, useEffect, useMemo } from "react";
import { useRecoilState, useRecoilValue } from "recoil";
import { PHONE_EVENTS } from "../../types/phone";
import { fetchNui } from "../../utils/fetchNui";
import { phoneState } from "./hooks/state";
import "./phone.css";

export default function PhoneWrapper({ children }: PropsWithChildren) {
  const [visibility, setVisibility] = useRecoilState(phoneState.visibility);
  const phoneData = useRecoilValue(phoneState.phoneData);

  useEffect(() => {
    const handleKeyEvent = (event: KeyboardEventInit) => {
      if (event.key === "Escape") {
        if (visibility) {
          fetchNui(PHONE_EVENTS.CLOSE, false);
          setVisibility(false);
        }
      }
    };

    window.addEventListener("keyup", handleKeyEvent);
  }, [visibility, setVisibility]);

  return useMemo(
    () => (
      <>
        <Slide
          direction="up"
          timeout={{ enter: 600, exit: 400 }}
          in={visibility}
          mountOnEnter
          unmountOnExit
        >
          <div
            className="phone-wrapper"
            style={{
              bottom: 0,
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
    [visibility, children, phoneData]
  );
}
