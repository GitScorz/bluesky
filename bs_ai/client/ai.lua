AI = nil
Callbacks = nil
Logger = nil
Game = nil
Stream = nil
Notification = nil 
AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('AI', AICONTROL)
end)

AddEventHandler('AI:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Logger = exports['bs_base']:FetchComponent('Logger')
    Game = exports['bs_base']:FetchComponent('Game')
    Stream = exports['bs_base']:FetchComponent('Stream')
    Notification = exports['bs_base']:FetchComponent('Notification')
    AI = exports['bs_base']:FetchComponent('AI')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('AI', {
        'Callbacks',
        'Logger',
        'Game',
        'Stream',
        'Notification',
        'AI',
    }, function(error)  
        if #error > 0 then return; end
        RetrieveComponents()
    end)
end)

AICONTROL = {

}