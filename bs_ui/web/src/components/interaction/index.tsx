import { Slide } from "@mui/material";
import { useState } from "react";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { InteractionData } from "../../types/interaction";
import "./interaction.css";

// debugData<UI.Interaction.Data>([
//   {
//     action: 'hud:action:showInteraction',
//     data: {
//       action: "[E] Unlocked",
//       colorType: "success",
//     },
//   }
// ])

export default function Interaction() {
  const [visible, setVisible] = useState(false);
  const [interactionData, setInteractionData] = useState<InteractionData>({
    action: "",
    colorType: "default",
  });

  useNuiEvent("hud:action:showInteraction", (data: InteractionData) => {
    setVisible(true);
    setInteractionData((oldData) => ({ ...oldData, ...data }));
  });

  useNuiEvent("hud:action:hideInteraction", () => {
    setVisible(false);
  });

  const getColor = (type: string) => {
    switch (type) {
      case "error":
        return "#de4a43";
      case "success":
        return "#5bb765";
      case "default":
        return "#1e1f24";
      default:
        return "#1e1f24";
    }
  };

  const filterKey = (text: string) => {
    const a = text.indexOf("[");
    const b = text.indexOf("]");
    const retval = text.substring(a, b + 1);
    return retval;
  };

  return (
    <Slide direction="right" timeout={{ enter: 600, exit: 500 }} in={visible}>
      <div
        className="action-container"
        style={{ backgroundColor: getColor(interactionData.colorType) }}
      >
        <div className="action-text">
          {filterKey(interactionData.action) && (
            <span id="action-text-key">
              {filterKey(interactionData.action)}
            </span>
          )}
          <span id="action-text-value">
            {interactionData.action.replace(
              filterKey(interactionData.action),
              ""
            )}
          </span>
        </div>
      </div>
    </Slide>
  );
}
