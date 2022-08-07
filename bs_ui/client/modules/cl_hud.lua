GLOBAL_PED = nil
GLOBAL_VEH = nil
_pause = false

function StartThreads()
  CreateThread(function()
    while true do
      GLOBAL_PED = PlayerPedId()

      if IsPauseMenuActive() and not _paused then
        _paused = true

        UI.Hud:Hide()
        UI.Vehicle:Hide()
      end

      if not _paused then
        UI.Hud:Update({ id = 'health', value = (GetEntityHealth(GLOBAL_PED) - 100) })
        Wait(1000)
        UI.Hud:Update({ id = 'armor', value = GetPedArmour(GLOBAL_PED) })
      else
        if not IsPauseMenuActive() then
          UI.Hud.Show()

          _paused = false
        end
      end

      Wait(500)
    end
  end)

  CreateThread(function()
    while true do
      GLOBAL_VEH = GetVehiclePedIsIn(GLOBAL_PED, false)

      if not _paused then
        if GLOBAL_VEH and GetIsVehicleEngineRunning(GLOBAL_VEH) then
          DisplayRadar(true)
          UI.Vehicle:Show()
          UI.Vehicle:Update({ speed = math.ceil(GetEntitySpeed(GLOBAL_VEH) * 2.236936), fuel = GetVehicleFuelLevel(GLOBAL_VEH), seatbelt = false })
        else
          DisplayRadar(false)
          UI.Vehicle:Hide()
        end
      end

      Wait(100)
    end
  end)
end