local _middlewares = {}

AddEventHandler('onResourceStart', function(resource)
    if COMPONENTS.Proxy.ExportsReady then
        if resource ~= GetCurrentResourceName() then
            _middlewares = {}
            collectgarbage()
        end
    end
end)

COMPONENTS.Middleware = {
    TriggerEvent = function(self, event, source, ...)
        if _middlewares[event] then
            table.sort(_middlewares[event], function(a,b) return a.prio < b.prio end)
            
            for k, v in pairs(_middlewares[event]) do
                v.cb(source, ...)
            end
        end
    end,
    Add = function(self, event, cb, prio)
        
        if prio == nil then
            prio = 1
        end

        if _middlewares[event] == nil then
            _middlewares[event] = {}
        end
        
        table.insert(_middlewares[event], {cb = cb, prio = prio})
    end
}