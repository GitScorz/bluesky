UI = {
  Balance = {
    --- @param source number
    --- @param cash number
    UpdateCash = function(self, source, currentCash, cash)
      TriggerClientEvent('UI:Client:UpdateCash', source, currentCash, cash)
    end,
  }
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['bs_base']:RegisterComponent('UI', UI)
end)
