AI = nil
Callbacks = nil
Logger = nil
Chat = nil

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('AI', AICONTROL)
end)

AddEventHandler('AI:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Logger = exports['bs_base']:FetchComponent('Logger')
    Chat = exports['bs_base']:FetchComponent('Chat')
    AI = exports['bs_base']:FetchComponent('AI')
    RegisterChatCommands()
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('AI', {
        'Callbacks',
        'Logger',
        'Chat',
        'AI',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
    end)
end)

function RegisterChatCommands()
    Chat:RegisterCommand('taxi', function(source, args, rawCommand)
        AI.Taxi:Request(source)
    end, {
        help = 'Request a taxi to your location',
    }, 0)
end

AICONTROL = {

}