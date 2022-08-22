import { faSquarePiedPiper } from "@fortawesome/free-brands-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  Button,
  Fade,
  FormControl,
  InputAdornment,
  InputLabel,
  MenuItem,
  Select,
  SelectChangeEvent,
  TextField,
} from "@mui/material";
import React, { useCallback, useMemo, useState } from "react";
import { useRecoilState } from "recoil";
import { PHONE_EVENTS } from "../../../../types/phone";
import { fetchNui } from "../../../../utils/fetchNui";
import { SendAlert } from "../../../../utils/misc";
import { PHONE_STRINGS } from "../../config/config";
import { phoneState } from "../../hooks/state";
import "./Settings.css";

export default function Settings() {
  const [phoneData, setPhoneData] = useRecoilState(phoneState.phoneData);
  const [wallpaper, setWallpaper] = useState(phoneData.wallpaper);
  const [brand, setBrand] = useState(phoneData.brand);

  const handleChange = useCallback(
    (event: React.ChangeEvent<HTMLInputElement>) => {
      setWallpaper(event.target.value);
    },
    []
  );

  const isImage = useCallback((url: string) => {
    return /\.(jpg|jpeg|png|gif)$/.test(url);
  }, []);

  const handleSave = useCallback(() => {
    if (wallpaper.length === 0 || !isImage(wallpaper))
      return SendAlert(PHONE_STRINGS.INVALID_SETTINGS, "error");

    setPhoneData({ ...phoneData, wallpaper: wallpaper, brand: brand });

    fetchNui(PHONE_EVENTS.UPDATE_PHONE_SETTINGS, {
      type: "wallpaper",
      value: wallpaper,
    });

    fetchNui(PHONE_EVENTS.UPDATE_PHONE_SETTINGS, {
      type: "brand",
      value: brand,
    });

    SendAlert(PHONE_STRINGS.SETTINGS_SAVED, "default");
  }, [phoneData, setPhoneData, isImage, wallpaper, brand]);

  const handleBrandChange = useCallback(
    (event: SelectChangeEvent<unknown>) => {
      const newBrand = event.target.value as "android" | "ios";
      setBrand(newBrand);
    },
    [setBrand]
  );

  return useMemo(
    () => (
      <>
        <Fade in={true} timeout={{ enter: 300 }}>
          <div className="settings-wrapper">
            <div className="settings-title">{PHONE_STRINGS.TITLE_SETTINGS}</div>
            <div className="settings-list">
              <div className="settings-item">
                <FormControl variant="standard" fullWidth>
                  <InputLabel>Brand</InputLabel>
                  <Select
                    label="Brand"
                    value={brand}
                    onChange={handleBrandChange}
                  >
                    <MenuItem value={"android"}>Android</MenuItem>
                    <MenuItem value={"ios"}>iOS</MenuItem>
                  </Select>
                </FormControl>
              </div>

              <div className="settings-item">
                <TextField
                  fullWidth
                  variant="standard"
                  placeholder="Wallpaper"
                  value={wallpaper}
                  onChange={handleChange}
                  InputProps={{
                    startAdornment: (
                      <InputAdornment position="start">
                        <FontAwesomeIcon id="icon" icon={faSquarePiedPiper} />
                      </InputAdornment>
                    ),
                  }}
                />
              </div>

              <div className="settings-button">
                <Button
                  style={{
                    backgroundColor: "#95ef79",
                    color: "black",
                  }}
                  onClick={handleSave}
                >
                  {PHONE_STRINGS.SAVE_SETTINGS}
                </Button>
              </div>
            </div>
          </div>
        </Fade>
      </>
    ),
    [handleChange, handleSave, wallpaper, handleBrandChange, brand]
  );
}
