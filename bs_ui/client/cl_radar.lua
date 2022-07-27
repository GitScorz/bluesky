local function setPosLB(type, posX, posY, sizeX, sizeY)
  SetMinimapComponentPosition(type, "L", "B", posX, posY, sizeX, sizeY)
end

function ToggleRadar()
  CreateThread(function()
    RemoveReplaceTexture("platform:/textures/graphics", "radarmasksm")
    RemoveReplaceTexture("platform:/textures/graphics", "radarmasklg")
    
    SetBlipAlpha(GetNorthRadarBlip(), 0.0)

    setPosLB("minimap",       -0.0045,  -0.0245,  0.150, 0.18888)
    setPosLB("minimap_mask",  0.020,    0.022,  0.111, 0.159)
    setPosLB("minimap_blur",  -0.03,    0.002,  0.266, 0.237)

    SetMinimapClipType(0)
    SetRadarBigmapEnabled(true, false)
    Wait(150)
    SetRadarBigmapEnabled(false, false)
  end)
end