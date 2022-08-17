import { Slide } from "@mui/material";
import { PropsWithChildren, useEffect, useMemo } from "react";
import { useRecoilState } from "recoil";
import { PHONE_EVENTS } from "../../types/phone";
import { fetchNui } from "../../utils/fetchNui";
import { phoneState } from "./hooks/state";
import "./phone.css";

export default function PhoneWrapper({ children }: PropsWithChildren) {
  const [visibility, setVisibility] = useRecoilState(phoneState.visibility);

  useEffect(() => {
    const handleKeyEvent = (event: KeyboardEventInit) => {
      if (event.key === "Escape") {
        setVisibility(false);
        fetchNui(PHONE_EVENTS.CLOSE);
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
          <div className="phone-wrapper" style={{ bottom: "10px" }}>
            <div
              className="phone-container"
              style={{
                backgroundImage: "url(media/frames/android.png)",
              }}
            />
            <div
              className="phone-background"
              style={{
                background:
                  "linear-gradient(15deg, rgba(113,149,177,1) 0%, rgba(189,221,226,1) 100%)",
              }}
            >
              {children}
            </div>
          </div>
        </Slide>
      </>
    ),
    [visibility, children]
  );
}
