AddEventHandler('Notification:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Logger = exports['bs_base']:FetchComponent('Logger')
  Callbacks = exports['bs_base']:FetchComponent('Callbacks')
end

AddEventHandler('Core:Shared:Ready', function()
  exports['bs_base']:RequestDependencies('UI', {
    'Logger',
    'Callbacks',
  }, function(error)  
    if #error > 0 then return; end
    RetrieveComponents()
  end)
end)

NOTIFICATION = {
  --- Clear all notifications of the screen.
  Clear = function(self)
    SendNUIMessage({
      closeProgress = true
    })
  end,

  --- @param message string The message to display
  --- @param duration number The duration of the notification in milliseconds
  SendAlert = function(self, message, duration)
    SendNUIMessage({
      runProgress = true, 
      colorsent = 1,
      textsent = message, 
      fadesent = duration
    })
  end,

  --- @param message string The message to display
  --- @param duration number The duration of the notification in milliseconds
  SendError = function(self, message, duration)
    SendNUIMessage({
      runProgress = true, 
      colorsent = 2, 
      textsent = message, 
      fadesent = duration
    })
  end,

  -- TODO CUSTOM NOTIFICATIONS
  --- @param message string The message to display
  --- @param duration number The duration of the notification in milliseconds
  --- @param color string The color of the notification
  Custom = function(self, message, duration, color)
    -- SendNUIMessage({
    --   runProgress = true, 
    --   colorsent = 3, 
    --   textsent = message, 
    --   fadesent = duration
    -- })
  end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['bs_base']:RegisterComponent('Notification', NOTIFICATION)
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
  NOTIFICATION:Clear()
end)