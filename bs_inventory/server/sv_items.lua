INVENTORY.Items = {
  RegisterUse = function(self, id, component, cb)
    if ITEM_CALLBACKS[id] == nil then
      ITEM_CALLBACKS[id] = {}
    end
    ITEM_CALLBACKS[id][component] = cb
  end,

  Use = function(self, source, item, cb)
    TriggerClientEvent('Inventory:UsedItem', source, item)

    if ITEM_CALLBACKS[item.id] ~= nil then
      for k, callback in pairs(ITEM_CALLBACKS[item.id]) do
        callback(source, item)
      end
    end

    if Inventory:IsValidItem(item.id) then
      TriggerClientEvent('Inventory:CloseUI', source)
    end

    cb(true)
  end,
}
