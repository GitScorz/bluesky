import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useCallback, useMemo, useState } from "react";
import { useSetRecoilState } from "recoil";
import { PeekData, PEEK_EVENTS } from "../../types/peek";
import { fetchNui } from "../../utils/fetchNui";
import { peekState } from "./hooks/state";
import "./peek.styles.css";

export default function Label({ icon, label, event }: PeekData) {
  const [hovered, setHovered] = useState(false);
  const setVisibility = useSetRecoilState(peekState.visibile);
  const setPeekData = useSetRecoilState(peekState.data);

  const handleClick = useCallback(() => {
    fetchNui(PEEK_EVENTS.TRIGGER_EVENT, event);
    setVisibility(false);
    setPeekData([]);
  }, [event, setVisibility, setPeekData]);

  return useMemo(
    () => (
      <div
        className="peek-label"
        style={{
          color: hovered ? "#bad5e8" : "#fff",
        }}
        onMouseEnter={() => setHovered(true)}
        onMouseLeave={() => setHovered(false)}
        onClick={handleClick}
      >
        <span className="target-icon">
          <FontAwesomeIcon icon={icon} style={{ color: "#3aaaf9" }} />
        </span>{" "}
        {label}
      </div>
    ),
    [hovered, handleClick, icon, label]
  );
}
