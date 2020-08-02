local _r = false

AddEventHandler('Pwnzor:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Logger = exports['bs_base']:FetchComponent('Logger')
    Notification = exports['bs_base']:FetchComponent('Notification')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Pwnzor', {
        'Callbacks',
        'Logger',
        'Notification'
    }, function(error)  
        if #error > 0 then return; end
        RetrieveComponents()
        if not _r then
            RegisterEvents()
            RegisterCommands()
            _r = true
        end
    end)
end)