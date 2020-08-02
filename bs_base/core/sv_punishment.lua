COMPONENTS.Punishment = {
    _required = { 'CheckBan', 'Kick', 'Unban', 'Ban' },
    _name = 'base',
    CheckBan = function(self, key, value)
        local retVal = -1 -- Fuck You Lua

        COMPONENTS.Database.Auth:findOne({ 
            collection = "bans",
            query = {
                [key] = value,
                active = true
            }
        }, function (success, results, insertedIds)
            if not success then
                COMPONENTS.Logger:Error('Database', '[^8Error^7] Error in insertOne: ' .. tostring(results), { console = true, file = true, database = true })
                return
            end

            if #results > 0 then
                for k, v in ipairs(results) do
                    if v.expires < os.time() and v.expires ~= -1 then
                        COMPONENTS.Database.Auth:updateOne({ collection="bans", query = { _id = v._id }, update = { ["$set"] = { active = false } } })
                    else
                        retVal = v
                        break
                    end
                end
            end

            if retVal == -1 then
                retVal = nil
            end
        end)     

        while retVal == -1 do
            Citizen.Wait(10)
        end

        return retVal
    end,
    Kick = function(self, source, reason, issuer)
        local tPlayer = COMPONENTS.Fetch:Source(source)

        if issuer ~= 'Pwnzor' then
            local iPlayer = COMPONENTS.Fetch:Source(issuer)

            if iPlayer.Permissions:GetLevel() <= tPlayer.Permissions:GetLevel() then
                COMPONENTS.Chat.Send.Server:Single(iPlayer:GetData('Source'), 'Insufficient Permissions')
                return
            end

            COMPONENTS.Punishment.Actions:Kick(source, reason, iPlayer:GetData('Name'))
            COMPONENTS.Chat.Send.Server:Single(iPlayer:GetData('Source'), string.format('%s Has Been Kicked', tPlayer:GetData('Name')))

            COMPONENTS.Logger:Info('Punishment', string.format('%s Kicked By %s For %s', tPlayer:GetData('Name'), issuer, reason), { console = true, file = true, database = true, discord = { type = 'inform' } }, {
                sid = tPlayer:GetData('SID'),
                identifier = tPlayer:GetData('Identifier'),
                reason = reason,
                issuer = issuer
            })
        else
            COMPONENTS.Punishment.Actions:Kick(source, reason, issuer)

            COMPONENTS.Logger:Info('Punishment', string.format('%s Kicked By %s For %s', tPlayer:GetData('Name'), issuer, reason), { console = true, file = true, database = true, discord = { type = 'inform', webhook = GetConvar('discord_pwnzor_webhook', nil) } }, {
                sid = tPlayer:GetData('SID'),
                identifier = tPlayer:GetData('Identifier'),
                reason = reason,
                issuer = issuer
            })
        end
    end
}


COMPONENTS.Punishment.Unban = {
    BanID = function(self, id, issuer)
        if COMPONENTS.Punishment:CheckBan('_id', id) then
            local iPlayer = COMPONENTS.Fetch:Source(issuer)
            
            COMPONENTS.Database.Auth:find({ 
                collection = "bans",
                query = {
                    _id = id,
                    active = true
                }
            }, function (success, results)
                if (COMPONENTS.Punishment.Actions:Unban(results, iPlayer)) then
                    COMPONENTS.Chat.Send.Server:Single(iPlayer:GetData('Source'), string.format('%s Has Been Revoked', id))
                end
            end)
        end
    end,
    SID = function(self, sid, issuer)
        if COMPONENTS.Punishment:CheckBan('sid', sid) then
            local tPlayer = COMPONENTS.Fetch:PlayerData('SID', sid)
            if tPlayer == nil then tPlayer = COMPONENTS.Fetch:Database('sid', sid) end
            local iPlayer = COMPONENTS.Fetch:Source(issuer)

            COMPONENTS.Database.Auth:find({ 
                collection = "bans",
                query = {
                    sid = sid,
                    active = true
                }
            }, function (success, results)
                if (COMPONENTS.Punishment.Actions:Unban(results, iPlayer)) then
                    COMPONENTS.Chat.Send.Server:Single(iPlayer:GetData('Source'), string.format('%s (SID: %s) Has Been Unbanned', tPlayer:GetData('Name'), tPlayer:GetData('SID')))
                end
            end)
        else
            COMPONENTS.Chat.Send.Server:Single(iPlayer:GetData('Source'), string.format('%s (SID: %s) Is Not Banned', tPlayer:GetData('Name'), tPlayer:GetData('SID')))
        end
    end,
    Identifier = function(self, identifier, issuer)
        if COMPONENTS.Punishment:CheckBan('identifier', identifier) then
            local tPlayer = COMPONENTS.Fetch:PlayerData('Identifier', identifier)
            if tPlayer == nil then tPlayer = COMPONENTS.Fetch:Database('identifier', identifier) end
            local iPlayer = COMPONENTS.Fetch:Source(issuer)

            COMPONENTS.Database.Auth:find({ 
                collection = "bans",
                query = {
                    identifier = identifier,
                    active = true
                }
            }, function (success, results)
                if (COMPONENTS.Punishment.Actions:Unban(results, iPlayer)) then
                    COMPONENTS.Chat.Send.Server:Single(iPlayer:GetData('Source'), string.format('%s (Identifier: %s) Has Been Unbanned', tPlayer:GetData('Name'), tPlayer:GetData('Identifier')))
                end
            end)
        else
            COMPONENTS.Chat.Send.Server:Single(iPlayer:GetData('Source'), string.format('%s (Identifier: %s) Is Not Banned', tPlayer:GetData('Name'), tPlayer:GetData('Identifier')))
        end
    end,
}

