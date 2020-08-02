PHONE.Store = {
    Install = {
        Check = function(self, app, method)
            -- As of now, just pass true, idfk if we doing this shti
            Citizen.Wait(5000)
            return method == 'store'
        end,
        Do = function(self, app, apps, method)
            print(json.encode(apps))
            -- Starting The Aids Bcuz Idk Where The Bug Is
            local twat = {}
            for k, v in ipairs(apps.installed) do twat[v] = true end
            if twat[app] ~= nil then cb(false) else twat[app] = true end
            apps.installed = {}
            for k, v in pairs(twat) do table.insert(apps.installed, k) end
            -- Ending The Aids Bcuz Idk Where The Bug Is
            return apps
        end,
    },
    Uninstall = {
        Check = function(self, app)
            Citizen.Wait(5000)
            return true
        end,
        Do = function(self, app, apps)
            local newApps = {
                installed = {},
                home = {},
                docked = {}
            }
    
            for k, v in ipairs(apps.installed) do
                if v ~= app then
                    table.insert(newApps.installed, v)
                end
            end
    
            for k, v in ipairs(apps.home) do
                if v ~= app then
                    table.insert(newApps.home, v)
                end
            end
    
            for k, v in ipairs(apps.docked) do
                if v ~= app then
                    table.insert(newApps.docked, v)
                end
            end

            return newApps
        end,
    }
}

AddEventHandler('Phone:Server:RegisterCallbacks', function()
    Callbacks:RegisterServerCallback('Phone:Store:Install:Check', function(src, data, cb)
        local char = Fetch:Source(src):GetData('Character')
        Citizen.CreateThread(function()
            cb(Phone.Store.Install:Check(data))
        end)
    end)

    Callbacks:RegisterServerCallback('Phone:Store:Install:Do', function(src, data, cb)
        local char = Fetch:Source(src):GetData('Character')
        Citizen.CreateThread(function()
            char:SetData('Apps', Phone.Store.Install:Do(data, char:GetData('Apps'), 'store'))
            cb(true, PHONE_APPS[data], os.time() * 1000)
        end)
    end)

    Callbacks:RegisterServerCallback('Phone:Store:Uninstall:Check', function(src, data, cb)
        local char = Fetch:Source(src):GetData('Character')
        Citizen.CreateThread(function()
            cb(Phone.Store.Uninstall:Check(data))
        end)
    end)

    Callbacks:RegisterServerCallback('Phone:Store:Uninstall:Do', function(src, data, cb)
        local char = Fetch:Source(src):GetData('Character')
        Citizen.CreateThread(function()
            local nApps = Phone.Store.Uninstall:Do(data, char:GetData('Apps'))
            print(json.encode(nApps))
            char:SetData('Apps', nApps)
            cb(true)
        end)
    end)
end)
