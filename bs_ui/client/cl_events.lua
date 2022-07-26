GLOBAL_PED = PlayerPedId()
GLOBAL_VEH = GetVehiclePedIsIn(GLOBAL_PED, false)

RegisterNetEvent('Events:Client:EnteredVehicle')
AddEventHandler('Events:Client:EnteredVehicle', function(currentVehicle, currentSeat, displayName)
  GLOBAL_VEH = currentVehicle
end)

RegisterNetEvent('Events:Client:ExitedVehicle')
AddEventHandler('Events:Client:ExitedVehicle', function(currentVehicle, currentSeat, displayName)
  GLOBAL_VEH = currentVehicle
end)

function StartThreads()
  CreateThread(function()
    while true do
      GLOBAL_PED = PlayerPedId()

      if IsPauseMenuActive() and not _paused then
        _paused = true

        UI.Hud:Hide()

        if GLOBAL_VEH and GetIsVehicleEngineRunning(GLOBAL_VEH) then
          DisplayRadar(true)
          DisplayHud(true)
          -- SendNUIMessage({
          --   type = 'TOGGLE_VEHICLE'
          -- })
        end
      end

      if not _paused then
        -- SendNUIMessage({
        --   type = 'UPDATE_LOCATION',
        --   data = { location = GetLocation() }
        -- })
        -- Citizen.Wait(200)
        UI.Hud:Update({ id = 'health', value = (GetEntityHealth(GLOBAL_PED) - 100) })
        Wait(1000)
        UI.Hud:Update({ id = 'armor', value = GetPedArmour(GLOBAL_PED) })
      else
        if not IsPauseMenuActive() then
          UI.Hud.Show()

          _paused = false
        end
      end

      Wait(1000)
    end
  end)
end