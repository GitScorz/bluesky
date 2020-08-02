AddEventHandler('MDT:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Middleware = exports['bs_base']:FetchComponent('Middleware')
    Fetch = exports['bs_base']:FetchComponent('Fetch')
    WebAPI = exports['bs_base']:FetchComponent('WebAPI')
    Chat = exports['bs_base']:FetchComponent('Chat')
    Config = exports['bs_base']:FetchComponent('Config')
    RegisterCommands()
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('MDT', {
        'Middleware',
        'Fetch',
        'WebAPI',
        'Chat',
        'Config',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        RegisterMiddleware()
    end)
end)

function RegisterCommands()
    Chat:RegisterAdminCommand('mdt', function(source, args, rawCommand)
        TriggerClientEvent('MDT:Client:Open', source)
    end, {
        help = 'Open MDT',
    }, 0)
end

function Logout(source)
    local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
    
    if player ~= nil then
        local job, charId = nil, nil
        local char = player:GetData('Character')

        if char ~= nil then
            job = char:GetData('Job').job
            charId = char:GetData('ID')
        end

        WebAPI.MDT:Request('POST', 'user/logoutGame', {}, {
            job = job,
            user = player:GetData('ID'),
            charId = charId
        })
    end
end

function RegisterMiddleware()
    Middleware:Add('Characters:Logout', function(source)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        
        if player ~= nil then
            local char = player:GetData('Character')
    
            print(char ~= nil)
            if char ~= nil then
                if char:GetData('JobDuty') then
                    WebAPI.MDT:Request('POST', 'user/offDuty', {}, {
                        job = char:GetData('Job').job,
                        user = player:GetData('ID'),
                        charId = char:GetData('ID')
                    })
                end
            end
        
            WebAPI.MDT:Request('POST', 'user/logoutGame', {}, {
                user = player:GetData('ID')
            })
        end
    end, 9000)
    Middleware:Add('playerDropped', function(source)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        
        if player ~= nil then
            if char ~= nil then
                WebAPI.MDT:Request('POST', 'user/offDuty', {}, {
                    job = char:GetData('Job').job,
                    user = player:GetData('ID'),
                    charId = char:GetData('ID')
                })
            end
        
            WebAPI.MDT:Request('POST', 'user/logoutGame', {}, {
                user = player:GetData('ID')
            })
        end
    end, 9000)
end

RegisterServerEvent('Characters:Server:Spawn')
AddEventHandler('Characters:Server:Spawn', function()
    local _src = source
    local player = exports['bs_base']:FetchComponent('Fetch'):Source(_src)

    local char = player:GetData('Character'):GetData()
    char.Server = Config.Server.ID
    WebAPI.MDT:Request('POST', 'user/loginGame', {}, {
        user = player:GetData('ID'),
        character = char
    })
end)