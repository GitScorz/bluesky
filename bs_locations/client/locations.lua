AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Locations', LOCATIONS)
end)

AddEventHandler('Locations:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Locations = exports['bs_base']:FetchComponent('Locations')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Locations', {
        'Callbacks',
    }, function(error)
        if #error > 0 then
            return;
        end
        RetrieveComponents()
    end)
end)

LOCATIONS = {
    GetAll = function(self, type, cb)
        Callbacks:ServerCallback('Locations:GetAll', {
            type = type
        }, cb)
    end
}