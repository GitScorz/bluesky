local _ran = false

function Startup()
    if _ran then return end

    _ran = true
    Database.Game:find({
        collection = 'phone_apps'
    }, function(success, apps)
        PHONE_APPS = {}
        for k, v in ipairs(apps) do
            PHONE_APPS[v.name] = v
        end

        TriggerClientEvent('Phone:Client:SetApps', -1, PHONE_APPS)
    end)
end