--[[
---------------------------------------------------
LUXART VEHICLE CONTROL (FOR FIVEM)
---------------------------------------------------
]]


RegisterServerEvent("VehControl:TogDfltSrnMuted_s")
AddEventHandler("VehControl:TogDfltSrnMuted_s", function(toggle)
	TriggerClientEvent("VehControl:TogDfltSrnMuted_c", -1, source, toggle)
end)

RegisterServerEvent("VehControl:SetLxSirenState_s")
AddEventHandler("VehControl:SetLxSirenState_s", function(newstate)
	TriggerClientEvent("VehControl:SetLxSirenState_c", -1, source, newstate)
end)

RegisterServerEvent("VehControl:TogPwrcallState_s")
AddEventHandler("VehControl:TogPwrcallState_s", function(toggle)
	TriggerClientEvent("VehControl:TogPwrcallState_c", -1, source, toggle)
end)

RegisterServerEvent("VehControl:SetAirManuState_s")
AddEventHandler("VehControl:SetAirManuState_s", function(newstate)
	TriggerClientEvent("VehControl:SetAirManuState_c", -1, source, newstate)
end)

RegisterServerEvent("VehControl:TogIndicState_s")
AddEventHandler("VehControl:TogIndicState_s", function(newstate)
	TriggerClientEvent("VehControl:TogIndicState_c", -1, source, newstate)
end)
