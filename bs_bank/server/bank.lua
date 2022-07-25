AddEventHandler('Bank:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Database = exports['bs_base']:FetchComponent('Database')
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Wallet = exports['bs_base']:FetchComponent('Wallet')
    Utils = exports['bs_base']:FetchComponent('Utils')
    Chat = exports['bs_base']:FetchComponent('Chat')
    Tasks = exports['bs_base']:FetchComponent('Tasks')
    Inventory = exports['bs_base']:FetchComponent('Inventory')
    Default = exports['bs_base']:FetchComponent('Default')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Bank', {
        'Callbacks',
        'Wallet',
        'Chat',
        'Database',
        'Default',
        'Utils',
        'Inventory',
        'Tasks',
    }, function(error)
        if #error > 0 then
            return
        end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        RegisterCallbacks()
        RegisterChatCommands()
        RegisterItemUse()
        RegisterTasks()
        DefaultData()
        LoadBanks()
    end)
end)

function RegisterTasks()
    Tasks:Register('bank_reset', 10, function()
        Utils:Print('Resetting Banks')
        for k, v in ipairs(Banks) do
            if not Banks[k].bankOpen and v.bankCooldown < os.time() then
                TriggerEvent('Bank:ResetBank', v._id)
            end
        end
    end)

    Tasks:Register('bank_loans', 30, function()
        Utils:Print('Updating Bank Loans')
        Database.Game:find({
            collection = 'loans',
            query = {
                PayedOff = false
            }
        }, function(success, results)
            if not success then
                return
            end
            for k, v in ipairs(results) do
                if v.DueDateTime < os.time() then
                    --Penalty Based on Money not payed for period
                    if v.Due > 0 then
                        v.Penalty = v.Penalty + (v.Due * 0.1)
                    end
                    if v.RemainingAmount <= 0 then
                        v.PayedOff = true
                    end
                    --New Due for Period based on RemainingAmount
                    v.RemainingPeriods = v.RemainingPeriods - 1
                    v.RemainingAmount = v.RemainingAmount * v.Interest
                    v.Due = math.ceil(v.RemainingAmount / (((math.pow(1 + e, v.RemainingPeriods)) - 1) / (v.Interest * (math.pow((1 + v.Interest), v.RemainingPeriods)))))
                    Database.Game:updateOne({
                        collection = 'loans',
                        query = {
                            ['_id'] = v._id
                        },
                        update = {
                            ["$set"] = {
                                RemainingPeriods = v.RemainingPeriods,
                                RemainingAmount = v.RemainingAmount,
                                Due = v.Due,
                                Penalty = v.Penalty,
                                PayedOff = v.v.PayedOff,
                                DueDateTime = os.time() + 7 * 24 * 60 * 60
                            }
                        }
                    }, function(success, results)
                        if not success then
                            return nil
                        end
                    end)

                end
            end
        end)
    end)
end

function RegisterItemUse()
    Inventory.Items:RegisterUse('card', 'Bank', function(source, item)
        TriggerClientEvent('Bank:OpenATMUI', source, item.MetaData)
    end)
end

function RegisterChatCommands()
    -- Chat:RegisterAdminCommand('bank', function(source, args, rawCommand)
    --     TriggerClientEvent('Bank:OpenBankUI', source)
    -- end, {
    --     help = 'Debug Bank',
    -- }, 0)

    -- Chat:RegisterAdminCommand('loan', function(source, args, rawCommand)
    --     TriggerClientEvent('Bank:TestLoan', source)
    -- end, {
    --     help = 'Debug Loan',
    -- }, 0)

    -- Chat:RegisterAdminCommand('bankreset', function(source, args, rawCommand)
    --     TriggerEvent('Bank:ResetBanks')
    -- end, {
    --     help = 'Debug Loan',
    -- }, 0)
end

