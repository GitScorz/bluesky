COMPONENTS.Execute = {
    _name = 'base',

    --- @param source number The source of the player.
    --- @param component string The component name.
    --- @param method string The method name.
    --- @param args any The arguments of the method.
    Client = function(self, source, component, method, data)
        TriggerClientEvent('Execute:Client:Component', source, component, method, data)
    end,
}