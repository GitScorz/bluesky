GLOBAL_PED = PlayerPedId()
GLOBAL_VEH = GetVehiclePedIsIn(GLOBAL_PED, false)
local _paused = false

RegisterNetEvent('UI:Client:ShowBank')
AddEventHandler('UI:Client:ShowBank', function()
  UI.Balance:ShowBank()
end)

RegisterNetEvent('UI:Client:ShowCash')
AddEventHandler('UI:Client:ShowCash', function()
  UI.Balance:ShowCash()
end)

RegisterNetEvent('UI:Client:ChangeHudState')
AddEventHandler('UI:Client:ChangeHudState', function()
  local state = true -- We don't have settings yet, so just assume true
  if state then
    UI.Hud:Hide()
    state = false
  else
    UI.Hud:Show()
    state = true
  end
end)

AddEventHandler('Status:Client:Update', function(status, value)
  UI.Hud:Update({ id = status, value = value })
end)

CreateThread(function()
  while true do
    GLOBAL_PED = PlayerPedId()

    if IsPedInAnyVehicle(GLOBAL_PED, true) then
      GLOBAL_VEH = GetVehiclePedIsIn(GLOBAL_PED, false)
    else
      GLOBAL_VEH = nil
    end

    Wait(500)
  end
end)

function StartThreads()
  CreateThread(function()
    while true do
      if IsPauseMenuActive() and not _paused then
        _paused = true
        
        -- SendNUIMessage({
        --   type = 'TOGGLE_HUD'
        -- })

        -- if _vehToggled then
        --   SendNUIMessage({
        --     type = 'TOGGLE_VEHICLE'
        --   })
        -- end
      end

      if not _paused then
        -- SendNUIMessage({
        --   type = 'UPDATE_LOCATION',
        --   data = { location = GetLocation() }
        -- })
        -- Citizen.Wait(200)
        UI.Hud:Update({ id = 'health', value = (GetEntityHealth(GLOBAL_PED) - 100) })
        Wait(500)
        UI.Hud:Update({ id = 'armor', value = GetPedArmour(GLOBAL_PED) })
      else
        if not IsPauseMenuActive() then
          -- SendNUIMessage({
          --   type = 'TOGGLE_HUD'
          -- })

          _paused = false
        end
      end

      Wait(1000)
    end
  end)
end