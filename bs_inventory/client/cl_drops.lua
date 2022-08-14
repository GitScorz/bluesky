DROP_ZONES = {}

RegisterNUICallback('DropItem', function(data, cb)
  Callbacks:ServerCallback('Inventory:Server:DropItem', data, function(meh)
    if meh then
      Callbacks:ServerCallback('Inventory:GetPlayerInventory', {}, function(inventory)
        Inventory.Secondary:Refresh()
        Inventory.Player:Update(inventory)
      end)
    end
  end)
end)

RegisterNetEvent('Inventory:Client:ProcessDropzone')
AddEventHandler('Inventory:Client:ProcessDropzone', function(action, id, data)
  if action == "add" then
    DROP_ZONES[id] = data
  else
    DROP_ZONES[id] = nil
  end
end)

function startDropsTick()
  CreateThread(function()
    while _isLoggedIn do
      local sleep = 500
      local coords = GetEntityCoords(PlayerPedId())

      for _, zone in pairs(DROP_ZONES) do
        local distance = #(coords - vector3(zone.x, zone.y, zone.z))

        if distance < 15.0 then
          sleep = 0

          DrawMarker(
            20,
            zone.x,
            zone.y,
            zone.z - 0.8,
            0,
            0,
            0,
            0,
            0,
            0,
            0.35,
            0.5,
            0.15,
            252,
            255,
            255,
            91,
            0,
            0,
            0,
            0
          )
        end
      end

      Wait(sleep)
    end
  end)
end
