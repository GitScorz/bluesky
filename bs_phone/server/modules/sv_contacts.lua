RegisterServerEvent('Phone:Contacts:Create')
AddEventHandler('Phone:Contacts:Create', function(data)
  local src = source
  local char = Fetch:Source(src):GetData('Character')
  local newData = {}
  newData.character = char:GetData('ID')

  for k, v in pairs(data) do
    if v.id == "contact-name" then
      newData.name = v.input
    elseif v.id == "contact-number" then
      newData.phoneNumber = v.input
    end
  end

  Database.Game:insertOne({
    collection = 'phone_contacts',
    document = newData
  }, function(success, result)
    if not success then
      TriggerEvent('Notificaton:SendError', src, 'Failed to create contact.')
    end
  end)
end)

RegisterNetEvent('Phone:Contacts:Update')
AddEventHandler('Phone:Contacts:Update', function(data)
  local src = source
  local char = Fetch:Source(src):GetData('Character')
  local newData = {}

  for k, v in pairs(data) do
    if v.label == "Name" then
      newData.id = v.id
      newData.name = v.input
      break
    end
  end

  Database.Game:updateOne({
    collection = 'phone_contacts',
    query = {
      character = char:GetData('ID'),
      _id = newData.id
    },
    update = {
      ["$set"] = {
        name = newData.name,
      }
    }
  }, function(success, results)
    if not success then
      TriggerEvent('Notificaton:SendError', src, 'Failed to update contact.')
      return
    end
  end)
end)

RegisterNetEvent('Phone:Contacts:Delete')
AddEventHandler('Phone:Contacts:Delete', function(id)
  local src = source
  local char = Fetch:Source(src):GetData('Character')

  Database.Game:deleteOne({
    collection = 'phone_contacts',
    query = {
      character = char:GetData('ID'),
      _id = id
    }
  }, function(success, results)
    if not success then
      TriggerEvent('Notificaton:SendError', src, 'Failed to delete contact.')
      return
    end
  end)
end)

AddEventHandler('Phone:Server:RegisterCallbacks', function()
  Callbacks:RegisterServerCallback('Phone:Contacts:Get', function(source, data, cb)
    local src = source
    local char = Fetch:Source(src):GetData('Character')

    Database.Game:find({
      collection = 'phone_contacts',
      query = {
        character = char:GetData('ID'),
      }
    }, function(success, results)
      cb(results)
    end)
  end)
end)
