GLOBAL_PED = nil
GLOBAL_VEH = nil

RegisterNetEvent('UI:Client:UpdateCash')
AddEventHandler('UI:Client:UpdateCash', function(cash)
  UI.Balance:UpdateCash(cash)
end)

function StartThreads()
  CreateThread(function()
    while true do
      GLOBAL_PED = PlayerPedId()
      GLOBAL_VEH = GetVehiclePedIsIn(GLOBAL_PED, false)

      if IsPauseMenuActive() and not _paused then
        _paused = true

        UI.Hud:Hide()
        UI.Vehicle:Hide()
      end

      if not _paused then
        if GLOBAL_VEH and GetIsVehicleEngineRunning(GLOBAL_VEH) then
          DisplayRadar(true)
          UI.Vehicle:Show()
          UI.Vehicle:Update()
        else
          DisplayRadar(false)
          UI.Vehicle:Hide()
        end

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
end