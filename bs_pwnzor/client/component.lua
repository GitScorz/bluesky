AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Pwnzor', PWNZOR)
end)

PWNZOR = PWNZOR or {}