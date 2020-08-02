function defaultApps()
    local defApps = {}
    local docked = {
        'contacts',
        'phone',
        'messages'
    }

    for k, v in pairs(PHONE_APPS) do
        if not v.canUninstall then
            table.insert(defApps, v.name)
        end
    end

    return {
        installed = defApps,
        home = defApps,
        docked = docked
    }
end

local defaultSettings = {
    wallpaper = 'wallpaper',
    ringtone = 'ringtone',
    texttone = 'text',
    colors = {
        accent = '#1a7cc1'
    },
    zoom = 75,
    volume = 100,
    notifications = true,
    appNotifications = {},
}

RegisterServerEvent('Core:Server:SessionStarted')
AddEventHandler('Core:Server:SessionStarted', function()
    TriggerClientEvent('Phone:Client:SetApps', source, PHONE_APPS)
end)
AddEventHandler('Phone:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Fetch = exports['bs_base']:FetchComponent('Fetch')
    Database = exports['bs_base']:FetchComponent('Database')
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Logger = exports['bs_base']:FetchComponent('Logger')
    Utils = exports['bs_base']:FetchComponent('Utils')
    Chat = exports['bs_base']:FetchComponent('Chat')
    Phone = exports['bs_base']:FetchComponent('Phone')
    Middleware = exports['bs_base']:FetchComponent('Middleware')
    RegisterChatCommands()
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Phone', {
        'Fetch',
        'Database',
        'Callbacks',
        'Logger',
        'Utils',
        'Chat',
        'Phone',
        'Middleware',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        DefaultData()
        TriggerEvent('Phone:Server:RegisterMiddleware')
        TriggerEvent('Phone:Server:RegisterCallbacks')
    end)
end)

AddEventHandler('Characters:Server:CharacterCreated', function(cId)
    Database.Game:updateOne({
        collection = 'characters',
        query = {
            _id = cId,
        },
        update = {
            ['$set'] = {
                Apps = defaultApps()
            }
        }
    })
end)

-- Set phone data
RegisterServerEvent('Characters:Server:Spawn')
AddEventHandler('Characters:Server:Spawn', function()
    local char = Fetch:Source(source):GetData('Character')
    if not char:GetData('Apps') then char:SetData('Apps', defaultApps()) end
    if not char:GetData('PhoneSettings') then char:SetData('PhoneSettings', defaultSettings) end

    local src = char:GetData('Source')
    TriggerClientEvent('Phone:Client:SetApps', src, PHONE_APPS)
    TriggerClientEvent('Phone:Client:Settings', src, char:GetData('PhoneSettings'))
    TriggerClientEvent('Phone:Client:SetData', src, 'myData', {
        sid = src,
        cid = char:GetData('ID'),
        number = char:GetData('Phone'),
        name = {
            first = char:GetData('First'),
            last = char:GetData('Last')
        },
        aliases = {
            email = ('%s_%s@pixel.world'):format(char:GetData('First'):lower(), char:GetData('Last'):lower()),
            twitter = char:GetData('Twitter')
        }
    })
    local apps = char:GetData('Apps')
    TriggerClientEvent('Phone:Client:SetData', src, 'installed', apps.installed)
    TriggerClientEvent('Phone:Client:SetData', src, 'home', apps.home)
    TriggerClientEvent('Phone:Client:SetData', src, 'docked', apps.docked)
end)

AddEventHandler('Phone:Server:RegisterCallbacks', function()
    Callbacks:RegisterServerCallback('Phone:Apps:Home', function(src, data, cb)
        local char = Fetch:Source(src):GetData('Character')
        local apps = char:GetData('Apps')

        if data.action == 'add' then
            table.insert(apps.home, data.app)
        else
            for k, v in pairs(apps.home) do
                if v == data.app then
                    apps.home[k] = nil
                end
            end
        end

        char:SetData('Apps', apps)
    end)

    Callbacks:RegisterServerCallback('Phone:Apps:Dock', function(src, data, cb)
        local char = Fetch:Source(src):GetData('Character')
        local apps = char:GetData('Apps')

        if data.action == 'add' then
            if #apps.docked < 4 then
                table.insert(apps.docked, data.app)
            end
        else
            for k, v in ipairs(apps.docked) do
                if v == data.app then
                    apps.docked[k] = nil
                end
            end
        end
        
        char:SetData('Apps', apps)
    end)

    Callbacks:RegisterServerCallback('Phone:Apps:Reorder', function(src, data, cb)
        local char = Fetch:Source(src):GetData('Character')
        local apps = char:GetData('Apps')
        apps[data.type] = data.apps
        char:SetData('Apps', apps)
    end)
end)