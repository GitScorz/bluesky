local function CalculateTimeToDisplay()
  local hour = GetClockHours()
  local minute = GetClockMinutes()

  local obj = {}

  if minute <= 9 then
    minute = "0" .. minute
  end

  if hour <= 9 then
    hour = "0" .. hour
  end

  obj.hour = hour
  obj.minute = minute

  return obj
end

CreateThread(function()
  while true do
    if Phone:IsPhoneOpen() then
      UI:SendUIMessage("phone:updatePhoneTime", CalculateTimeToDisplay())
    end

    Wait(1000)
  end
end)
