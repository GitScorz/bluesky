COMPONENTS = {}

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Citizen.CreateThread(function()
            local ver
            repeat Wait(0) until COMPONENTS.Convar.RRP_VERSION ~= nil

            if COMPONENTS.Convar.RRP_VERSION.value == "UNKNOWN" then
                ver = "Version Unknown^7                          ^5#^7"
            else
                ver = "v"..COMPONENTS.Convar.RRP_VERSION.value.."^7                                   ^5#^7"
            end
            print(' ^5#^7  Welcome to the Blue Sky Framework ^1'..ver)
            TriggerEvent('Core:Shared:Watermark')
        end)
    end
end)