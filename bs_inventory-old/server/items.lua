AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Items', ITEMS)
end)

function processItemCallbacks()
    Callbacks:RegisterServerCallback('Items:server:Get', function(source, data, cb)
        Items:Get(function(items)
            cb(items)
        end)
    end)

    Callbacks:RegisterServerCallback('Items:server:GetItem', function(source, data, cb)
        if data and data.item then
            Items:GetItem(data.item, function(items)
                cb(items)
            end)
        end
    end)

    Callbacks:RegisterServerCallback('Items:server:GetItemofType', function(source, data, cb)
        if data and data.item then
            Items:GetItemsOfType(data.type, function(items)
                cb(items)
            end)
        end
    end)
end

ITEMS = {
    Get = function(self, cb)
        Database.Game:find({
            collection = 'items',
            query = {}
        }, function(success, results)
            if not success then return; end
            cb(results)
        end)
    end,
    GetItem = function(self, item, cb)
        Database.Game:find({
            collection = 'items',
            query = {
                name = item
            }
        }, function(success, result)
            if not success then return; end

            if result[1] then
                cb(result[1])
            else
                cb(nil)
            end
        end)
    end,
    GetItemsOfType = function(self, type, cb)
        Database.Game:find({
            collection = 'items',
            query = {
                type = type
            }
        }, function(success, results)
            if not success then return; end
            cb(results)
        end)
    end,
}