function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Bank:GetBanks', function(source, data, cb)
        cb(Banks)
    end)

    Callbacks:RegisterServerCallback('Bank:CreateAccount', function(source, data, cb)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        local char = player:GetData('Character')

        local accountNumber = GenerateNumber()
        while IsAccountInUse(accountNumber) do
            accountNumber = GenerateNumber()
        end

        local doc = {
            Char = char:GetData('ID'),
            AccountNumber = accountNumber,
            type = data.type,
            Name = data.Name,
            Amount = 0,
            History = {},
            Enabled = true
        }

        Database.Game:insertOne({
            collection = "accounts",
            document = doc
        }, function(success, result, insertedIds)
            if not success then
                return nil
            end
            doc._id = insertedIds[1]
            cb(doc)
        end)
    end)
    Callbacks:RegisterServerCallback('Bank:DisableAccount', function(source, data, cb)
        Database.Game:updateOne({
            collection = 'accounts',
            query = {
                AccountNumber = data.AccountNumber
            },
            update = {
                ["$set"] = {
                    Enabled = false
                }
            }
        }, function(success, results)
            if not success then
                cb(nil)
                return nil
            end
            cb(true)
        end)
    end)
    Callbacks:RegisterServerCallback('Bank:Withdraw', function(source, data, cb)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        local char = player:GetData('Character')
        Database.Game:updateOne({
            collection = 'accounts',
            query = {
                AccountNumber = data.AccountNumber
            },
            update = {
                ["$inc"] = {
                    Amount = -tonumber(data.Amount)
                },
                ['$push'] = {
                    History = data.History
                }
            }
        }, function(success, results)
            if not success then
                cb(nil)
                return nil
            end
            Wallet:Get(char, function(wallet)
                wallet:Modify(tonumber(data.Amount), function()
                end)
            end)
            cb(true)
        end)
    end)

    Callbacks:RegisterServerCallback('Bank:Deposit', function(source, data, cb)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        local char = player:GetData('Character')
        Database.Game:updateOne({
            collection = 'accounts',
            query = {
                AccountNumber = data.AccountNumber
            },
            update = {
                ["$inc"] = {
                    Amount = tonumber(data.Amount)
                },
                ['$push'] = {
                    History = data.History
                }
            }
        }, function(success, results)
            if not success then
                cb(nil)
                return nil
            end
            Wallet:Get(char, function(wallet)
                wallet:Modify(tonumber(-data.Amount), function()
                end)
            end)
            cb(true)
        end)
    end)

    Callbacks:RegisterServerCallback('Bank:GetAccounts', function(source, data, cb)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        local char = player:GetData('Character')
        Database.Game:find({
            collection = 'accounts',
            query = {
                Char = char:GetData('ID'),
                Enabled = true
            }
        }, function(success, results)
            if not success then
                return
            end
            if cb ~= nil then
                cb(results)
            end
        end)
    end)

    Callbacks:RegisterServerCallback('Bank:GetAccount', function(source, data, cb)
        Database.Game:findOne({
            collection = 'accounts',
            query = {
                AccountNumber = data.AccountNumber,
                Enabled = true
            }
        }, function(success, results)
            if not success then
                return
            end
            if cb ~= nil then
                cb(results[1])
            end
        end)
    end)

    Callbacks:RegisterServerCallback('Bank:CloseAccount', function(source, data, cb)
        Database.Game:updateOne({
            collection = 'accounts',
            query = {
                AccountNumber = data.AccountNumber
            },
            update = {
                ["$set"] = {
                    Enabled = false
                }
            }
        }, function(success, results)
            if not success then
                cb(nil)
                return nil
            end
            cb(data.AccountNumber)
        end)
    end)

    Callbacks:RegisterServerCallback('Bank:GetCards', function(source, data, cb)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        local char = player:GetData('Character')
        Database.Game:find({
            collection = 'cards',
            query = {
                Char = char:GetData('ID'),
                Enabled = true
            }
        }, function(success, results)
            if not success then
                return
            end
            if cb ~= nil then
                cb(results)
            end
        end)
    end)

    Callbacks:RegisterServerCallback('Bank:CommissionCard', function(source, data, cb)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        local char = player:GetData('Character')

        local cardNumber = GenerateNumber()
        while IsCardInUse(cardNumber) do
            cardNumber = GenerateNumber()
        end

        local doc = {
            Char = char:GetData('ID'),
            CardNumber = cardNumber,
            AccountNumber = data.AccountNumber,
            Enabled = true
        }

        Database.Game:insertOne({
            collection = "cards",
            document = doc
        }, function(success, result, insertedIds)
            if not success then
                return nil
            end
            doc._id = insertedIds[1]
            cb(doc)
            Wallet:Get(char, function(wallet)
                wallet:Modify(Config.CardCommissionAmount, function()

                end)
            end)
            Inventory:AddItem(char:GetData('ID'), 'card', 1, {
                AccountNumber = data.AccountNumber,
                CardNumber = cardNumber
            }, 1)
            cb(true)
        end)
    end)
    Callbacks:RegisterServerCallback('Bank:CancelCard', function(source, data, cb)
        Database.Game:updateOne({
            collection = 'cards',
            query = {
                CardNumber = data.CardNumber
            },
            update = {
                ["$set"] = {
                    Enabled = false
                }
            }
        }, function(success, results)
            if not success then
                cb(nil)
                return nil
            end
            cb(data.CardNumber)
        end)
    end)

    Callbacks:RegisterServerCallback('Bank:CreateLoan', function(source, data, cb)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        local char = player:GetData('Character')

        local loanNumber = GenerateNumber()
        while IsLoanNumberInUse(loanNumber) do
            loanNumber = GenerateNumber()
        end

        local doc = {
            Char = char:GetData('ID'),
            LoanNumber = loanNumber,
            LoanEntity = data.entity,
            RemainingAmount = data.amount,
            Interest = data.interest,
            Due = math.ceil(data.amount / (((math.pow(1 + data.interest, data.periods)) - 1) / (data.interest * (math.pow((1 + data.interest), data.periods))))),
            Penalty = 0,
            LoanType = data.type,
            RemainingPeriods = data.periods,
            DueDateTime = os.time() + 7 * 24 * 60 * 60,
            PayedOff = false,
            Payments = {}
        }

        Database.Game:insertOne({
            collection = "loans",
            document = doc
        }, function(success, result, insertedIds)
            if not success then
                return nil
            end
            doc._id = insertedIds[1]
            cb(doc)
        end)
    end)

    Callbacks:RegisterServerCallback('Bank:GetLoans', function(source, data, cb)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        local char = player:GetData('Character')
        Database.Game:find({
            collection = 'loans',
            query = {
                Char = char:GetData('ID'),
                PayedOff = false
            }
        }, function(success, results)
            if not success then
                return
            end
            if cb ~= nil then
                cb(results)
            end
        end)
    end)

    Callbacks:RegisterServerCallback('Bank:LoanPayment', function(source, data, cb)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        local char = player:GetData('Character')
        Database.Game:updateOne({
            collection = 'loans',
            query = {
                LoanNumber = data.LoanNumber
            },
            update = {
                ["$inc"] = {
                    RemainingAmount = -tonumber(data.Amount),
                    Due = -tonumber(data.Amount)
                },
                ['$push'] = {
                    Payments = data.Payment
                }
            }
        }, function(success, results)
            if not success then
                cb(nil)
                return nil
            end
            Wallet:Get(char, function(wallet)
                wallet:Modify(tonumber(-data.Amount), function()
                end)
            end)
            cb(true)
        end)
    end)
end

function IsLoanNumberInUse(account, collection)
    local var
    Database.Game:findOne({
        collection = 'loans',
        query = {
            LoanNumber = account
        }
    }, function(success, results)
        if not success then
            var = true
            return
        end
        var = #results > 0
    end)

    while var == nil do
        Citizen.Wait(10)
    end

    return var
end

function IsAccountInUse(account)
    local var
    Database.Game:findOne({
        collection = 'accounts',
        query = {
            AccountNumber = account
        }
    }, function(success, results)
        if not success then
            var = true
            return
        end
        var = #results > 0
    end)

    while var == nil do
        Citizen.Wait(10)
    end

    return var
end

function IsCardInUse(account)
    local var
    Database.Game:findOne({
        collection = 'cards',
        query = {
            CardNumber = account
        }
    }, function(success, results)
        if not success then
            var = true
            return
        end
        var = #results > 0
    end)

    while var == nil do
        Citizen.Wait(10)
    end

    return var
end

function GenerateNumber()
    local account = ''
    for i = 1, 18, 1 do
        local d = math.random(0, 9)
        account = account .. d
    end
    return account
end
