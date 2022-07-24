local function toggleNuiFocus(shouldShow)
  SetNuiFocus(shouldShow, shouldShow)
  Logger:Info("UI", ("Set focus status: %s"):format(shouldShow))
end

RegisterNUICallback('nui:focus', function(_, cb)
  toggleNuiFocus(false)
  cb({})
end)