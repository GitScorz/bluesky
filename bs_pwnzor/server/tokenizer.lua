

--[[
    Thanks to SaltyGrandpa For The General Idea of This
]]--

local Chars = {}
local didPlayerLoad = {}
local resourceNames = {}
local resourceTokens = {}
local initComplete = false

PWNZOR = PWNZOR or {}

local Settings = Config.Components.Tokenizer

AddEventHandler('Pwnzor:Shared:DependencyUpdate', RetrieveComponentsTkn)
function RetrieveComponentsTkn()
    Pwnzor = exports['bs_base']:FetchComponent('Pwnzor')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Pwnzor-Tokenizer', {
        'Pwnzor',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponentsTkn()
    end)
end)


for Loop = 0, 255 do
	Chars[Loop+1] = string.char(Loop)
end
local String = table.concat(Chars)
local Built = {['.'] = Chars}

local AddLookup = function(CharSet)
	local Substitute = string.gsub(String, '[^'..CharSet..']', '')
	local Lookup = {}
	for Loop = 1, string.len(Substitute) do
		Lookup[Loop] = string.sub(Substitute, Loop, Loop)
	end
	Built[CharSet] = Lookup

	return Lookup
end 

function string.random(Length, CharSet)
	local CharSet = CharSet or '.'
	if CharSet == '' then
		return ''
	else
		local Result = {}
		local Lookup = Built[CharSet] or AddLookup(CharSet)
		local Range = #Lookup

		for Loop = 1, Length do
			Result[Loop] = Lookup[math.random(1, Range)]
		end

		return table.concat(Result)
	end
end

AddEventHandler('onServerResourceStart', function (resource)
    if resource == GetCurrentResourceName() then
        while Pwnzor == nil do
            Citizen.Wait(1)
        end

        Pwnzor.Tokenizer:Init()
    elseif resourceTokens[resource] ~= nil and initComplete then
        Logger:Warn('Pwnzor', '^9' .. resource .. ' Restarted, Tokenizer Disabled For Resource', { console = true })
		resourceTokens[resource] = nil
	end
end)

AddEventHandler("playerDropped", function()
    didPlayerLoad[source] = false
	resourceNames[source] = {}
end)

RegisterServerEvent('Pwnzor:Server:Generate')
AddEventHandler('Pwnzor:Server:Generate', function(resource, id)
    local src = source
	TriggerClientEvent('Pwnzor:Client:Recieved', src, id, Pwnzor.Tokenizer:GenerateEvent(src, resource))
end)

RegisterNetEvent('Pwnzor:Server:Spawned')
AddEventHandler('Pwnzor:Server:Spawned', function()
	initComplete = true
	
	Pwnzor.Tokenizer:NewPlayer(source)
	
	if not didPlayerLoad[source] then
		didPlayerLoad[source] = true
		TriggerEvent('Pwnzor:Server:Loaded', source)
    else
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        local identifier = player:GetData('Identifier')
        Logger:Error('Pwnzor', player:GetData('Name') .. ' Requested Additional Security Token', {
            console = true,
            file = true,
            database = true,
            discord = {
                type = 'error',
                webhook = GetConvar('discord_pwnzor_webhook', nil),
                content = '@everyone | Member: <@' .. discord .. '>',
            }
        }, {
            sid = player:GetData('SID'),
            identifier = player:GetData('Identifier')
        })

        if not player.Permissions:IsAdmin() then
            Punishment.Ban:Source(source, -1, 'Requested Additional Security Token', 'Pwnzor')
        end
	end
end)

PWNZOR.Tokenizer = {
    Init = function(self)
        math.randomseed(os.time())
        TriggerEvent('Pwnzor:Server:Ready')
    end,
    NewPlayer = function(self, source)
        if didPlayerLoad[source] == nil or resourceNames[source] == nil then
            didPlayerLoad[source] = false
            resourceNames[source] = {}
        end
    end,
    Generate = function(self)
        local token = string.random(Settings.Options.Length, Settings.Options.Charset)
        while not self:IsUnique(token) do
            token = string.random(Settings.Options.Length, Settings.Options.Charset)
        end
        return string.random(Settings.Options.Length, Settings.Options.Charset)
    end,
    Validate = function(self, token, source, resource)
        if resourceTokens[resource] == nil then
            return true
        else
            if token ~= resourceTokens[resource] then
                DropPlayer(source, 'Retard')
                return false
            end
        end
        return true
    end,
    IsUnique = function(self, token)
        if #resourceNames > 0 then
            for i=1, #resourceNames, 1 do
                for id,resource in pairs(resourceNames[i]) do
                    if resource == token then
                        return false
                    end
                end
            end
            for resource, storedToken in pairs(resourceTokens) do
                if storedToken == token then
                    return false
                end
            end
        end
        return true
    end,
    GenerateEvent = function(self, source, resourceName)
        self:NewPlayer(source)
        if resourceNames[source][resourceName] == nil then
            resourceNames[source][resourceName] = self:Generate()
        end
        return(resourceNames[source][resourceName])
    end,
    GetToken = function(self, resourceName)
        return resourceTokens[resourceName]
    end
}

function SetupServer(resource)
    resourceTokens[resource] = Pwnzor.Tokenizer:Generate()
	AddEventHandler('Pwnzor:Server:Loaded', function(player)
		TriggerClientEvent(Pwnzor.Tokenizer:GenerateEvent(player, resource), player, resourceTokens[resource])
	end)
end