Dealers, Vehicles = {}, {}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('VehicleShop', VEHICLESHOP)
end)

AddEventHandler('VehicleShop:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Database = exports['bs_base']:FetchComponent('Database')
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Logger = exports['bs_base']:FetchComponent('Logger')
    Utils = exports['bs_base']:FetchComponent('Utils')
    Default = exports['bs_base']:FetchComponent('Default')
    VehicleShop = exports['bs_base']:FetchComponent('VehicleShop')
    Fetch = exports['bs_base']:FetchComponent('Fetch')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('VehicleShop', {
        'Database',
        'Callbacks',
        'Logger',
        'Utils',
        'Default',
        'VehicleShop',
        'Fetch'
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        DefaultDataVehicles()
        DefaultDataDealerships()
        RegisterCallbacks()
        VehicleShop.Fetch:Shops(function(shops)
            VehicleShop.Fetch:Vehicles(function(vehs)
                Dealers = shops
                Vehicles = vehs
            end)
        end)
    end)
end)

function RegisterCallbacks()
    Callbacks:RegisterServerCallback('VehicleShop:GetStuff', function(source, data, cb)
        cb(Dealers, Vehicles)
    end)
    Callbacks:RegisterServerCallback('VehicleShop:GetNearbyName', function(source, data, cb)
        Utils:Print(Fetch:Source(data.id))
    end)
    Callbacks:RegisterServerCallback('VehicleShop:RegisterSpot', function(source, data, cb)
        VehicleShop.Showroom:New(data.showroom.dealer, data.showroom.spot, data.data, data.props, cb)
    end)
    Callbacks:RegisterServerCallback('VehicleShop:UpdateShowroom', function(source, data, cb)
        VehicleShop.Showroom:Edit(data.dealer, data.spot, data.type, data.showroom, cb)
    end)
end

function GetVehInSpot(dealer, spot)
    if Utils:GetTableLength(Dealers[dealer].showroom) > 0 then
        for k,v in pairs(Dealers[dealer].showroom) do
            if v.spot == spot then
                return k
            end
        end
    end
    return false
end

VEHICLESHOP = {
    Fetch = {
        Shops = function(self, cb)
            Database.Game:find({
                collection = 'dealerships',
                query = {}
            }, function(success, d)
                cb(d)
            end)
        end,
        Vehicles = function(self, cb)
            local vs = {}
            Database.Game:find({
                collection = 'available_categories',
                query = {}
            }, function(success, c)
                Database.Game:find({
                    collection = 'available_vehicles',
                    query = {}
                }, function(success, vehs)
                    for p, q in pairs(c) do
                        vs[q.name] = { ['name'] = q.name, ['label'] = q.label, ['vehicles'] = {} }
                        for k, v in pairs(vehs) do
                            if v.category == q.name then
                                vs[q.name].vehicles[v.model] = v
                            end
                        end
                    end
                    cb(vs)
                end)
            end)
        end
    },
    Showroom = {
        New = function(self, dealer, spot, veh, props, cb)
            local vehSpot = GetVehInSpot(dealer, spot)
            if vehSpot then
                Dealers[dealer].showroom[vehSpot] = nil
                VehicleShop.Showroom:Update(dealer, spot, 'remove', function(done)
                    table.insert(Dealers[dealer].showroom, { spot = spot, props = props, data = veh, price = veh.price, h = Dealers[dealer].showroomSpots[spot].h } )
                    VehicleShop.Showroom:Update(dealer, spot, 'new', cb)
                end)
            else
                table.insert(Dealers[dealer].showroom, { spot = spot, props = props, data = veh, price = veh.price, h = Dealers[dealer].showroomSpots[spot].h } )
                VehicleShop.Showroom:Update(dealer, spot, 'new', cb)
            end
        end,
        Edit = function(self, dealer, spot, type, val, cb)
            Dealers[dealer].showroom = val
            VehicleShop.Showroom:Update(dealer, spot, type, cb)
        end,
        Update = function(self, dealer, spot, type, cb)
            Database.Game:updateOne({
                collection = 'dealerships',
                query = { _id = Dealers[dealer]._id },
                update = { ['$set'] = { showroom = Dealers[dealer].showroom }}
            }, function(s, r)
                if r > 0 then
                    TriggerClientEvent('VehicleShop:Client:UpdateShowroom', -1, Dealers, dealer, spot, type)
                end

                if cb then cb(r > 0) end
            end)
        end
    }
}