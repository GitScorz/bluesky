local isHudVisible = true -- We don't have settings yet, so just assume true

AddEventHandler('Characters:Client:Spawn', function()
  UI:SetFocus(false)
  UI.Hud:Show()
  ToggleRadar()
  StartThreads()
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
  UI:SetFocus(false)
  UI.Hud:Hide()
  UI.Action:Hide()
  UI.Voip:ToggleRadio(false)
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

RegisterNetEvent('UI:Client:ShowCash')
AddEventHandler('UI:Client:ShowCash', function(cash)
  UI.Balance:ShowCash(cash)
end)

RegisterNetEvent('UI:Client:UpdateCash')
AddEventHandler('UI:Client:UpdateCash', function(cur, cash)
  UI.Balance:UpdateCash(cur, cash)
end)
