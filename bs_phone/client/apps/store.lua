RegisterNUICallback('Install', function(data, cb)
    if data.check then
        Callbacks:ServerCallback('Phone:Store:Install:Check', data.app, cb, data.app)
    else
        Callbacks:ServerCallback('Phone:Store:Install:Do', data.app, function(status, app, time)
            if status then
                Phone.Notification:Add(data.app, 'apps/' .. data.app, 'New App Installed', app.icon, app.color, time, false, 'text')
            end

            cb(status)
        end, data.app)
    end
end)

RegisterNUICallback('Uninstall', function(data, cb)
    if data.check then
        Callbacks:ServerCallback('Phone:Store:Uninstall:Check', data.app, cb, data.app)
    else
        Callbacks:ServerCallback('Phone:Store:Uninstall:Do', data.app, cb, data.app)
    end
end)