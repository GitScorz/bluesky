local function toggleNuiFocus(shouldShow)
  SetNuiFocus(shouldShow, shouldShow)
  Logger:Info("UI", ("Set focus status: %s"):format(shouldShow))
end

RegisterNUICallback('nui:focus', function(_, cb)
  toggleNuiFocus(false)
  cb({})
end)

AddEventHandler('Characters:Client:Spawn', function()
  UI.SetFocus(false)
  UI.Hud:Show()
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
  UI.SetFocus(false)
  UI.Hud:Hide()
end)

RegisterNetEvent('UI:Client:ShowBank')
AddEventHandler('UI:Client:ShowBank', function()
  UI.Balance:ShowBank()
end)

RegisterNetEvent('UI:Client:ShowCash')
AddEventHandler('UI:Client:ShowCash', function()
  UI.Balance:ShowCash()
end)