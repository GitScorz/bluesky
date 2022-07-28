AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Bank', BANK)
end)

AddEventHandler('Bank:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Logger = exports['bs_base']:FetchComponent('Logger')
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Game = exports['bs_base']:FetchComponent('Game')
    Markers = exports['bs_base']:FetchComponent('Markers')
    Menu = exports['bs_base']:FetchComponent('Menu')
    Blips = exports['bs_base']:FetchComponent('Blips')
    Locations = exports['bs_base']:FetchComponent('Locations')
    Utils = exports['bs_base']:FetchComponent('Utils')
    Bank = exports['bs_base']:FetchComponent('Bank')
    Notification = exports['bs_base']:FetchComponent('Notification')
    Progress = exports['bs_base']:FetchComponent('Progress')
    UI = exports['bs_base']:FetchComponent('UI')
    Doors = exports['bs_base']:FetchComponent('Doors')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Bank', {
        'Logger',
        'Callbacks',
        'Game',
        'Markers',
        'Locations',
        'Notification',
        'Menu',
        'Blips',
        'Progress',
        'Utils',
        'UI',
        'Doors',
    }, function(error)
        if #error > 0 then
            return ;
        end
        RetrieveComponents()
    end)
end)

RegisterNetEvent('Bank:TestLoan')
AddEventHandler('Bank:TestLoan', function()
    local data = {
        entity = {
            RegPlate = 'HGJ456JGH',
            Make = 'Nissan Gizmo 2020'
        },
        type = 'Vehicle',
        amount = 100000,
        interest = 0.5,
        periods = 5
    }
    Callbacks:ServerCallback('Bank:CreateLoan', data, function()

    end)
end)

RegisterNetEvent('Bank:OpenBankUI')
AddEventHandler('Bank:OpenBankUI', function()
    Bank:OpenUI('Bank')
end)

RegisterNetEvent('Bank:OpenATMUI')
AddEventHandler('Bank:OpenATMUI', function(data)
    local atm, dist = FindNearestATM()
    if atm and dist < 2.0 then
        Bank:OpenUI('ATM', data)
    else
        Notification:SendError("No ATM Nearby")
    end
end)

RegisterNetEvent('Characters:Client:Spawn')
AddEventHandler('Characters:Client:Spawn', function()
    RegisterBlips()
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    Bank:CloseUI()
end)

function RegisterBlips()
    Callbacks:ServerCallback('Bank:GetBanks', {}, function(banks)
        for k, v in ipairs(banks) do
            Blips:Add(v.name, 'Bank', v.coords, 277, 25, 1.0)
        end
    end, 'blips')
end

RegisterNUICallback('Close', function(data, cb)
    cb('OK')
    Bank:CloseUI()
end)

BANK = {
    OpenUI = function(self, type, data)
        SendNUIMessage({
            type = 'ACCOUNTS_RESET_PAGE'
        })
        if type == 'Bank' then
            Callbacks:ServerCallback('Wallet:GetCash', {}, function(cash)
                SendNUIMessage({
                    type = 'SELF_SET_WALLET',
                    data = {
                        cash = cash
                    }
                })
            end)

            Callbacks:ServerCallback('Bank:GetCards', {}, function(cards)
                if #cards > 0 then
                    SendNUIMessage({
                        type = 'CARDS_SET',
                        data = cards
                    })
                end
            end)
            Callbacks:ServerCallback('Bank:GetLoans', {}, function(loans)
                if #loans > 0 then
                    SendNUIMessage({
                        type = 'LOANS_SET',
                        data = loans
                    })
                end
            end)
            Callbacks:ServerCallback('Bank:GetAccounts', {}, function(accounts)
                if #accounts > 0 then
                    SendNUIMessage({
                        type = 'ACCOUNTS_SET',
                        data = accounts
                    })
                end
                SendNUIMessage({
                    type = 'APP_SHOW'
                })
                SendNUIMessage({
                    type = 'APP_PAGE_SET',
                    data = {
                        page = 0
                    }
                })
                SetNuiFocus(true, true)
            end)
        end

        if type == 'ATM' then
            Callbacks:ServerCallback('Bank:GetAccount', {
                AccountNumber = data.AccountNumber
            }, function(account)
                Callbacks:ServerCallback('Wallet:GetCash', {}, function(cash)
                    SendNUIMessage({
                        type = 'SELF_SET_WALLET',
                        data = {
                            cash = cash
                        }
                    })
                end)
                SendNUIMessage({
                    type = 'ACCOUNTS_SELECTED',
                    data = account
                })
                SendNUIMessage({
                    type = 'ACCOUNTS_ADD',
                    data = account
                })
                SendNUIMessage({
                    type = 'APP_PAGE_SET',
                    data = {
                        page = 1
                    }
                })
                SendNUIMessage({
                    type = 'APP_SHOW'
                })
                SetNuiFocus(true, true)
            end)
        end
    end,
    CloseUI = function(self)
        SetNuiFocus(false, false)
        SendNUIMessage({
            type = 'APP_HIDE'
        })
    end
}

RegisterNUICallback('CreateAccount', function(data, cb)
    Callbacks:ServerCallback('Bank:CreateAccount', data, function(account)
        SendNUIMessage({
            type = "ACCOUNTS_ADD",
            data = account
        })
        cb('OK')
    end)
end)

RegisterNUICallback('Deposit', function(data, cb)
    Callbacks:ServerCallback('Bank:Deposit', data, function()
        cb('OK')
    end)
end)

RegisterNUICallback('LoanPayment', function(data, cb)
    Callbacks:ServerCallback('Bank:LoanPayment', data, function()
        cb('OK')
    end)
end)

RegisterNUICallback('Withdraw', function(data, cb)
    Callbacks:ServerCallback('Bank:Withdraw', data, function()
        cb('OK')
    end)
end)

RegisterNUICallback('CommissionCard', function(data, cb)
    Callbacks:ServerCallback('Bank:CommissionCard', data, function(card)
        SendNUIMessage({
            type = "CARDS_ADD",
            data = card
        })
        cb('OK')
    end)
end)

RegisterNUICallback('CancelCard', function(data, cb)
    Callbacks:ServerCallback('Bank:CancelCard', data, function(card)
        SendNUIMessage({
            type = "CARDS_REMOVE",
            data = {
                CardNumber = card
            }
        })
        cb('OK')
    end)
end)

RegisterNUICallback('CloseAccount', function(data, cb)
    Callbacks:ServerCallback('Bank:CloseAccount', data, function(account)
        SendNUIMessage({
            type = "ACCOUNTS_REMOVE",
            data = {
                AccountNumber = account
            }
        })
        cb('OK')
    end)
end)
