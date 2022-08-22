local _ran = false

function Startup()
    if _ran then return end

    Database.Game:find({
        collection = 'jobs',
    }, function(success, results)
        if not success then
            return
        end
        Logger:Trace('Jobs', 'Loaded ^5' .. #results .. '^7 Jobs', { console = true })

        for k, v in ipairs(results) do
            v._id = nil
            _jobs[v.job] = v

            if not v.whitelisted and v.jobcenter ~= nil then
                jobCenterJobs[v.job] = v
            end
        end

        for k, v in pairs(_jobs) do
            _onDuty[k] = {}
        end

    end)
    _ran = true
end
