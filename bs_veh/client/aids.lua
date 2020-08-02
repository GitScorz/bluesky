local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
		enum.destructor(enum.handle)
		end
		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
		disposeFunc(iter)
		return
		end
		
		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)
		
		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next
		
		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

Citizen.CreateThread(function()
	while true do
		for veh in EnumerateVehicles() do
			if (veh ~= GLOBAL_VEH and GetVehiclePedIsTryingToEnter(GLOBAL_PED) ~= veh) then
				if DecorExistOn(veh, 'VEH_IGNITION') then
					if DecorGetBool(veh, 'VEH_IGNITION') then
						SetVehicleEngineOn(veh, true, true, true)
					end
				end
			end
		end
        Citizen.Wait(500)
	end
end)