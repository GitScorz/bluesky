AddEventHandler('Vehicle:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Notification = exports['bs_base']:FetchComponent('Notification')
    UI = exports['bs_base']:FetchComponent('UI')
    Vehicle = exports['bs_base']:FetchComponent('Vehicle')
    Progress = exports['bs_base']:FetchComponent('Progress')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Vehicle', {
        'Callbacks',
        'Notification',
        'UI',
        'Vehicle',
        'Progress',
    }, function(error)  
        if #error > 0 then return; end
        RetrieveComponents()
    end)
end)