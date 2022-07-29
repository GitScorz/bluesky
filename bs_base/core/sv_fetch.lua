COMPONENTS.Fetch = {
    _required = { 'Source', 'PlayerData', 'All' },
    _name = 'base',

    --- @param source number
    Source = function(self, source)
        return COMPONENTS.Players[source]
    end,

    --- @param key string The key to fetch the data from.
    --- @param value any The value to fetch the data from.
    PlayerData = function(self, key, value)
        for k, v in pairs(COMPONENTS.Players) do
            if v:GetData(key) == value then
                return v
            end
        end
    
        return nil
    end,

    --- @param key string The key to fetch the data from.
    --- @param value any The value to fetch the data from.
    Database = function(self, key, value)
        local retVal = -1

        COMPONENTS.Database.Auth:find({
            collection = "users",
            query = {
                [key:lower()] = value
            },
            limit = 1
        }, function (success, results)
            if not success then retVal = nil return end
            
            -- Create a DataStore to return this in so this can be used in place of finding
            -- A player currently logged in without having to change syntax
            -- THIS SHOULD BE CAREFULLY USED AND BE SURE TO BE CLEANED WHEN NO LONGER NEEDED!
            if (#results > 0) then
                local uData = COMPONENTS.WebAPI.GetMember:Roles(results[1].identifier)
                retVal = COMPONENTS.DataStore:CreateStore(-1, value, {
                    ID = results[1]._id,
                    SID = results[1].sid,
                    Identifier = results[1].identifier,
                    Name = results[1].username,
                    Roles = uData.roles
                })
            else
                retVal = nil
            end
        end)

        while retVal == -1 do
            Citizen.Wait(10)
        end

        return retVal
    end,
    
    All = function(self)
        return COMPONENTS.Players
    end
}