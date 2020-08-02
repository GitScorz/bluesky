
AddEventHandler('Jobs:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Logger = exports['bs_base']:FetchComponent('Logger')
    Jobs = exports['bs_base']:FetchComponent('Jobs')
    Markers = exports['bs_base']:FetchComponent('Markers')
    Menu = exports['bs_base']:FetchComponent('Menu')
    Notification = exports['bs_base']:FetchComponent('Notification')
    Utils = exports['bs_base']:FetchComponent('Utils')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Jobs', {
        'Callbacks',
        'Logger',
        'Utils',
        'Jobs',
        'Markers',
        'Menu',
        'Notification',
    }, function(error)  
        if #error > 0 then return; end
        RetrieveComponents()
    end) 
end)

JOBS = {

}


AddEventHandler('Characters:Client:Updated', function()
    _charData = exports['bs_base']:FetchComponent('Player').LocalPlayer:GetData('Character'):GetData()
end)

RegisterNetEvent('Jobs:Client:ViewJobInformation')
AddEventHandler('Jobs:Client:ViewJobInformation', function(jobData, jobDuty)
    if jobData.job == 'unemployed' then
        Notification:Info('You\'re Unemployed')
    else
        Notification:Info('Your Job Is: '.. jobData.label .. ' - Grade: ' .. jobData.grade.label .. (jobData.workplace.id == 0 and '' or (' - Workplace: '.. jobData.workplace.label)) .. ' - Salary: '.. jobData.salary .. '. You Are '..(onDuty and 'On' or 'Off')..' Duty.', 12000)
    end
end)