COMPONENTS.Punishment.Ban = {
    Source = function(self, source, expires, reason, issuer)
        local iPlayer = COMPONENTS.Fetch:Source(issuer)
        local tPlayer = COMPONENTS.Fetch:Source(source)
        if tPlayer ~= nil then
            if issuer ~= 'Pwnzor' then
                if iPlayer.Permissions:GetLevel() < tPlayer.Permissions:GetLevel() then
                    COMPONENTS.Chat.Send.Server:Single(iPlayer:GetData('Source'), 'Insufficient Permissions')
                    return
                end
                issuer = iPlayer:GetData('Name')
            end
            
            local expStr = 'Never'
            if expires ~= -1 then
                expires = (os.time() + ((60 * 60 * 24) * expires))
                expStr = os.date('%Y-%m-%d at %I:%M:%S %p', expires)
            end

            local banStr = string.format('%s Was Permanently Banned By %s for %s', tPlayer:GetData('Name'), issuer, reason)
            if expires ~= -1 then banStr = string.format('%s Was Banned By %s Until %s for %s', tPlayer:GetData('Name'), issuer, expStr, reason) end

            COMPONENTS.Punishment.Actions:Ban(tPlayer:GetData('Source'), tPlayer:GetData('SID'), tPlayer:GetData('Identifier'), tPlayer:GetData('Name'), reason, expires, expStr, issuer, false)
            if iPlayer ~= nil then COMPONENTS.Chat.Send.Server:Single(iPlayer:GetData('Source'), banStr) end
            COMPONENTS.Logger:Info('Punishment', banStr, { console = true, file = true, database = true, discord = { type = 'info' } }, {
                player = tPlayer:GetData('Name'),
                identifier = tPlayer:GetData('Identifier'),
                reason = reason,
                issuer = issuer,
                expires = expStr
            })
        else
            COMPONENTS.Chat.Send.Server:Single(iPlayer:GetData('Source'), 'Invalid Source')
        end
    end,
    SID = function(self, sid, expires, reason, issuer)
        local iPlayer = COMPONENTS.Fetch:Source(issuer)
        local tPlayer = COMPONENTS.Fetch:PlayerData('SID', sid)
        if tPlayer == nil then
            tPlayer = COMPONENTS.Fetch:Database('sid', sid)
        end

        local bannedPlayer = sid
                
        local expStr = 'Never'
        if expires ~= -1 then
            expires = (os.time() + ((60 * 60 * 24) * expires))
            expStr = os.date('%Y-%m-%d at %I:%M:%S %p', expires)
        end

        local banStr = string.format('SID: %s Was Permanently Banned By %s. Reason: %s', bannedPlayer, issuer, reason)
        if expires ~= -1 then banStr = string.format('SID: %s Was Banned By %s Until %s. Reason: %s', bannedPlayer, issuer, expStr, reason) end

        if tPlayer == nil then
            COMPONENTS.Punishment.Actions:Ban(nil, sid, nil, sid, nil, nil, bannedPlayer, reason, expires, expStr, issuer, false)
            if iPlayer ~= nil then COMPONENTS.Chat.Send.Server:Single(iPlayer:GetData('Source'), banStr) end
            COMPONENTS.Logger:Info('Punishment', banStr, { console = true, file = true, database = true, discord = { type = 'info' } }, {
                player = bannedPlayer,
                sid = sid,
                reason = reason,
                issuer = issuer,
                expires = expStr
            })
        else
            local tPerms = 0
    
            if issuer ~= 'Pwnzor' then
                if tPlayer:GetData('Source') ~= nil then
                    for k, v in ipairs(tPlayer:GetData('Roles')) do
                        if COMPONENTS.Config.Groups.Staff[v] then
                            if COMPONENTS.Config.Groups.Staff[v].Level > tPerms then
                                tPerms = COMPONENTS.Config.Groups.Staff[v].Level
                            end
                        end
                    end
                else
                    for k, v in ipairs(tPlayer:GetData('Roles')) do
                        if COMPONENTS.Config.Groups.Staff[v] then
                            if COMPONENTS.Config.Groups.Staff[v].Level > tPerms then
                                tPerms = COMPONENTS.Config.Groups.Staff[v].Level
                            end
                        end
                    end
                end
        
                if iPlayer.Permissions:GetLevel() <= tPerms then
                    COMPONENTS.Chat.Send.Server:Single(iPlayer:GetData('Source'), 'Insufficient Permissions')
                    return
                end

                issuer = iPlayer:GetData('Name')
            end
    
            local banStr = string.format('%s (SID: %s) Was Permanently Banned By %s. Reason: %s', tPlayer:GetData('Name'), tPlayer:GetData('SID'), issuer, reason)
            if expires ~= -1 then banStr = string.format('%s (SID: %s) Was Banned By %s Until %s. Reason: %s', tPlayer:GetData('Name'), tPlayer:GetData('SID'), issuer, expStr, reason) end
            
            COMPONENTS.Punishment.Actions:Ban(tPlayer:GetData('Source'), tPlayer:GetData('SID'), tPlayer:GetData('Identifier'), tPlayer:GetData('Name'), reason, expires, expStr, issuer, false)
            if iPlayer ~= nil then COMPONENTS.Chat.Send.Server:Single(iPlayer:GetData('Source'), banStr) end
            COMPONENTS.Logger:Info('Punishment', banStr, { console = true, file = true, database = true, discord = { type = 'info' } }, {
                player = bannedPlayer,
                sid = tPlayer:GetData('SID'),
                identifier = tPlayer:GetData('Identifier'),
                reason = reason,
                issuer = issuer,
                expires = expStr
            })
        end
    end,
    Identifier = function(self, identifier, expires, reason, issuer)
        local iPlayer = COMPONENTS.Fetch:Source(issuer)
        local tPlayer = COMPONENTS.Fetch:PlayerData('Identifier', identifier)
        if tPlayer == nil then
            tPlayer = COMPONENTS.Fetch:Database('identifier', identifier)
        end
                
        local expStr = 'Never'
        if expires ~= -1 then
            expires = (os.time() + ((60 * 60 * 24) * expires))
            expStr = os.date('%Y-%m-%d at %I:%M:%S %p', expires)
        end

        local banStr = string.format('%s (Identifier: %s) Was Permanently Banned By %s. Reason: %s', tPlayer:GetData('Name'), tPlayer:GetData('Identifier'), issuer, reason)
        if expires ~= -1 then banStr = string.format('%s (Identifier: %s) Was Banned By %s Until %s. Reason: %s', tPlayer:GetData('Name'), tPlayer:GetData('Identifier'), issuer, expStr, reason) end

        if tPlayer == nil then
            COMPONENTS.Punishment.Actions:Ban(nil, identifier, identifier, nil, bannedPlayer, reason, expires, expStr, issuer, false)
            COMPONENTS.WebAPI:Request('POST', 'admin/blacklist', {
                identifier = identifier
            }, {})
            if iPlayer ~= nil then COMPONENTS.Chat.Send.Server:Single(iPlayer:GetData('Source'), banStr) end
            COMPONENTS.Logger:Info('Punishment', banStr, { console = true, file = true, database = true, discord = { type = 'info' } }, {
                player = identifier,
                identifier = identifier,
                reason = reason,
                issuer = issuer,
                expires = expStr
            })
        else
            local tPerms = 0
    
            if issuer ~= 'Pwnzor' then
                if tPlayer:GetData('Source') ~= nil then
                    for k, v in ipairs(tPlayer:GetData('Roles')) do
                        if COMPONENTS.Config.Groups.Staff[v] then
                            if COMPONENTS.Config.Groups.Staff[v].Level > tPerms then
                                tPerms = COMPONENTS.Config.Groups.Staff[v].Level
                            end
                        end
                    end
                else
                    for k, v in ipairs(tPlayer:GetData('Roles')) do
                        if COMPONENTS.Config.Groups.Staff[v] then
                            if COMPONENTS.Config.Groups.Staff[v].Level > tPerms then
                                tPerms = COMPONENTS.Config.Groups.Staff[v].Level
                            end
                        end
                    end
                end
        
                if iPlayer.Permissions:GetLevel() <= tPerms then
                    COMPONENTS.Chat.Send.Server:Single(iPlayer:GetData('Source'), 'Insufficient Permissions')
                    return
                end

                issuer = iPlayer:GetData('Name')
            end
    
            local banStr = string.format('%s (Identifier: %s) Was Permanently Banned By %s. Reason: %s', tPlayer:GetData('Name'), tPlayer:GetData('Identifier'), issuer, reason)
            if expires ~= -1 then banStr = string.format('%s (Identifier: %s) Was Banned By %s Until %s. Reason: %s', tPlayer:GetData('Name'), tPlayer:GetData('Identifier'), issuer, expStr, reason) end
            
            COMPONENTS.Punishment.Actions:Ban(tPlayer:GetData('Source'), tPlayer:GetData('SID'), tPlayer:GetData('Identifier'), tPlayer:GetData('Name'), reason, expires, expStr, issuer, false)
            if iPlayer ~= nil then COMPONENTS.Chat.Send.Server:Single(iPlayer:GetData('Source'), banStr) end
            COMPONENTS.Logger:Info('Punishment', banStr, { console = true, file = true, database = true, discord = { type = 'info' } }, {
                player = tPlayer:GetData('Name'),
                sid = tPlayer:GetData('SID'),
                identifier = tPlayer:GetData('Identifier'),
                reason = reason,
                issuer = issuer,
                expires = expStr
            })
        end
    end,
}

