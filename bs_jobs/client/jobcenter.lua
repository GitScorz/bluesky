local inJobCenter = false
local jobCenterList = {}

AddEventHandler('Characters:Client:Spawn', function()
    characterLoaded = true
    Jobs.JobCenter:AddMarkers()
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    characterLoaded = false
end)

JOBS.JobCenter = {
    AddMarkers = function()
        local location = vector3(Config.JobCenterLocation.x, Config.JobCenterLocation.y, Config.JobCenterLocation.z)
        Markers.MarkerGroups:Add('jobcenter', location, 10.0)
        Markers.Markers:Add('jobcenter', 'jobcenter', location, 27, vector3(0.5, 0.5, 0.5), ({ r = 200, b = 255, g = 0 }), function()
            return true
        end, ' [E] Job Center', 2.0, function()
            Jobs.JobCenter:OpenMainMenu()
        end)
    end,
    RemoveMarkers = function(self)
        Markers.MarkerGroups:Remove('jobcenter')
    end,
    OpenMainMenu = function(self)
        Callbacks:ServerCallback('Jobs:GetJobCenterJobs', {}, function(joblist)
            jobCenterList = joblist
            local root = Menu:Create('jobCenter', 'Job Center', function(id, back)
                inJobCenter = true
            end, function()
                inJobCenter = false
            end)
            local job = _charData.Job.job
            if joblist[job] ~= nil or job == 'unemployed' then
                for k,v in pairs(joblist) do
                    if job ~= k then
                        local curr = k .. 'menu'
                        curr = Menu:Create(curr, v.label)
                        curr.Add:Text('Job Information', { 'heading', 'center' })
                        curr.Add:Text(v.jobcenter.description, { 'pad', 'center' })
                        curr.Add:Text('Job Requirements', { 'heading', 'center' })
                        curr.Add:Text(v.jobcenter.requirements, { 'pad', 'center' })
                        curr.Add:Button('Apply Now', { success = true }, function(data)
                            root:Close()
                            self:OpenApplicationForJob(k)
                        end)
                        root.Add:SubMenu(v.label, curr)
                    end
                end
                if job ~= 'unemployed' then
                    root.Add:SubMenuBack('Quit Current Job', {}, function(data)
                        root:Close()
                        Citizen.Wait(100)
                        local check = Menu:Create('quitJobValidation', 'Are You Sure You Want to Quit?')
                        check.Add:Button('Yes, Quit', { success = true }, function(data)
                            check:Close()
                            TriggerServerEvent('Jobs:Server:QuitJobFromJobCenter')
                        end)
                        check.Add:SubMenuBack('No, Cancel', {}, function(data)
                            self:OpenMainMenu()
                        end)
                        check:Show()
                    end)
                end
                root:Show()
            else
                Notification:SendError('You Cannot Use the Job Center')
            end
        end)
    end,
    OpenApplicationForJob = function(self, job)
        if jobCenterList[job] then
            local targetJob = jobCenterList[job]
            local root = Menu:Create('jobCenterApplication', targetJob.label .. ' - Job Application')
            local charName = _charData.First..' '.._charData.Last
            local signed = false
            root.Add:Text('Job Information', { 'heading', 'center' })
            root.Add:Text(targetJob.jobcenter.description, { 'pad', 'center' })
            root.Add:Text('Job Requirements', { 'heading', 'center' })
            root.Add:Text(targetJob.jobcenter.requirements, { 'pad', 'center' })
            root.Add:Text('Application', { 'heading', 'center' })
            root.Add:Text(charName .. ', please sign below to recieve the job: '.. targetJob.label ..' - ' .. targetJob.grades[targetJob.jobcenter.default].label .. '. Specific job instructions will be given if you are accepted for the job.', { 'pad', 'center' })
            root.Add:CheckBox('Please Sign Here: ' .. charName, { checked = false }, function(data)
                signed = data.data.selected
            end)
            root.Add:Button('Submit Application', { success = true }, function(data)
                root:Close()
                if signed then
                    Callbacks:ServerCallback('Jobs:GetJobFromJobCenter', targetJob.job, function(done)
                        if done then
                            Notification:SendAlert('You Were Accepted and Recieved the '.. targetJob.label .. ' Job.')
                            self:OpenInfoForJob(targetJob.job, charName)
                        end
                    end)
                else
                    Notification:SendError('You Didn\'t Sign the Job Application.')
                end
            end)

            root:Show()
        end
    end,   
    OpenInfoForJob = function(self, job, name)
        if jobCenterList[job] then
            local targetJob = jobCenterList[job] 
            local root = Menu:Create('jobCenterInstructions', targetJob.label)
            root.Add:Text('Congratulations, ' .. name .. ' you were accepted for the job: '.. targetJob.label ..'. Here are some instructions now that you have the job', { 'pad', 'center' })
            root.Add:Text('Job Instructions', { 'heading', 'center' })
            root.Add:Text(targetJob.jobcenter.instructions, { 'pad', 'center' })
            root.Add:Button('Dismiss Information', { success = true }, function(data)
                root:Close()
            end)
            root:Show()
        end
    end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Jobs', JOBS)
end)


