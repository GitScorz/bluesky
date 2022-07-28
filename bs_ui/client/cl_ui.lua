local isHudVisible = true -- We don't have settings yet, so just assume true

RegisterNUICallback('hud:setFocus', function(data, cb)
  UI:SetFocus(data)
  cb({})
end)

AddEventHandler('Characters:Client:Spawn', function()
  UI:SetFocus(false)
  UI.Hud:Show()
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
  UI:SetFocus(false)
  UI.Hud:Hide()
  UI.Action:Hide()
end)

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
  if isHudVisible then
    UI.Hud:Hide()
  else
    UI.Hud:Show()
  end
  isHudVisible = not isHudVisible
end)

AddEventHandler('Status:Client:Update', function(status, value)
  UI.Hud:Update({ id = status, value = value })
end)