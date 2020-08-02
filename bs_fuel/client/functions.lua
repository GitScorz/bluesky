local _multi = 1

function Print3DText(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)

    if onScreen then
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

function Round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)

	return math.floor(num * mult + 0.5) / mult
end

function SetMulti(m)
    _multi = m
end

local lowtick = 0
function FuelTick()
    if GLOBAL_VEH ~= nil then
        if IsVehicleEngineOn(GLOBAL_VEH) then
            local fuel = DecorGetFloat(GLOBAL_VEH, 'VEH_FUEL')
            local newVal = (fuel - (_multi * Config.FuelUsage[Round(GetVehicleCurrentRpm(GLOBAL_VEH), 1)]) * (Config.Classes[GetVehicleClass(GLOBAL_VEH)] or 1.0) / 20)
            if Round(newVal) > 0.0 then
                DecorSetFloat(GLOBAL_VEH, 'VEH_FUEL', newVal)
                TriggerEvent('Vehicle:Client:Fuel', Round(newVal, 1))

                if newVal < 5 then
                    if lowtick >= 3 then
                        lowtick = 0
                        Effects()
                    else
                        lowtick = lowtick + 1
                    end
                end
            else
                DecorSetFloat(GLOBAL_VEH, 'VEH_FUEL', 0)
                TriggerEvent('Vehicle:Client:Fuel', 0)
                Vehicle.Fuel:OutOfFuel(GLOBAL_VEH)
            end
        end
    end
end

local shutoff = false
function Effects()
    if shutoff then return end

    shutoff = true
    Citizen.CreateThread(function()
        Citizen.Wait(2000)
        shutoff = false
    end)

    Citizen.CreateThread(function()
        while shutoff do
            SetVehicleEngineOn(GLOBAL_VEH, false, true)
            Citizen.Wait(1)
        end
    end)
end

function FindNearestFuelPump()
	local coords = GetEntityCoords(PlayerPedId())
	local fuelPumps = {}
	local handle, object = FindFirstObject()
	local success

	repeat
		if Config.PumpModels[GetEntityModel(object)] then
			table.insert(fuelPumps, object)
		end

        success, object = FindNextObject(handle, object)
	until not success

	EndFindObject(handle)

	local pumpObject = 0
	local pumpDistance = 1000

	for k,v in pairs(fuelPumps) do
		local dstcheck = #(vector3(coords.x, coords.y, coords.z) - GetEntityCoords(v))

		if dstcheck < pumpDistance then
			pumpDistance = dstcheck
			pumpObject = v
		end
	end

	return pumpObject, pumpDistance
end