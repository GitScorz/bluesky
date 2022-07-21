local _stores = {}

COMPONENTS.DataStore = {
    _name = 'base',

    --- @param owner number
    --- @param key string
    --- @param data any
    CreateStore = function(self, owner, key, data)
        data = data or {}
        _stores[owner] = _stores[owner] or {}

        _stores[owner][key] = data

        return {
            Owner = owner,
            Key = key,
            
            ---@param var string
            ---@param data any
            SetData = function(self, var, data)
                _stores[self.Owner][self.Key][var] = data
            end,

            ---@param var string
            GetData = function(self, var)
                if var ~= nil and var ~= '' then
                    if _stores[self.Owner][self.Key][var] ~= nil then
                        return _stores[self.Owner][self.Key][var]
                    else
                        return nil
                    end
                else
                    return _stores[self.Owner][self.Key]
                end
            end
        }
    end,

    --- @param owner number
    --- @param key string
    DeleteStore = function(self, owner, key)
        _stores[owner][key] = nil
        collectgarbage()
    end
}