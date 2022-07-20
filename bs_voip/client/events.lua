function handleInitialState()
	local voiceModeData = Cfg.voiceModes[mode]
	MumbleSetTalkerProximity(voiceModeData[1] + 0.0)
	MumbleClearVoiceTarget(voiceTarget)
	MumbleSetVoiceTarget(voiceTarget)
	MumbleSetVoiceChannel(playerServerId)

	while MumbleGetVoiceChannelFromServerId(playerServerId) ~= playerServerId do
		Wait(250)
	end

	MumbleAddVoiceTargetChannel(voiceTarget, playerServerId)

	addNearbyPlayers()
end

AddEventHandler('mumbleConnected', function(address, isReconnecting)
	Logger.Info('Voip', ('Connected to mumble server with address of %s, is this a reconnect %s'):format(GetConvarInt('voice_hideEndpoints', 1) == 1 and 'HIDDEN' or address, isReconnecting))

	Logger.Info('Voip', 'Connect to mumble, setting targets.')
	-- don't try to set channel instantly, we're still getting data.
	local voiceModeData = Cfg.voiceModes[mode]
	LocalPlayer.state:set('proximity', {
		index = mode,
		distance =  voiceModeData[1],
		mode = voiceModeData[2],
	}, true)

	handleInitialState()

	Logger.Trace('Voip', 'Finished connection logic.')
end)

AddEventHandler('mumbleDisconnected', function(address)
	Logger.Info('Voip', ('Disconnected from mumble server with address of %s'):format(GetConvarInt('voice_hideEndpoints', 1) == 1 and 'HIDDEN' or address))
end)

-- TODO: Convert the last Cfg to a Convar, while still keeping it simple.
AddEventHandler('pma-voice:settingsCallback', function(cb)
	cb(Cfg)
end)