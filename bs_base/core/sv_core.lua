COMPONENTS.Core = {
	--- @param reason string The reason for the error.
	Shutdown = function(self, reason)
		COMPONENTS.Logger:Critical('Core', 'Shutting Down Core, Reason: ' .. reason, { 
			console = true,
			file = true
		})
    
		Citizen.Wait(1000) -- Need wait period so logging can finish
		os.exit()
	end
}

AddEventHandler('Core:Server:StartupReady', function()
	Citizen.CreateThread(function()
		if not COMPONENTS.WebAPI:Validate() then
			return
		end
	
		while not exports or exports[GetCurrentResourceName()] == nil do
			Citizen.Wait(1)
		end
	
		TriggerEvent('Database:Server:Initialize', COMPONENTS.Convar.AUTH_URL.value, COMPONENTS.Convar.AUTH_DB.value, COMPONENTS.Convar.GAME_URL.value, COMPONENTS.Convar.GAME_DB.value)
		while not COMPONENTS.Proxy.DatabaseReady do
			Citizen.Wait(1)
		end
	
		TriggerEvent('Proxy:Shared:RegisterReady')
		for k, v in pairs(COMPONENTS) do TriggerEvent('Proxy:Shared:ExtendReady', k) end
	
		Citizen.Wait(1000)
	
		COMPONENTS.Proxy.ExportsReady = true
		TriggerEvent('Proxy:Shared:ExportsReady')
		return
	end)
end)

AddEventHandler('Database:Server:Ready', function(db)
	if COMPONENTS.Database == nil and db ~= nil then COMPONENTS.Database = db end
	COMPONENTS.Proxy.DatabaseReady = true
	TriggerEvent('Core:Shared:Ready')
end)