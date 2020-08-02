Convar = {}

local queueEnabled, queueActive = true, false
local resourceName = GetCurrentResourceName()
local MAX_PLAYERS = tonumber(GetConvar('sv_maxclients', '32'))

local playerJoining = false
local privPlayerJoining = false

local _dbReadyTime = 0
local _dbReady = false

local Data = {
    Session = {
        Count = 0,
        Players = {}
    },
    Dropped = {},
    Queue = {}
}

local QUEUE = {}

QUEUE.Queue = {
    Get = function(self, identifier)
        for k, v in ipairs(Data.Queue) do
            if v.Identifier == identifier then
                return k, v
            end
        end

        return nil
    end,
    Add = function(self, player)
        for k, v in ipairs(Data.Queue) do
            if player.Identifier == v.Identifier then
                if v:IsInGracePeriod() then
                    v.Deferrals = player.Deferrals
                    v.Source = player.Source
                    v.State = States.QUEUED
                else
                    QUEUE.Queue:Remove(k)
                end
                return
            end
        end

        if player.Priority > 0 then
            for k, v in ipairs(Data.Queue) do
                if player.Priority > v.Priority then
                    table.insert(Data.Queue, k, player)
                    Log(string.format(Config.Strings.PrioAdd, player.Name, player.SID, player.Identifier, k, #Data.Queue, player.Priority))
                    return
                end
            end
        end

        table.insert(Data.Queue, player)
        Log(string.format(Config.Strings.Add, player.Name, player.SID, player.Identifier, #Data.Queue, #Data.Queue))
    end,
    Remove = function(self, position)
        table.remove(Data.Queue, position)
    end,
    Join = function(self, count)
        local joined = 0
        for i = 1, #Data.Queue, 1 do
            if joined == count then break end

            if Data.Queue[i] ~= nil and Data.Queue[i].State == States.QUEUED then
                if GetPlayerEndpoint(Data.Queue[i].Source) then
                    Data.Queue[i].Deferrals.update(Config.Strings.Joining)
                    Data.Queue[i].State = States.JOINING
                    Data.Queue[i].Deferrals.done()
                    Log(string.format(Config.Strings.Joined, Data.Queue[i].Name, Data.Queue[i].SID, Data.Queue[i].Identifier))
                    joined = joined + 1
                else
                    Data.Queue[i].State = States.DISCONNECTED
                    Data.Queue[i].Grace = os.time()
                    Log(string.format(Config.Strings.Disconnected, Data.Queue[i].Name, Data.Queue[i].SID, Data.Queue[i].Identifier))
                end
            end
        end
        playerJoining = false
    end,
    Drop = function(self, priv)
        local dropping = nil
        for k, v in pairs(Data.Session) do
            if dropping == nil or v.Priority < dropping.Priority then
                dropping = v
            end
        end

        DropPlayer(dropping.Source, Config.Strings.Dropped)
        priv.Deferrals.done()
    end
}

QUEUE.Dropped = {
    Get = function(self, identifier)
        for k, v in ipairs(Data.Dropped) do
            if v.Identifier == identifier then
                return k
            end
        end

        return nil
    end,
    Add = function(self, source, message)
        for _, v in ipairs(Config.ExcludeDrop) do
            if string.find(message, v) then
                return
            end
        end
        Log('Player Dropped: ' .. message)

        if Data.Session[source] == nil then
            return
        end

        Data.Session[source].Grace = os.time()
        table.insert(Data.Dropped, Data.Session[source])
        self.Session:Remove(source)
    end,
    Remove = function(self, position)
        table.remove(Data.Dropped, position)
    end
}

QUEUE.Session = {
    Add = function(self, player)
        Data.Session.Count = Data.Session.Count + 1
        Data.Session.Players[player.Source] = player
    end,
    Remove = function(self, source)
        Data.Session.Count = Data.Session.Count - 1
        Data.Session[source] = nil
    end
}

QUEUE.Connect = function(self, source, playerName, setKickReason, deferrals)
    local license = nil

    deferrals.defer()
    Citizen.Wait(1)
    
    Citizen.CreateThread(function()
        while not _dbReady do
            deferrals.done("The Blue Sky Server has not yet finished loading, please try again in a few minutes.")
            Citizen.Wait(1000)
        end

        while GetGameTimer() < (_dbReadyTime + (Config.Settings.QueueDelay * 1000)) do
            deferrals.update(string.format(Config.Strings.Waiting, ((math.floor(_dbReadyTime / 1000) + Config.Settings.QueueDelay) - math.floor(GetGameTimer() / 1000))))
            Citizen.Wait(100)
        end

        while not queueActive do
            Citizen.Wait(100)
        end

        for _, id in ipairs(GetPlayerIdentifiers(source)) do
            if string.sub(id, 1, string.len("license:")) == "license:" then
                license = string.sub(id, string.len("license:") + 1)
            end
        end
        
        if license == nil then
            deferrals.done(Config.Strings.NoLicense)
            CancelEvent()
        end
    
        local ply = Player(license, source, deferrals)
        if ply == nil then
            deferrals.done(Config.Strings.NoAccountData)
            CancelEvent()
            return
        elseif ply == -1 then
            deferrals.done(Config.Strings.IdentifierNotLinked)
            CancelEvent()
            return
        end
    
        if not ply:IsWhitelisted() then
            deferrals.done(Config.Strings.NotWhitelisted)
            CancelEvent()
            return
        end

        local banned = ply:IsBanned()
        if banned ~= nil then
            if banned.expires == -1 then
                deferrals.done(string.format(Config.Strings.PermaBanned, banned.reason, banned._id))
            else
                deferrals.done(string.format(Config.Strings.Banned, banned.reason, os.date('%Y-%m-%d at %I:%M:%S %p', tostring(banned.expires)), banned._id))
            end
            CancelEvent()
            return
        end

        -- if Data.Session.Count < MAX_PLAYERS then
        --     self.Session:Add(ply)
        --     deferrals.update(Config.Strings.Joining)
        --     deferrals.done()
        --     return
        -- end

        if Data.Session.Count >= MAX_PLAYERS then
            if ply:IsPrivileged() then
                while privPlayerJoining do
                    deferrals.update(Config.String.PrioWaiting)
                    Citizen.Wait(100)
                end

                privPlayerJoining = true
                self.Queue:Drop(ply)
                return
            end
        end
        
        self.Queue:Add(ply)

        local pos, plyr = self.Queue:Get(license)

        while plyr == nil do
            self.Queue:Add(ply)
            pos, plyr = self.Queue:Get(license)
            Citizen.Wait(100)
        end

        while plyr.State == States.QUEUED and GetPlayerEndpoint(source) do
            pos, plyr = self.Queue:Get(license)

            local msg = ''
            if plyr.Priority > 0 then
                if plyr.TimeBoost > 0 then
                    msg = '\n\nPriority Boosts: \n⏳ Time In Queue +' .. plyr.TimeBoost .. ' ⏳' .. plyr.Message
                else
                    msg = '\n\nPriority Boosts: ' .. plyr.Message
                end
            end

            plyr.Deferrals.update(string.format(Config.Strings.Queued, pos, #Data.Queue, plyr.Timer:Output(), msg))
            plyr.Timer:Tick(plyr)
            Citizen.Wait(1000)
        end
        
        pos, plyr = self.Queue:Get(license)
        if (plyr.State == States.QUEUED) then
            plyr.State = States.DISCONNECTED
            plyr.Grace = (os.time() + (60 * 5))
            Log(string.format(Config.Strings.Grace, plyr.Name, os.date('%I:%M:%S %p', plyr.Grace)))
            Data.Queue[pos] = plyr
            --self.Queue:Remove(pos)
        end
    end)
end

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals) 
    if queueEnabled then 
        QUEUE:Connect(source, playerName, setKickReason, deferrals)
    else
        deferrals.done('Queue Closed, Try Again Later')
    end 
end)

AddEventHandler('playerDropped', function(message) if queueEnabled then QUEUE.Dropped:Add(source, message) end end)

AddEventHandler('onResourceStart', function(resource)
	if resource == 'bs_base' then
        while GetResourceState(resource) ~= "started" do Citizen.Wait(0) end
        for k, v in pairs(Data.Session.Players) do
            TriggerClientEvent('Queue:Client:SessionActive', k)
            TriggerEvent('Queue:Server:SessionActive', k, {
                Roles = v.Roles,
                Identifier = v.Identifier
            })
        end
	end
end)

AddEventHandler('Core:Shared:Ready', function()
    _dbReadyTime = GetGameTimer()
    _dbReady = true
end)

RegisterServerEvent('Core:Server:SessionStarted')
AddEventHandler('Core:Server:SessionStarted', function()
    local src = source
    for _, id in ipairs(GetPlayerIdentifiers(src)) do   
        if string.sub(id, 1, string.len("license:")) == "license:" then
            local license = string.sub(id, string.len("license:") + 1)
            local pos, ply = QUEUE.Queue:Get(license)

            if ply ~= nil then
                ply.Source = src
                ply.State = States.JOINED
                QUEUE.Session:Add(ply)
                QUEUE.Queue:Remove(pos)
                TriggerClientEvent('Queue:Client:SessionActive', src)
                TriggerEvent('Queue:Server:SessionActive', src, {
                    Roles = ply.Roles,
                    Name = ply.Name,
                    SID = ply.SID,
                    Identifier = ply.Identifier
                })
            end

            return
        end
    end

    DropPlayer(src, Config.Strings.NoLicense)
end)

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Queue', QUEUE)
end)

AddEventHandler('Queue:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    c = exports['bs_base']:FetchComponent('Config')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Queue', {
        'Config',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        
        Config.Server = c.Server
        Config.Groups = c.Groups
        queueActive = true
    end)
end)

function Log(log, flagsOverride)
    local flags = { console = true }
    if flagsOverride ~= nil then flags = flagsOverride end
    TriggerEvent('Logger:Info', 'Queue', log, flags)
end

Citizen.CreateThread(function()
    while not queueActive do
        Citizen.Wait(1000)
    end

    if not exports['bs_base']:FetchComponent('WebAPI').Enabled then
        Log("^8Queue Disabled^7", { console = true })
        queueEnabled = false
        return
    end
    
    while GetResourceState('hardcap') ~= 'stopped' do
        local state = GetResourceState('hardcap')
        if state == 'missing' then break end

        if state == 'started' then
            StopResource('hardcap')
            break
        end

        Citizen.Wait(5000)
    end

    while queueEnabled do
        if( Data.Session.Count < MAX_PLAYERS and #Data.Queue > 0 and not (playerJoining or privPlayerJoining)) then
            playerJoining = true
            QUEUE.Queue:Join(MAX_PLAYERS - Data.Session.Count)
        end

        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while queueEnabled do
        for k, v in ipairs(Data.Queue) do
            if v.State == States.DISCONNECTED and not v:IsInGracePeriod() then
                QUEUE.Queue:Remove(k)
            end           
        end
        Citizen.Wait(10000)
    end
end)