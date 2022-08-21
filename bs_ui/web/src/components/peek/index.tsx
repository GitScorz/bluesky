import { faEye } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useEffect, useMemo } from "react";
import { useRecoilState } from "recoil";
import { PEEK_EVENTS } from "../../types/peek";
import { fetchNui } from "../../utils/fetchNui";
import { peekState } from "./hooks/state";
import { usePeekService } from "./hooks/usePeekService";
import Label from "./label";
import "./peek.styles.css";

export default function Peek() {
  usePeekService();

  const [visibility, setVisibility] = useRecoilState(peekState.visibile);
  const [peekData, setPeekData] = useRecoilState(peekState.data);

  useEffect(() => {
    const handleKeyEvent = (event: KeyboardEventInit) => {
      if (event.key === "Escape") {
        if (visibility) {
          fetchNui(PEEK_EVENTS.CLOSE, {});
          setVisibility(false);
          setPeekData([]);
        }
      }
    };

    window.addEventListener("keyup", handleKeyEvent);
  }, [visibility, setVisibility, setPeekData]);

  return useMemo(
    () => (
      <>
        <div
          className="peek-wrapper"
          style={{ visibility: visibility ? "visible" : "hidden" }}
        >
          <FontAwesomeIcon
            className="peek-eye"
            icon={faEye}
            style={{ color: peekData.length > 0 ? "#3aaaf9" : "black" }}
          />
          <div className="peek-label-wrapper">
            {peekData.map((peek, index) => (
              <Label key={index} {...peek} />
            ))}
          </div>
        </div>
      </>
    ),
    [visibility, peekData]
  );
}
