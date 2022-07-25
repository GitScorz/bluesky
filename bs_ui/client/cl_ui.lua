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