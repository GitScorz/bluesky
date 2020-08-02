local channels = TokoVoipConfig.channels;

function addPlayerToRadio(channelId, playerServerId)
	if (not channels[channelId]) and channelId < 1000 then
        channels[channelId] = {id = channelId, name = channelId.. " Mhz", subscribers = {}};
    elseif (not channels[channelId]) and channelId >= 1000 then
        channels[channelId] = {id = channelId, name = "Call with "..channelId, subscribers = {}};
	end
	if (not channels[channelId].id) then
		channels[channelId].id = channelId;
	end

	channels[channelId].subscribers[playerServerId] = playerServerId;
	print("Added [" .. playerServerId .. "] " .. (GetPlayerName(playerServerId) or "") .. " to channel " .. channelId);

	for _, subscriberServerId in pairs(channels[channelId].subscribers) do
		if (subscriberServerId ~= playerServerId) then
			TriggerClientEvent("TokoVoip:onPlayerJoinChannel", subscriberServerId, channelId, playerServerId);
		else
			-- Send whole channel data to new subscriber
			TriggerClientEvent("TokoVoip:onPlayerJoinChannel", subscriberServerId, channelId, playerServerId, channels[channelId]);
		end
	end
end
RegisterServerEvent("TokoVoip:addPlayerToRadio");
AddEventHandler("TokoVoip:addPlayerToRadio", addPlayerToRadio);

function removePlayerFromRadio(channelId, playerServerId)
	if (channels[channelId] and channels[channelId].subscribers[playerServerId]) then
		channels[channelId].subscribers[playerServerId] = nil;
		if (channelId > 999) then
			if (tablelength(channels[channelId].subscribers) == 0) then
				channels[channelId] = nil;
			end
		end
		print("Removed [" .. playerServerId .. "] " .. (GetPlayerName(playerServerId) or "") .. " from channel " .. channelId);

		-- Tell unsubscribed player he's left the channel as well
		TriggerClientEvent("TokoVoip:onPlayerLeaveChannel", playerServerId, channelId, playerServerId);

		-- Channel does not exist, no need to update anyone else
		if (not channels[channelId]) then return end

		for _, subscriberServerId in pairs(channels[channelId].subscribers) do
			TriggerClientEvent("TokoVoip:onPlayerLeaveChannel", subscriberServerId, channelId, playerServerId);
		end
	end
end
RegisterServerEvent("TokoVoip:removePlayerFromRadio");
AddEventHandler("TokoVoip:removePlayerFromRadio", removePlayerFromRadio);

function removePlayerFromAllRadio(playerServerId)
	for channelId, channel in pairs(channels) do
		if (channel.subscribers[playerServerId]) then
			removePlayerFromRadio(channelId, playerServerId);
		end
	end
end
RegisterServerEvent("TokoVoip:removePlayerFromAllRadio");
AddEventHandler("TokoVoip:removePlayerFromAllRadio", removePlayerFromAllRadio);

AddEventHandler("playerDropped", function()
	removePlayerFromAllRadio(source);
end);

function printChannels()
	for i, channel in pairs(channels) do
		RconPrint("Channel: " .. channel.name .. "\n");
		for j, player in pairs(channel.subscribers) do
			RconPrint("- [" .. player .. "] " .. GetPlayerName(player) .. "\n");
		end
	end
end

AddEventHandler('rconCommand', function(commandName, args)
	if commandName == 'voipChannels' then
		printChannels();
		CancelEvent();
	end
end)

AddEventHandler('Voip:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Middleware = exports['bs_base']:FetchComponent('Middleware')
    Database = exports['bs_base']:FetchComponent('Database')
    VoipStuff = exports['bs_base']:FetchComponent('Voip')
    Fetch = exports['bs_base']:FetchComponent('Fetch')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Voip', {
        'Callbacks',
        'Middleware',
        'Database',
        'Voip',
        'Fetch',
    }, function(error)  
        if #error > 0 then return end
        RetrieveComponents()
        registerCallbacks()
        RegisterMiddleware()
    end)
end)

function RegisterMiddleware()
    Middleware:Add('Characters:Logout', function(source)
        VoipStuff.Remove:removeFromAllChannels(source)
    end)
end

function registerCallbacks()
    Callbacks:RegisterServerCallback('Voip:Server:GetChannelName', function(source, data, cb)
        if data.channel then
            if TokoVoipConfig.channels[tonumber(data.channel)] then
                cb(TokoVoipConfig.channels[tonumber(data.channel)].name)
            else
                cb(nil)
            end
        else
            cb(nil)
        end
    end)
    Callbacks:RegisterServerCallback('Voip:Server:RequestSettings', function(source, data, cb)
        local char = Fetch:Source(source):GetData('Character')
        local ID = char:GetData('ID')
        Database.Game:find({
            collection = 'characters',
            query = {
                _id = ID
            }
        }, function(success, result)
            if not success then return end
            local defaultSettings = {
                ['radio:volume'] = -6,
                ['call:volume'] = -6
            }

            if result[1].voipSettings ~= nil then
                cb(result[1].voipSettings)
            else
                Database.Game:updateOne({
                    collection = 'characters',
                    query = {
                        _id = ID
                    },
                    update = {
                        ['$set'] = {
                            voipSettings = defaultSettings
                        }
                    }
                }, function(success2, result2)
                    if not success2 then return end
                    cb(defaultSettings)
                end)
            end
        
        end)
    end)
end

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Voip', VOIP)
end)

VOIP = {
    Add = {
        addPlayerToRadio = function(self, channel, playreid)
            if channel < 1000 then
                addPlayerToRadio(channel, playerid)
            else
                Notification:Error('Channel Number must be below 1000', 3500)
            end
        end,
        addPlayerToCall = function(self, channel, playerid)
            addPlayerToRadio((1000 + channel), playerid)
        end,
    },
    Remove = {
        removePlayerFromRadio = function(self, channel, playerid)
            removePlayerFromRadio(channel, playerid)
        end,
        removePlayerFromCall = function(self, channel, playerid)
            removePlayerFromRadio((1000 + channel), playerid)
        end,
        removeFromAllChannels = function(self, playerServerId)
            removePlayerFromAllRadio(playerServerId)
        end
    },
    Check = {
        isPlayerInRadio = function(self, channel)
            isPlayerInChannel(channel)
        end,
        isPlayerInCall = function(self, channel)
            isPlayerInChannel((1000 + channel))
        end,
    },
    PlayerData = {
        setPlayerData = function(self, playerServerId, key, data, shared)
            setPlayerData(playerServerId, key, data, shared)
        end,
        getPlayerData = function(self, playerServerId, key)
            getPlayerData(playerServerId, key)
        end,
    }
}