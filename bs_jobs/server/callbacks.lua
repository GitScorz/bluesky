function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Jobs:GetOnDutyCount', function(source, data, cb)
        cb(Jobs:GetOnDutyCount(data))
    end)
    Callbacks:RegisterServerCallback('Jobs:GetJobCenterJobs', function(source, data, cb)
        cb(jobCenterJobs)
    end)
    Callbacks:RegisterServerCallback('Jobs:GetJobFromJobCenter', function(source, data, cb)
        if jobCenterJobs[data] then
            local targetJob = jobCenterJobs[data]
            Jobs.Player:SetJob(source, targetJob.job, targetJob.jobcenter.default, 0, function(success)
                cb(success)
            end)
        end
    end)
end
