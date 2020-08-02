RegisterNetEvent('Execute:Client:Component')
AddEventHandler('Execute:Client:Component', function(component, method, data)
    if COMPONENTS[component] ~= nil then
        if COMPONENTS[component][method] ~= nil then
            COMPONENTS[component][method](COMPONENTS[component][method], data)
        else
            COMPONENTS.Logger:Warn('Execute', 'Attempted To Execute Non-Method Attribute', { console = true })
        end
    else
        COMPONENTS.Logger:Warn('Execute', 'Attempted To Execute Method Attribute In Non-Existing Component', { console = true })
    end
end)