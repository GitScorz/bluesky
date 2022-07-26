UI = {
  Balance = {
    --- @param source number
    --- @param cash number
    UpdateCash = function(self, source, cash)
      TriggerClientEvent('UI:Client:UpdateCash', source, cash)
    end,
  }
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['bs_base']:RegisterComponent('UI', UI)
end)