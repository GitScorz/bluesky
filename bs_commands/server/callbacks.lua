function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Commands:ValidateAdmin', function(source, data, cb)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        if player.Permissions:IsAdmin() then
            cb(true)
        else
            exports['bs_base']:FetchComponent('Logger'):Log('Commands', string.format('%s attempted to use an admin command but failed Admin Validation.', {
                console = true,
                file = true,
                database = true,
                discord = {
                    type = 'error'
                }
            }, player:GetData('Identifier')))
        end
    end)
end