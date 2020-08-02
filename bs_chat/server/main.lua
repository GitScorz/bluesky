AddEventHandler('Characters:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Chat = exports['bs_base']:FetchComponent('Chat')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Characters', {
        'Chat',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
    end)
end)


CHAT = {
    _required = { 'Send' },
    Refresh = {
        Commands = function(self, source)
            local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
            if player ~= nil then
                local pData = player:GetData()
                local char = player:GetData('Character')
                if char ~= nil then
                    local cData = char:GetData()
                    TriggerClientEvent('chat:resetSuggestions', player:GetData('Source'))
                    for k, command in pairs(commandSuggestions) do
                        TriggerClientEvent('chat:addSuggestion', player:GetData('Source'), '/' .. k, '')
                        if IsPlayerAceAllowed(source, ('command.%s'):format(k)) then
                            if commands[k] ~= nil then
                                if commands[k].admin then
                                    if player.Permissions:IsAdmin() then
                                        TriggerClientEvent('chat:addSuggestion', player:GetData('Source'), '/' .. k, command.help, command.params)
                                    else
                                        TriggerClientEvent('chat:removeSuggestion', player:GetData('Source'), '/' .. k)
                                    end
                                elseif commands[k].job ~= nil then
                                    for k2, v2 in pairs(commands[k].job) do
                                        if cData.Job ~= nil and v2['name'] == cData.Job.job and cData.JobDuty then
                                            if tonumber(v2['gradelevel']) <= cData.Job.grade.level then
                                                TriggerClientEvent('chat:addSuggestion', player:GetData('Source'), '/' .. k, command.help, command.params)
                                            else
                                                TriggerClientEvent('chat:removeSuggestion', player:GetData('Source'), '/' .. k)
                                            end
                                        else
                                            TriggerClientEvent('chat:removeSuggestion', player:GetData('Source'), '/' .. k)
                                        end
                                    end
                                else
                                    TriggerClientEvent('chat:addSuggestion', player:GetData('Source'), '/' .. k, command.help, command.params)
                                end
                            else
                                TriggerClientEvent('chat:addSuggestion', player:GetData('Source'), '/' .. k, '')
                            end
                        end
                    end
                end
            end
        end
    }
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Chat', CHAT)
end)

AddEventHandler('chatMessage', function(source, n, message)
    local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
    
    if player ~= nil then
        local char = player:GetData('Character')
        if char ~= nil then
            local cData = char:GetData()

            if(starts_with(message, '/'))then
                local command_args = stringsplit(message, " ")

                command_args[1] = string.gsub(command_args[1], '/', "")

                local commandName = command_args[1]

                if commands[commandName] ~= nil then
                    if commands[commandName].job ~= nil then
                        for k, v in pairs(commands[commandName].job) do
                            if cData.Job.job == v.name then
                                if v.gradelevel <= cData.job.grade.level and cData.JobDuty then
                                    local command = commands[commandName]
                                end
                            end
                        end
                    else
                        local command = commands[commandName]
                    end

                    if(command)then
                        local Source = source
                        CancelEvent()
                        table.remove(command_args, 1)
                        if (not (command.arguments <= (#command_args - 1)) and command.arguments > -1) then
                            Chat.Send.Server:Single(source, 'Invalid Number Of Arguments')
                        end
                    else
                        Chat.Send.Server:Single(source, 'Invalid Command Handler')
                    end
                else
                    Chat.Send.Server:Single(source, 'Invalid Command')
                end
            end
        end
    end
    CancelEvent()
end)

function CHAT.ClearAll(self)
    TriggerClientEvent('chat:clearChat', -1)
end

CHAT.Send = {
    OOC = function(self, source, message)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
    
        if player ~= nil then
            local char = player:GetData('Character'):GetData()
            if char ~= nil then
                fal = char.First .. " " .. char.Last
                TriggerClientEvent('chat:addMessage', -1, {
                    template = '<div class="chat-message"><div class="chat-message-header">[OOC] {0}:</div><div class="chat-message-body">{1}</div></div>',
                    args = { fal, message }
                })
            end
        end
    end,
    Server = {
        All = function(self, message)
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message server"><div class="chat-message-header">[SERVER]</div><div class="chat-message-body">{0}</div></div>',
                args = { message }
            })
        end,
        Single = function(self, source, message)
            TriggerClientEvent('chat:addMessage', source, {
                template = '<div class="chat-message server"><div class="chat-message-header">[SERVER]</div><div class="chat-message-body">{0}</div></div>',
                args = { message }
            })
        end,
    },
    System = {
        All = function(self, message)
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message system"><div class="chat-message-header">[SYSTEM]</div><div class="chat-message-body">{0}</div></div>',
                args = { message }
            })
        end,
        Single = function(self, source, message)
            TriggerClientEvent('chat:addMessage', source, {
                template = '<div class="chat-message system"><div class="chat-message-header">[SYSTEM]</div><div class="chat-message-body">{0}</div></div>',
                args = { message }
            })
        end,
        Help = function(self, source, message)
            TriggerClientEvent('chat:addMessage', source, {
                template = '<div class="chat-message help"><div class="chat-message-header">[INFO]</div><div class="chat-message-body">{0}</div></div>',
                args = { message }
            })
        end
    }
}

AddEventHandler('Chat:Server:Server', function(source, message)
    TriggerClientEvent('chat:addMessage', source, {
        template = '<div class="chat-message server"><div class="chat-message-header">[SERVER]</div><div class="chat-message-body">{0}</div></div>',
        args = { message }
    })
    CancelEvent()
end)

RegisterServerEvent('Chat:ServerSendMeToNear')
AddEventHandler('Chat:ServerSendMeToNear', function(source, message)
    local src = source
    TriggerClientEvent('Chat:Client:ReceiveMe', -1, src, message)
end)

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end