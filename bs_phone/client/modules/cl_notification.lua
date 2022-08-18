local notificationActive = false

Phone.Notification = {
  --- @param title string The title of the notification.
  --- @param description string The description of the notification.
  --- @param icon "bell" | "twitter" | "group" | "task" | "message" | "call"
  --- @param static? boolean Whether the notification is static or not.
  Send = function(self, id, title, description, icon, static)
    local data = {
      id = math.random(1, 1000000),
      title = title,
      description = description,
      icon = icon,
      static = static or false
    }

    notificationActive = true
    UI:SendUIMessage('phone:toggle', true)
    UI:SendUIMessage('phone:sendNotification', { data })
  end,

  Close = function(self)
    if not Phone.IsPhoneOpen() then
      UI:SendUIMessage('phone:toggle', false)
    end

    notificationActive = false
  end,

  IsActive = function(self)
    return notificationActive
  end
}

RegisterCommand('donotify', function(source, args, rawCommand)
  Phone.Notification:Send("testeid", "testetitle", "testedescription", "bell")
end, false)
