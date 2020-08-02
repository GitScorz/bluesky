local _ran = false

_properties = {}

function Startup()
    if _ran then return end

    Database.Game:find({
        collection = 'properties',
    }, function(success, results)
        if not success then
            return
        end
        Logger:Trace('Housing', 'Loaded ^5' .. #results .. '^7 Properties', { console = true })
        
        _properties = {}
        for k, v in ipairs(results) do
            v.id = v._id
            v.interior = Config.INTERIORS[v.interior]
            v.locked = true
            _properties[v._id] = v
            v._id = nil
        end
    end)

    _ran = true
end