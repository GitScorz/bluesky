local callChannel = 0

---function createCallThread
---creates a call thread to listen for key presses
local function createCallThread()
	CreateThread(function()
		local changed = false
		while callChannel ~= 0 do
			-- check if they're pressing voice keybinds
			if MumbleIsPlayerTalking(PlayerId()) and not changed then
				changed = true
				playerTargets(radioPressed and radioData or {}, callData)
				TriggerServerEvent('pma-voice:setTalkingOnCall', true)
			elseif changed and MumbleIsPlayerTalking(PlayerId()) ~= 1 then
				changed = false
				MumbleClearVoiceTargetPlayers(voiceTarget)
				TriggerServerEvent('pma-voice:setTalkingOnCall', false)
			end
			Wait(0)
		end
	end)
end

RegisterNetEvent('pma-voice:syncCallData', function(callTable, channel)
	callData = callTable
	for tgt, enabled in pairs(callTable) do
		if tgt ~= playerServerId then
			toggleVoice(tgt, enabled, 'call')
		end
	end
end)

RegisterNetEvent('pma-voice:setTalkingOnCall', function(tgt, enabled)
	if tgt ~= playerServerId then
		callData[tgt] = enabled
		toggleVoice(tgt, enabled, 'call')
	end
end)

RegisterNetEvent('pma-voice:addPlayerToCall', function(plySource)
	callData[plySource] = false
end)

RegisterNetEvent('pma-voice:removePlayerFromCall', function(plySource)
	if plySource == playerServerId then
		for tgt, _ in pairs(callData) do
			if tgt ~= playerServerId then
				toggleVoice(tgt, false, 'call')
			end
		end
		callData = {}
		MumbleClearVoiceTargetPlayers(voiceTarget)
		playerTargets(radioPressed and radioData or {}, callData)
	else
		callData[plySource] = nil
		toggleVoice(plySource, false, 'call')
		if MumbleIsPlayerTalking(PlayerId()) then
			MumbleClearVoiceTargetPlayers(voiceTarget)
			playerTargets(radioPressed and radioData or {}, callData)
		end
	end
end)

function setCallChannel(channel)
	if GetConvarInt('voice_enableCalls', 1) ~= 1 then return end
	TriggerServerEvent('pma-voice:setPlayerCall', channel)
	callChannel = channel
	sendUIMessage({
		callInfo = channel
	})
	createCallThread()
end

VOIP.Call = {
	--- @param _call number The channel to set the player to, or 0 to remove them.
	SetCallChannel = function(self, _call)
		setCallChannel(_call)
	end,

	Remove = function(self)
		setCallChannel(0)
	end,

	--- @param volume number The volume to set the call to.
	SetVolume = function(self, volume)
		setVolume(volume, 'call')
	end,

	GetCallVolume = function(self)
		return volumes['call']
	end,
}

RegisterNetEvent('pma-voice:clSetPlayerCall', function(_callChannel)
	if GetConvarInt('voice_enableCalls', 1) ~= 1 then return end
	callChannel = _callChannel
	createCallThread()
end)

AddEventHandler('Characters:Client:Spawn', function()
	VOIP.Call:SetCallChannel(0)
end)

AddEventHandler('Characters:Client:Logout', function()
	VOIP.Call:SetCallChannel(0)
end)
