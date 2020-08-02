Characters = nil

AddEventHandler('Characters:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Characters = exports['bs_base']:FetchComponent('Characters')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Characters', {
        'Callbacks',
        'Characters',
    }, function(error)  
        if #error > 0 then return; end
        RetrieveComponents()
    end)
end)

AddEventHandler('Characters:Client:Spawn', function()
    Characters:Update()
end)

RegisterNetEvent('Characters:Client:SetData')
AddEventHandler('Characters:Client:SetData', function(cData, cb)
    exports['bs_base']:FetchComponent('Player').LocalPlayer:SetData('Character', exports['bs_base']:FetchComponent('DataStore'):CreateStore(1, 'Character', cData))
    TriggerEvent('Characters:Client:Updated')
    if cb then
        cb()
    end
end)

CHARACTERS = {
    Updating = true,
    Logout = function(self)
        Callbacks:ServerCallback('Characters:Logout', {}, function()
            exports['bs_base']:FetchComponent('Spawn'):InitCamera()
            SendNUIMessage({
                type = 'SET_STATE',
                data = { state = 'STATE_CHARACTERS' }
            })
            Citizen.Wait(500)
            exports['bs_base']:FetchComponent('Spawn'):Init()
        end)
    end,
    Update = function(self)
        Citizen.CreateThread(function()
            while self.Updating do
                TriggerServerEvent('Characters:Server:StoreUpdate')
                Citizen.Wait(180000)
            end
        end)
    end
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Characters', CHARACTERS)
end)