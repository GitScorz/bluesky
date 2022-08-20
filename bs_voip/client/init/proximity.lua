local isListenerEnabled = false
local plyCoords = GetEntityCoords(PlayerPedId())

function orig_addProximityCheck(ply)
	local tgtPed = GetPlayerPed(ply)
	local voiceModeData = Cfg.voiceModes[mode]
	local distance = GetConvar('voice_useNativeAudio', 'false') == 'true' and voiceModeData[1] * 3 or voiceModeData[1]

	return #(plyCoords - GetEntityCoords(tgtPed)) < distance
end

local addProximityCheck = orig_addProximityCheck

function addNearbyPlayers()
	-- update here so we don't have to update every call of addProximityCheck
	plyCoords = GetEntityCoords(PlayerPedId())

	MumbleClearVoiceTargetChannels(voiceTarget)
	local players = GetActivePlayers()
	for i = 1, #players do
		local ply = players[i]
		local serverId = GetPlayerServerId(ply)

		if addProximityCheck(ply) then
			if isTarget then goto skip_loop end

			-- Logger:Trace('Voip', ("Adding %s as a voice target"):format(serverId))
			MumbleAddVoiceTargetChannel(voiceTarget, serverId)
		end

		::skip_loop::
	end
end

function setSpectatorMode(enabled)
	Logger:Info('Voip', ("Setting spectator mode to %s"):format(enabled))
	isListenerEnabled = enabled
	local players = GetActivePlayers()
	if isListenerEnabled then
		for i = 1, #players do
			local ply = players[i]
			local serverId = GetPlayerServerId(ply)
			if serverId == playerServerId then goto skip_loop end
			-- Logger:Trace('Voip', ("Adding %s as a voice target"):format(serverId))
			MumbleAddVoiceChannelListen(serverId)
			::skip_loop::
		end
	else
		for i = 1, #players do
			local ply = players[i]
			local serverId = GetPlayerServerId(ply)
			if serverId == playerServerId then goto skip_loop end
			Logger:Trace('Voip', ("Removing %s as a voice target"):format(serverId))
			MumbleRemoveVoiceChannelListen(serverId)
			::skip_loop::
		end
	end
end

RegisterNetEvent('onPlayerJoining', function(serverId)
	if isListenerEnabled then
		MumbleAddVoiceChannelListen(serverId)
		Logger:Trace('Voip', ("Adding %s to listen table"):format(serverId))
	end
end)

RegisterNetEvent('onPlayerDropped', function(serverId)
	if isListenerEnabled then
		MumbleRemoveVoiceChannelListen(serverId)
		Logger:Trace('Voip', ("Removing %s from listen table"):format(serverId))
	end
end)

-- cache talking status so we only send a nui message when its not the same as what it was before
local lastTalkingStatus = false
local lastRadioStatus = false
local voiceState = "proximity"
CreateThread(function()
	while true do
		-- wait for mumble to reconnect
		while not MumbleIsConnected() do
			Wait(100)
		end
		-- Leave the check here as we don't want to do any of this logic
		local curTalkingStatus = MumbleIsPlayerTalking(PlayerId()) == 1
		if lastRadioStatus ~= radioPressed or lastTalkingStatus ~= curTalkingStatus then
			lastRadioStatus = radioPressed
			lastTalkingStatus = curTalkingStatus

			if curTalkingStatus then
				PlayFacialAnim(GetPlayerPed(-1), "mic_chatter", "mp_facial");
			else
				PlayFacialAnim(GetPlayerPed(-1), "mood_normal_1", "facials@gen_male@base");
			end

			UI.Voip:UpdateTalking({ usingRadio = lastRadioStatus, talking = curTalkingStatus })
		end

		if voiceState == "proximity" then
			addNearbyPlayers()
			local isSpectating = NetworkIsInSpectatorMode()
			if isSpectating and not isListenerEnabled then
				setSpectatorMode(true)
			elseif not isSpectating and isListenerEnabled then
				setSpectatorMode(false)
			end
		end

		Wait(GetConvarInt('voice_refreshRate', 100))
	end
end)

VOIP.Voice = {
	RadioEnabled = function()
		return radioEnabled
	end,

	--- Sets the specified voice property
	SetVoiceProperty = function(self, type, value)
		setVoiceProperty(type, value)
	end,

	--- Set voice state
	--- @param _voiceState "proximity" | "channel"
	--- @param channel? number
	SetVoiceState = function(self, _voiceState, channel)
		if _voiceState ~= "proximity" and _voiceState ~= "channel" then
			Logger:Error('Voip',
				("Didn't get a proper voice state, expected 'proximity' or 'channel', got '%s'"):format(_voiceState))
		end

		voiceState = _voiceState

		if voiceState == "channel" then
			type_check({ channel, "number" })
			-- 65535 is the highest a client id can go, so we add that to the base channel so we don't manage to get onto a players channel
			channel = channel + 65535
			MumbleSetVoiceChannel(channel)
			while MumbleGetVoiceChannelFromServerId(playerServerId) ~= channel do
				Wait(250)
			end
			MumbleAddVoiceTargetChannel(voiceTarget, channel)
		elseif voiceState == "proximity" then
			handleInitialState()
		end
	end,

	OverrideProximityCheck = function(self, fn)
		addProximityCheck = fn
	end,

	ResetProximityCheck = function(self)
		addProximityCheck = orig_addProximityCheck
	end,
}

AddEventHandler("onClientResourceStop", function(resource)
	if type(addProximityCheck) == "table" then
		local proximityCheckRef = addProximityCheck.__cfx_functionReference
		if proximityCheckRef then
			local isResource = string.match(proximityCheckRef, resource)
			if isResource then
				addProximityCheck = orig_addProximityCheck
				Logger:Warn('Voip',
					('Reset proximity check to default, the original resource [%s] which provided the function has restarted'):format(resource))
			end
		end
	end
end)
