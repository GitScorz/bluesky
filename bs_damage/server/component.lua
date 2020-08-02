AddEventHandler('Damage:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Database = exports['bs_base']:FetchComponent('Database')
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Logger = exports['bs_base']:FetchComponent('Logger')
    Chat = exports['bs_base']:FetchComponent('Chat')
    Damage = exports['bs_base']:FetchComponent('Damage')
    RegisterChatCommands()
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Damage', {
        'Database',
        'Callbacks',
        'Logger',
        'Chat',
        'Damage',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        RegisterCallbacks()
    end)
end)

DAMAGE = {
    UpdateClient = function(self, char, isHeal)
        TriggerClientEvent('Damage:Client:RecieveUpdate', char:GetData('Source'), char:GetData('Damage'), isHeal)
    end,
    Heal = function(self, char)
        local dmg = char:GetData('Damage')
        dmg.Bleed = 0
        for k, v in pairs(dmg.Limbs) do
            v.isDamaged = false
            v.severity = 0
        end

        char:SetData('Damage', dmg)
        self:UpdateClient(char, true)
    end
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Damage', DAMAGE)
end)