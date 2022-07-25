Citizen.CreateThread(function()
	local time = 0
	local prevPos = nil
	local currentPos = nil

	Citizen.Wait(30000)

	while AFKTimer == nil do
		Citizen.Wait(1000)
	end
	
	while true do
		Citizen.Wait(1000)
		--TriggerServerEvent('mythic_pwnzor:server:PingCheck', securityToken, isLoggedIn)
		local playerPed = PlayerPedId()
		if playerPed then
			currentPos = GetEntityCoords(playerPed)
			if prevPos ~= nil then
				if #(vector3(currentPos.x, currentPos.y, currentPos.z) - vector3(prevPos.x, prevPos.y, prevPos.z)) < 1.5 then
					if time > (AFKTimer * 2) then
						Callbacks:ServerCallback('Pwnzor:AFK')
					elseif time > AFKTimer then
						Notification.Persistent:Error('pwnzor-afk', 'You Will Be Kicked In ' .. ((AFKTimer * 2) - time) .. ' Seconds For Being AFK')
					end

					time = time + 1
				else
					Notification.Persistent:Remove('pwnzor-afk')
					time = 0
				end
			end

			prevPos = currentPos
		end
	end
end)