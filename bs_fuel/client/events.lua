RegisterNetEvent('mythic_fuel:client:StartFuelUpTick')
AddEventHandler('mythic_fuel:client:StartFuelUpTick', function(pumpObject, vehicle)
	currentFuel =  DecorGetFloat(vehicle, 'VEH_FUEL')

	while isFueling do
		Citizen.Wait(1000)
		local oldFuel = DecorGetFloat(vehicle, 'VEH_FUEL')
		local fuelToAdd = 1

		if not pumpObject then
			if GetAmmoInPedWeapon(GLOBAL_PED, 883325847) - fuelToAdd * 100 >= 0 then
				currentFuel = oldFuel + fuelToAdd

				SetPedAmmo(GLOBAL_PED, 883325847, math.floor(GetAmmoInPedWeapon(GLOBAL_PED, 883325847) - fuelToAdd * 100))
			else
				isFueling = false
			end
		else
			currentFuel = oldFuel + fuelToAdd
		end

		if currentFuel > 100.0 then
			currentFuel = 100.0
			isFueling = false
		elseif currentFuel > 0 then
			Vehicle.Fuel:Refueled(vehicle)
		end
        currentCost = currentCost + fuelToAdd
        DecorSetFloat(vehicle, 'VEH_FUEL', currentFuel)
        TriggerEvent('Vehicle:Client:Fuel', Round(currentFuel, 1))
	end

	currentCost = 0
end)