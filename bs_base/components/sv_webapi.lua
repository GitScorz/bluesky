local function _b64enc( data )
    -- character table string
	local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

    return ( (data:gsub( '.', function( x ) 
        local r,b='', x:byte()
        for i=8,1,-1 do r=r .. ( b % 2 ^ i - b % 2 ^ ( i - 1 ) > 0 and '1' or '0' ) end
        return r;
    end ) ..'0000' ):gsub( '%d%d%d?%d?%d?%d?', function( x )
        if ( #x < 6 ) then return '' end
        local c = 0
        for i = 1, 6 do c = c + ( x:sub( i, i ) == '1' and 2 ^ ( 6 - i ) or 0 ) end
        return b:sub( c+1, c+1 )
    end) .. ( { '', '==', '=' } )[ #data %3 + 1] )
end

COMPONENTS.WebAPI = {
    _required = { 'Enabled', 'GetMember', 'GetStaff', 'GetWhitelist', 'GetPriority' },
    _name = 'base',
    Enabled = true,
    Request = function(self, method, endpoint, params, jsondata)
        COMPONENTS.Logger:Trace('WebAPI', 'Endpoint Called: ' .. method .. ' - ' .. endpoint)
        local rData = nil

        -- idfk, im too tired and fucking done with all this bullshit to try to think of a better way to do this retarded fucking bullshit.
        -- Fuck everyone
        local first = true
        if params ~= nil then
            for k, v in pairs(params) do
                if first then
                    endpoint = endpoint .. '?' .. k .. '=' .. v
                    first = false
                else
                    endpoint = endpoint .. '&' .. k .. '=' .. v
                end
            end
        end

        PerformHttpRequest(COMPONENTS.Convar.API_ADDRESS.value..endpoint, function(errorCode, resultData, resultHeaders)
            data = { 
                data = resultData,
                code = errorCode,
                headers = resultHeaders
            }

            if data.code ~= nil and data.code ~= 200 then
                COMPONENTS.Logger:Error('WebAPI', 'Error: ' .. data.code, { console = true })
            end
    
            if data.data ~= nil then
                data.data = json.decode(data.data)
            end

            rData = data
    
        end, method, #jsondata > 0 and json.encode(jsondata) or "", {
            ["Content-Type"] = "application/json",
            ["Authorization"] = 'Basic ' .. _b64enc(COMPONENTS.Convar.API_TOKEN.value)
        })
    
        while rData == nil do
            Wait(0)
        end
        
        return rData
    end,
    Validate = function(self)
        COMPONENTS.Logger:Trace('Core', 'Validating API Key With Authentication Services', {
            console = true,
        })

        local res = COMPONENTS.WebAPI:Request('GET', 'admin/startup', nil, {})
    
        if res.code ~= 200 then
            COMPONENTS.Logger:Critical('Core', 'Failed Validation, Shutting Down Server', {
                console = true,
                file = true,
            })
            COMPONENTS.Core:Shutdown('Failed Validation, Shutting Down Server')

            return false
        else
            COMPONENTS.Config.Server = {
                ID = res.data.id,
                Name = res.data.name,
                Access = res.data.access,
                Region = res.data.region,
            }
            COMPONENTS.Config.Game = {
                ID = res.data.game.id,
                Name = res.data.game.name,
                Short = res.data.game.short
            }
            COMPONENTS.Config.Groups = {
                Staff = res.data.game.groups.staff,
                Whitelist = res.data.game.groups.whitelist,
                Priority = res.data.game.groups.priority,
            }

            if COMPONENTS.Config.Server.Access ~= nil then
                COMPONENTS.Logger:Trace('Core', 'Server #' .. COMPONENTS.Config.Server.ID .. ' Authenticated, Running With ' .. COMPONENTS.Config.Server.Access:upper() .. ' Access Restrictions', { console = true })
            else
                COMPONENTS.Logger:Info('Core', 'Server #' .. COMPONENTS.Config.Server.ID .. ' Authenticated, Running With No Access Restriction', { console = true })
            end

            COMPONENTS.Logger:Trace('WebAPI', 'Loaded ^5' .. res.data.game.counts.staff .. '^7 Staff Groups')
            COMPONENTS.Logger:Trace('WebAPI', 'Loaded ^5' .. res.data.game.counts.whitelist .. '^7 Whitelist Groups')
            COMPONENTS.Logger:Trace('WebAPI', 'Loaded ^5' .. res.data.game.counts.priority .. '^7 Groups With Priority Boosts')

            return true
        end
    end,
    MDT = {
        Request = function(self, method, endpoint, params, jsondata)
            COMPONENTS.Logger:Trace('WebAPI - MDT', 'Endpoint Called: ' .. method .. ' - ' .. endpoint)
    
            local rData = nil
    
            -- idfk, im too tired and fucking done with all this bullshit to try to think of a better way to do this retarded fucking bullshit.
            -- Fuck everyone
            
            -- Calm down i'm here babe // Scorz

            local first = true
            if params ~= nil then
                for k, v in pairs(params) do
                    if first then
                        endpoint = endpoint .. '?' .. k .. '=' .. v
                        first = false
                    else
                        endpoint = endpoint .. '&' .. k .. '=' .. v
                    end
                end
            end
    
            PerformHttpRequest(COMPONENTS.Convar.MDT_API_ADDRESS.value..endpoint, function(errorCode, resultData, resultHeaders)
                data = { 
                    data = resultData,
                    code = errorCode,
                    headers = resultHeaders
                }
    
                if data.code ~= nil and data.code ~= 200 then
                    COMPONENTS.Logger:Error('WebAPI - MDT', 'Error: ' .. data.code, { console = true })
                end
        
                if data.data ~= nil then
                    data.data = json.decode(data.data)
                end
    
                rData = data
        
            end, method, jsondata ~= nil and json.encode(jsondata) or "", {
                ["Content-Type"] = "application/json",
                ["Authorization"] = 'Basic ' .. _b64enc(COMPONENTS.Convar.API_TOKEN.value)
            })
        
            while rData == nil do
                Citizen.Wait(0)
            end
            
            return rData
        end,
    }
}

COMPONENTS.WebAPI.GetMember = {
    --- @param identifier string
    Roles = function(self, identifier)
        if identifier ~= nil then
            local data = COMPONENTS.WebAPI:Request('GET', 'member/roles', {
                identifier = identifier,
            }, {})

            if data.code == 401 then
                return -1
            else
                return data.data 
            end
        else
            return nil
        end
    end,

    --- @param source string
    --- @param identifier string
    Status = function(self, source, identifier)
        if source ~= nil and identifier ~= nil then
            local data = COMPONENTS.WebAPI:Request('GET', 'member/status', {
                source = source,
                identifier = identifier,
            }, {})

            if data.code == 401 then
                return -1
            else
                return data.data 
            end
        else
            return nil
        end
    end,
}