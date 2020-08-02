local _f = true
local _rs = {}

RegisterNetEvent('Pwnzor:Client:Recieved')
AddEventHandler('Pwnzor:Client:Recieved', function(i, n)
	for r, p in pairs(_rs) do
		if p.i == i then
			p.n = n
			break
		end
	end
end)

-- Local Component
TOKEN = {
    Init = function(self)
        math.randomseed(GetClockHours() + GetClockMinutes())
        TriggerEvent('Pwnzor:Client:Ready')
        Citizen.CreateThread(function()
            Citizen.Wait(Config.Token.Delay)
            TriggerServerEvent('Pwnzor:Server:Spawned')
        end)
    end,
    Request = function(self, r)
        if _rs[r] == nil then
            _rs[r] = { i = self:Generate(), n = false }
            TriggerServerEvent('Pwnzor:Server:Generate', r, _rs[r].i)
            while not _rs[r].n do
                Citizen.Wait(0)
            end
        end
        return _rs[r].n
    end,
    Generate = function(self)
        local i = math.random(1,100000)
        while not self:IsValid(i) do
            i = math.random(1,100000)
        end
        return i
    end,
    IsValid = function(self, i)
        if #_rs > 0 then
            for r,p in pairs(_rs) do
                if p.i == i then
                    return false
                end
            end
        end
        return true
    end
}

function SetupClient(r)
    local t = false
    RegisterNetEvent(TOKEN:Request(r))
    AddEventHandler(TOKEN:Request(r), function(rc) t = rc end)
    while not t do Citizen.Wait(0) end
    return t
end

AddEventHandler('playerSpawned', function()
	if _f then
		_f = false
        TOKEN:Init()
	end
end)