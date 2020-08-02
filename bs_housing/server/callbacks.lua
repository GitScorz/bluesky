function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Housing:GetProperties', function(source, data, cb)
        cb(_properties)
    end)

    Callbacks:RegisterServerCallback('Housing:AttemptEntry', function(source, data, cb)
        local char = Fetch:Source(source):GetData('Character')
        local cData = char:GetData()

        if cData.Keys ~= nil and cData.Keys[data.id] ~= nil then
            cb(true)
            return
        else
            if cData.Job ~= nil then
                for k, v in ipairs(Config.AutoKey) do
                    if cData.Job[v] ~= nil then
                        cb(true)
                        return
                    end
                end
            end

            cb(not _properties[data.id].locked)
            return
        end
    end)

    Callbacks:RegisterServerCallback('Housing:ToggleLock', function(source, data, cb)
        cb(Housing.Utils:ToggleLock(source, data))
    end)
end