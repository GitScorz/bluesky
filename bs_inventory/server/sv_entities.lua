ENTITYTYPES = {
  Get = function(self, cb)
    Database.Game:find({
      collection = 'entitytypes',
      query = {}
    }, function(success, results)
      if not success then return end
      cb(results)
    end)
  end,

  GetID = function(self, id, cb)
    cb(LOADED_ENTITIES[id])
  end
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['bs_base']:RegisterComponent('EntityTypes', ENTITYTYPES)
end)
