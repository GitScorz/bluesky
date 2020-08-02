FUEL = {
    Fuel = {
        Set = function(self, vehicle, level)
            if level >= 0 and level <= 100 then
                DecorSetFloat(vehicle, 'VEH_FUEL', level)
                TriggerEvent('Vehicle:Client:Fuel', Round(level, 1))
            end
        end,
        SetMulti = function(self, mult)
            SetMulti(mult)
        end,
        OutOfFuel = function(self, veh)
            -- Call vehicle to disable engine
        end,
        Refueled = function(self, veh)
            -- Call Vehicle To enable engine
            TriggerEvent('Vehicle:Client:Fuel', DecorGetFloat(veh, 'VEH_FUEL'))
        end,
    }
}

AddEventHandler('Proxy:Shared:ExtendReady', function(component)
    if component == 'Vehicle' then
        exports['bs_base']:ExtendComponent(component, FUEL)
    end
end)