COMPONENTS.Punishment.Actions = {
    Kick = function(self, tSource, reason, issuer)
        DropPlayer(tSource, string.format('Kicked From The Server By %s\nReason: %s', issuer, reason))
    end,
    Ban = function(self, tSource, tSid, tIdentifier, tName, reason, expires, expStr, issuer, mask)
        COMPONENTS.Database.Auth:insertOne({ 
            collection = "bans",
            document = {
                sid = tSid,
                identifier = tIdentifier,
                expires = expires,
                reason = reason,
                issuer = issuer,
                active = true
            }
        }, function (success, results, insertedIds)
            if not success then
                COMPONENTS.Logger:Error('Database', '[^8Error^7] Error in insertOne: ' .. tostring(results), { console = true, file = true, database = true, discord = { type = 'error' } })
                return
            end

            local data = COMPONENTS.WebAPI:Request('POST', 'admin/ban', {
                sid = tSid,
                identifier = tIdentifier,
                expires = expires
            }, {})

            if data.code ~= 200 then
                COMPONENTS.Logger:Info('Punishment', ('Failed To Ban SID %s On Website'):format(tSid), { console = true, discord = { type = 'error' } })
            end

            if mask then reason = 'Banned By Pwnzor' end
            if expires ~= -1 then
                if tSource ~= nil then
                    DropPlayer(tSource, string.format('You\'re Banned, Appeal At https://blueskyrp.com/\n\nReason: %s\nExpires: %s\nID: %s', reason, expStr, insertedIds[1]))
                end
            else
                if tSource ~= nil then
                    DropPlayer(tSource, string.format('Permanently Banned, Appeal At https://blueskyrp.com/\n\nReason: %s\nID: %s', reason, insertedIds[1]))
                end
            end
        end)
    end,
    Unban = function(self, ids, issuer)
        local success = true

        local _ids = {}
        for k, v in ipairs(ids) do
            COMPONENTS.Database.Auth:updateOne({ collection="bans", query = { _id = v._id }, update = { ["$set"] = { active = false, unbanned = { issuer = issuer:GetData('Name'), date = os.time() } } } })

            table.insert(_ids, v._id)

            local data = COMPONENTS.WebAPI:Request('DELETE', 'admin/ban', {
                sid = v.sid,
                identifier = v.identifier
            }, {})

            if data.code ~= 200 then
                success = false
                COMPONENTS.Logger:Info('Punishment', ('Failed To Revoke Site Ban For SID: %s & Identifier: %s'):format(v.sid, v.identifier), { console = true, discord = { type = 'error' } })
            end
        end

        if success then
            COMPONENTS.Logger:Info('Punishment', string.format('%s Bans Revoked By %s', #ids, issuer:GetData('Name')), { console = true, file = true, database = true, discord = { type = 'info' } }, {
                player = tWebData.name,
                sid = sid,
                issuer = issuer
            }, _ids)
        end

        return success
    end
}