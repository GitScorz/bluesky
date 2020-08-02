COMPONENTS.Execute = {
    _name = 'base',
    Client = function(self, source, component, method, data)
        TriggerClientEvent('Execute:Client:Component', source, component, method, data)
    end,
}