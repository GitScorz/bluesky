function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Commands:ValidateAdmin', function(source, data, cb)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        cb(true)
        -- if player.Permissions:IsAdmin() then
        --     cb(true)
        -- else
        --     exports['bs_base']:FetchComponent('Logger'):Log('Commands', ('%s attempted to use an admin command but failed Admin Validation.'):format(player:GetData('Identifier')), {
        --         console = true,
        --         file = true,
        --         database = true,
        --         discord = {
        --             type = 'error'
        --         }
        --     })
        -- end
    end)
end