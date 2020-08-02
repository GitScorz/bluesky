if IsDuplicityVersion() then
	AddEventHandler('Pwnzor:Server:Ready', function()
		exports['bs_pwnzor']:SetupServer(GetCurrentResourceName())
	end)
else
	_pToken = nil
	AddEventHandler('Pwnzor:Client:Ready', function()
		_pToken = exports['bs_pwnzor']:SetupClient(GetCurrentResourceName())
	end)
end