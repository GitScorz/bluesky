AddEventHandler('Housing:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Logger = exports['bs_base']:FetchComponent('Logger')
    Characters = exports['bs_base']:FetchComponent('Characters')
    Interiors = exports['bs_base']:FetchComponent('Interiors')
    Sync = exports['bs_base']:FetchComponent('Sync')
    Notification = exports['bs_base']:FetchComponent('Notification')
    Housing = exports['bs_base']:FetchComponent('Housing')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Housing', {
        'Callbacks',
        'Inventory',
        'Utils',
        'Notification',
        'Action',
    }, function(error)  
        if #error > 0 then return; end
        RetrieveComponents()
    end)
end)

HOUSING = {
    Enter = function(self, house, isBackdoor)
        Callbacks:ServerCallback('Housing:AttemptEntry', { id = house.id, backdoor = isBackdoor }, function(status)
            if status then
                local coords = house.location.front
                coords.z = coords.z - 50

                Sync:Stop()
                if house.interior.furnished then
                    data = Interiors.Create.Furnished[house.interior.interior](Interiors.Create.Shell, coords, isBackdoor)
                    _houseObjects = data[1]
                    _housePoints = data[2]
                else
                    data = Interiors.Create.Shell[house.interior.interior](Interiors.Create.Shell, coords, isBackdoor)
                    _houseObjects = data[1]
                    _housePoints = data[2]
                end
            else
                Notification:SendError('House Is Locked & You Don\'t Have A Key')
            end
        end)
    end,
    Exit = function(self)
        Interiors:Delete(_houseObjects)
        _houseObjects = nil
    end,
    Extras = {
        Stash = function(self)
            -- Some sort of server-side validation that they can open the stash
        end,
        Closet = function(self)
            -- Some sort of validation that they can open their closet
        end,
        Logout = function(self)
            Characters:Logout()
        end,
    }
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Housing', HOUSING)
end)