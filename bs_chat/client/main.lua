function Print3DText(coords, text)
  local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)

  if onScreen then
      local px, py, pz = table.unpack(GetGameplayCamCoords())
      local dist = #(vector3(px, py, pz) - vector3(coords.x, coords.y, coords.z))    
      local scale = (1 / dist) * 20
      local fov = (1 / GetGameplayCamFov()) * 100
      local scale = scale * fov   
      SetTextScale(0.35, 0.35)
      SetTextFont(4)
      SetTextProportional(1)
      SetTextColour(250, 250, 250, 255)		-- You can change the text color here
      SetTextDropshadow(1, 1, 1, 1, 255)
      SetTextEdge(2, 0, 0, 0, 150)
      SetTextDropShadow()
      SetTextOutline()
      SetTextEntry("STRING")
      SetTextCentre(1)
      AddTextComponentString(text)
      SetDrawOrigin(coords.x, coords.y, coords.z, 0)
      DrawText(0.0, 0.0)
      ClearDrawOrigin()
  end
end

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
  TriggerEvent('chat:clearChat')
end)

local mes = {}
RegisterNetEvent('Chat:Client:ReceiveMe')
AddEventHandler('Chat:Client:ReceiveMe', function(sender, message)
  local senderClient = GetPlayerFromServerId(sender)
  local senderPos = GetEntityCoords(GetPlayerPed(senderClient))
  local dist = #(vector3(senderPos.x, senderPos.y, senderPos.z) - GetEntityCoords(PlayerId()))

  if dist < 20.0 then
    local timer = 500
    mes[sender] = message
    Citizen.CreateThread(function()
      while dist < 20.0 and mes[sender] == message and timer > 0 do
        senderPos = GetEntityCoords(GetPlayerPed(senderClient))
        Print3DText(senderPos, message)
        dist = #(vector3(senderPos.x, senderPos.y, senderPos.z) - GetEntityCoords(PlayerId()))
        timer = timer - 1
        Citizen.Wait(1)
      end
    end)
  end
end)