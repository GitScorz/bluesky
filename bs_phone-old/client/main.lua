_phoneOpen = false
_openCd = false -- Prevents spamm open/close
_settings = {}

local _loggedIn = false

AddEventHandler('Phone:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Logger = exports['bs_base']:FetchComponent('Logger')
    Phone = exports['bs_base']:FetchComponent('Phone')
    Voip = exports['bs_base']:FetchComponent('Voip')
    Notification = exports['bs_base']:FetchComponent('Notification')
    UISounds = exports['bs_base']:FetchComponent('UISounds')
    Sounds = exports['bs_base']:FetchComponent('Sounds')
    Hud = exports['bs_base']:FetchComponent('Hud')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Phone', {
        'Callbacks',
        'Logger',
        'Phone',
        'Voip',
        'Notification',
        'UISounds',
        'Sounds',
        'Hud',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
    end)
end)

RegisterNetEvent('Phone:Client:SetApps')
AddEventHandler('Phone:Client:SetApps', function(apps)
    PHONE_APPS = apps
    SendNUIMessage({
        type = 'SET_APPS',
        data = apps
    })
end)

RegisterNetEvent('Phone:Client:Settings')
AddEventHandler('Phone:Client:Settings', function(settings)
    _settings = settings
    Phone.Data:Set('settings', _settings)
end)

RegisterNetEvent('Phone:Client:Settings')
AddEventHandler('Phone:Client:Settings', function(settings)
    _settings = settings
    Phone.Data:Set('settings', settings)
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    _loggedIn = false
end)

AddEventHandler('Characters:Client:Spawn', function()
    _loggedIn = true
    Citizen.CreateThread(function()
        while _loggedIn do
            if IsControlJustReleased(0, 170) and not _openCd then
                TogglePhone()
            end
            Citizen.Wait(1)
        end
    end)
end)

function hasPhone(cb)
    cb(true) 
end

function IsInCall()
    return false
end

function TogglePhone()
    if not _openCd then
        if not _phoneOpen then
            hasPhone(function(hasPhone)
                if hasPhone then
                    Phone:Open()
                else
                    Notification:Error('You Don\'t Have a Phone', 2000)
                    _phoneOpen = false
                end
            end)
        else
            Phone:Close()
        end
    
        if not IsPedInAnyVehicle(PlayerPedId(), true) then
            DisplayRadar(_phoneOpen)
        end
    end
end

RegisterNUICallback('CDExpired', function(data, cb)
    cb('OK')
    _openCd = false
end)

RegisterNUICallback('Home', function(data, cb)
    cb('OK')
    Callbacks:ServerCallback('Phone:Apps:Home', data)
end)

RegisterNUICallback('Dock', function(data, cb)
    cb('OK')
    Callbacks:ServerCallback('Phone:Apps:Dock', data)
end)

RegisterNUICallback('Reorder', function(data, cb)
    cb('OK')
    Callbacks:ServerCallback('Phone:Apps:Reorder', data)
end)