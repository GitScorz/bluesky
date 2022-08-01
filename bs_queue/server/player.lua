States = {
    QUEUED = 1,
    JOINING = 2,
    JOINED = 3,
    DISCONNECTED = 4
}

function Player(steamHex, src, deferrals)
    local member = exports['bs_base']:FetchComponent('WebAPI').GetMember:Status(src, steamHex)
    if member == nil or member == '' then return nil
    elseif member == -1 then return -1 end

    local prio = nil
    local msg = ''

    exports['bs_base']:FetchComponent('Database').Auth:find({
        collection = "users",
        query = {
            sid = member.sid
        },
        limit = 1
    }, function (success, results)
        if not success then retVal = nil return end

        if #results > 0 then
            if results[1].priority > 0 then
                prio = results[1].priority
                msg = '\n🌟 Base Priority +' .. results[1].priority .. ' 🌟' .. msg
            end
        end
        
        if prio == nil then prio = 0 end
    end)
    
    while prio == nil do
        Citizen.Wait(10)
    end
    
    -- for k, v in ipairs(member.roles) do
        -- if Config.Groups.Priority[tostring(v)] then
        --     prio = prio + tonumber(Config.Groups.Priority[tostring(v)].Priority)

        --     if Config.Groups.Priority[tostring(v)].Message ~= '' then
        --         msg = '\n' .. Config.Groups.Priority[tostring(v)].Message .. msg
        --     end
        -- end
    -- end

    local _data = {
        Source = src,
        State = States.QUEUED,
        Roles = member.roles,
        Name = member.name,
        SID = string.sub(steamHex, 7) .. "@blue.sky", -- fuck it.. do better later
        Banned = member.banned,
        Identifier = steamHex,
        Priority = prio,
        Message = msg,
        TimeBoost = 0,
        Deferrals = deferrals,
        Grace = nil
    }

    _data.Timer = {
        Hour = 0,
        Minute = 0,
        Second = 0,

        Tick = function(self, plyr)
            if self.Second == 59 then
                if self.Minute == 59 then
                    self.Second = 0
                    self.Minute = 0
                    self.Hour = self.Hour + 1
                else
                    self.Second = 0
                    self.Minute = self.Minute + 1
                end

                if plyr.TimeBoost < Config.Settings.MaxTimeBoost then
                    plyr.TimeBoost = plyr.TimeBoost + 1
                    plyr.Priority = plyr.Priority + 1
                end
            else
                self.Second = self.Second + 1
            end
        end,
        Output = function(self)
            return string.format("%02d:%02d:%02d", self.Hour, self.Minute, self.Second)
        end
    }

    _data.IsPrivileged = function(self)
        for k, v in ipairs(member.roles) do
            if v.isDev or v.isAdmin then
                return true
            end
        end

        return false
    end

    _data.IsWhitelisted = function(self)
        if Config.Server.Access == nil then
            return true
        end

        for k, v in ipairs(member.roles) do
            if Config.Server.Access == 'whitelist' then
                if Config.Groups.Whitelist[tostring(v)] then
                    return true
                end
            elseif Config.Server.Access == 'test' then
                if Config.Groups.Whitelist[tostring(v)] then
                    return true
                end
            end
        end

        return false
    end

    _data.IsBanned = function(self)
        if _data.Banned ~= 0 then
            return {
                expires = _data.Banned,
                reason = 'Banned On Site',
            }
        else
            return (exports['bs_base']:FetchComponent('Punishment'):CheckBan('sid', member.id) or
                    exports['bs_base']:FetchComponent('Punishment'):CheckBan('identifier', license))
        end
    end

    _data.IsInGracePeriod = function(self)
        if self.Grace == nil then 
            return false
        else
            return os.time() <= self.Grace + (60 * Config.Settings.Grace)
        end
    end

    return _data
end