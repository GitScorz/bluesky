INVENTORY.Items = {
  RegisterUse = function(self, id, component, cb)
    if ITEM_CALLBACKS[id] == nil then
      ITEM_CALLBACKS[id] = {}
    end
    ITEM_CALLBACKS[id][component] = cb
  end,

  Use = function(self, source, item, cb)
    if item.id == nil then cb(false) return end

    if Inventory:IsValidItem(item.id) then
      TriggerClientEvent('Inventory:CloseUI', source)
    end

    Wait(500)

    TriggerClientEvent('Inventory:UsedItem', source, item)

    if ITEM_CALLBACKS[item.id] ~= nil then
      for k, callback in pairs(ITEM_CALLBACKS[item.id]) do
        callback(source, item)
      end
    end

    cb(true)
  end,
}
