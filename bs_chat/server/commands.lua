

function CHAT.RegisterCommand(this, command, callback, suggestion, arguments, job)
    if job ~= nil then
        if type(job) == 'table' and #job > 0 then
            for k,v in pairs(job) do
                if v.name == nil then return end 
                if v.gradelevel == nil then job.gradelevel = 1 end
            end
        end
    end

	commands[command] = {
        cb = callback,
        args = (arguments or -1),
        job = job
    }

	if suggestion ~= nil then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end

		commandSuggestions[command] = suggestion
	end

    RegisterCommand(command, function(source, args, rawCommand)
        local pData = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        if pData ~= nil then
            -- TODO : Implement character specific data for commands (IE Jobs)
            local cData = pData:GetData('Character'):GetData()
            if commands[command].job ~= nil then
                for k, v in pairs(commands[command].job) do
                    if cData.Job ~= nil and cData.JobDuty ~= nil and v['name'] == cData.Job.job and cData.JobDuty then
                        if tonumber(v['gradelevel']) <= cData.Job.grade.level then
                            if ((#args <= commands[command].args and #args == commands[command].args) or commands[command].args == -1) then
                                callback(source, args, rawCommand)
                            else
                                Chat.Send.Server:Single(source, 'Invalid Number Of Arguments')
                            end
                        end
                    end
                end
            else
                if ((#args <= commands[command].args and #args == commands[command].args) or commands[command].args == -1) then
                    callback(source, args, rawCommand)
                else
                    Chat.Send.Server:Single(source, 'Invalid Number Of Arguments')
                end
            end
        end
    end, false)
end

function CHAT.RegisterAdminCommand(this, command, callback, suggestion, arguments)
	commands[command] = {
        cb = callback,
        args = (arguments or -1),
        admin = true
    }

	if suggestion then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end

		commandSuggestions[command] = suggestion
	end

    RegisterCommand(command, function(source, args, rawCommand)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        if player ~= nil then
            local pData = player:GetData()
            if player.Permissions:IsAdmin() then
                if((#args <= commands[command].args and #args == commands[command].args) or commands[command].args == -1)then
                    callback(source, args, rawCommand)
                else
                    Chat.Send.Server:Single(source, 'Invalid Number Of Arguments')
                end
            end
        end
    end, false)
end

