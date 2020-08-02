AddEventHandler('Fuel:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Wallet = exports['bs_base']:FetchComponent('Wallet')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Fuel', {
        'Callbacks',
        'Wallet',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        RegisterCallbacks()
    end)
end)

function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Fuel:Check', function(source, data, cb)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        local char = player:GetData('Character')
        Wallet:Get(char, function(wallet)
            cb(wallet.Cash)
        end)
    end)

    Callbacks:RegisterServerCallback('Fuel:Pay', function(source, data, cb)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        local char = player:GetData('Character')
        Wallet:Get(char, function(wallet)
            wallet:Modify(-(data * Config.BaseCost))
            exports['bs_base']:FetchComponent('Execute'):Client(source, 'Notification', 'Info', 'You Paid $' .. data * Config.BaseCost)
            cb('ok')
        end)
    end)
end