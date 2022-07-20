local mutedPlayers = {}

local _character = nil
local currentJob = nil
local _isloggedIn = false

-- we can't use GetConvarInt because its not a integer, and theres no way to get a float... so use a hacky way it is!
local volumes = {
	-- people are setting this to 1 instead of 1.0 and expecting it to work.
	['radio'] = GetConvarInt('voice_defaultRadioVolume', 30) / 100,
	['call'] = GetConvarInt('voice_defaultCallVolume', 60) / 100,
}

radioEnabled, radioPressed, mode = true, false, GetConvarInt('voice_defaultVoiceMode', 2)
radioData = {}
callData = {}

--- function setVolume
--- Toggles the players volume
---@param volume number between 0 and 100
---@param volumeType string the volume type (currently radio & call) to set the volume of (opt)
function setVolume(volume, volumeType)
	type_check({volume, "number"})
	local volume = volume / 100
	
	if volumeType then
		local volumeTbl = volumes[volumeType]
		if volumeTbl then
			LocalPlayer.state:set(volumeType, volume, true)
			volumes[volumeType] = volume
		else
			error(('setVolume got a invalid volume type %s'):format(volumeType))
		end
	else
		-- _ is here to not mess with global 'type' function
		for _type, vol in pairs(volumes) do
			volumes[_type] = volume
			LocalPlayer.state:set(_type, volume, true)
		end
	end
end

exports('setRadioVolume', function(vol)
	setVolume(vol, 'radio')
end)
exports('getRadioVolume', function()
	return volumes['radio']
end)
exports("setCallVolume", function(vol)
	setVolume(vol, 'call')
end)
exports('getCallVolume', function()
	return volumes['call']
end)


-- default submix incase people want to fiddle with it.
-- freq_low = 389.0
-- freq_hi = 3248.0
-- fudge = 0.0
-- rm_mod_freq = 0.0
-- rm_mix = 0.16
-- o_freq_lo = 348.0
-- 0_freq_hi = 4900.0

if gameVersion == 'fivem' then
	radioEffectId = CreateAudioSubmix('Radio')
	SetAudioSubmixEffectRadioFx(radioEffectId, 0)
	SetAudioSubmixEffectParamInt(radioEffectId, 0, `default`, 1)
	AddAudioSubmixOutput(radioEffectId, 0)

	callEffectId = CreateAudioSubmix('Call')
	SetAudioSubmixEffectRadioFx(callEffectId, 1)
	SetAudioSubmixEffectParamInt(callEffectId, 1, `default`, 1)
	SetAudioSubmixEffectParamFloat(callEffectId, 1, `freq_low`, 300.0)
	SetAudioSubmixEffectParamFloat(callEffectId, 1, `freq_hi`, 6000.0)
	AddAudioSubmixOutput(callEffectId, 1)
end

--- export setEffectSubmix
--- Sets a user defined audio submix for radio and phonecall effects
---@param type string either "call" or "radio"
---@param effectId number submix id returned from CREATE_AUDIO_SUBMIX
exports("setEffectSubmix", function(type, effectId)
	if type == "call" then
		callEffectId = effectId
	elseif type == "radio" then
	  	radioEffectId = effectId
	end
end)

local submixFunctions = {
	['radio'] = function(plySource)
		MumbleSetSubmixForServerId(plySource, radioEffectId)
	end,
	['call'] = function(plySource)
		MumbleSetSubmixForServerId(plySource, callEffectId)
	end
}

-- used to prevent a race condition if they talk again afterwards, which would lead to their voice going to default.
local disableSubmixReset = {}
--- function toggleVoice
--- Toggles the players voice
---@param plySource number the players server id to override the volume for
---@param enabled boolean if the players voice is getting activated or deactivated
---@param moduleType string the volume & submix to use for the voice.
function toggleVoice(plySource, enabled, moduleType)
	if mutedPlayers[plySource] then return end
	Logger.Trace('Voip', ("Updating %s to talking: %s with submix %s"):format(plySource, enabled, moduleType))
	if enabled then
		MumbleSetVolumeOverrideByServerId(plySource, enabled and volumes[moduleType])
		if GetConvarInt('voice_enableSubmix', 1) == 1 and gameVersion == 'fivem' then
			if moduleType then
				disableSubmixReset[plySource] = true
				submixFunctions[moduleType](plySource)
			else
				MumbleSetSubmixForServerId(plySource, -1)
			end
		end
	else
		if GetConvarInt('voice_enableSubmix', 1) == 1 and gameVersion == 'fivem' then
			-- garbage collect it
			disableSubmixReset[plySource] = nil
			SetTimeout(250, function()
				if not disableSubmixReset[plySource] then
					MumbleSetSubmixForServerId(plySource, -1)
				end
			end)
		end
		MumbleSetVolumeOverrideByServerId(plySource, -1.0)
	end
end

--- function playerTargets
---Adds players voices to the local players listen channels allowing
---Them to communicate at long range, ignoring proximity range.
---@diagnostic disable-next-line: undefined-doc-param
---@param targets table expects multiple tables to be sent over
function playerTargets(...)
	local targets = {...}
	local addedPlayers = {
		[playerServerId] = true
	}

	for i = 1, #targets do
		for id, _ in pairs(targets[i]) do
			-- we don't want to log ourself, or listen to ourself
			if addedPlayers[id] and id ~= playerServerId then
				Logger.Trace('Voip', ("%s is already target don\'t re-add"):format(id))
				goto skip_loop
			end
			if not addedPlayers[id] then
				Logger.Trace('Voip', ("Adding %s as a voice target"):format(id))
				addedPlayers[id] = true
				MumbleAddVoiceTargetPlayerByServerId(voiceTarget, id)
			end
			::skip_loop::
		end
	end
end

--- function playMicClicks
---plays the mic click if the player has them enabled.
---@param clickType boolean whether to play the 'on' or 'off' click. 
function playMicClicks(clickType)
	if micClicks ~= 'true' then return Logger.Trace('Voip', "Not playing mic clicks because client has them disabled") end
	sendUIMessage({
		sound = (clickType and "audio_on" or "audio_off"),
		volume = (clickType and volumes["radio"] or 0.05)
	})
end

--- getter for mutedPlayers
exports('getMutedPlayers', function()
	return mutedPlayers
end)

--- toggles the targeted player muted
---@param source number the player to mute
function toggleMutePlayer(source)
	if mutedPlayers[source] then
		mutedPlayers[source] = nil
		MumbleSetVolumeOverrideByServerId(source, -1.0)
	else
		mutedPlayers[source] = true
		MumbleSetVolumeOverrideByServerId(source, 0.0)
	end
end
exports('toggleMutePlayer', toggleMutePlayer)

--- function setVoiceProperty
--- sets the specified voice property
---@param type string what voice property you want to change (only takes 'radioEnabled' and 'micClicks')
---@param value any the value to set the type to.
function setVoiceProperty(type, value)
	if type == "radioEnabled" then
		radioEnabled = value
		sendUIMessage({
			radioEnabled = value
		})
	elseif type == "micClicks" then
		local val = tostring(value)
		micClicks = val
		SetResourceKvp('pma-voice_enableMicClicks', val)
	end
end
exports('setVoiceProperty', setVoiceProperty)
-- compatibility
exports('SetMumbleProperty', setVoiceProperty)
exports('SetTokoProperty', setVoiceProperty)


-- cache their external servers so if it changes in runtime we can reconnect the client.
local externalAddress = ''
local externalPort = 0
CreateThread(function()
	while true do
		Wait(500)
		-- only change if what we have doesn't match the cache
		if GetConvar('voice_externalAddress', '') ~= externalAddress or GetConvarInt('voice_externalPort', 0) ~= externalPort then
			externalAddress = GetConvar('voice_externalAddress', '')
			externalPort = GetConvarInt('voice_externalPort', 0)
			MumbleSetServerAddress(GetConvar('voice_externalAddress', ''), GetConvarInt('voice_externalPort', 0))
		end
	end
end)

local VOIP = {
	Add = {
		addPlayerToRadio = function(self, channel)
			setRadioChannel(channel)
			-- TODO PERMISSION CHANNELS
		end,
		addPlayerToCall = function(self, channel)
			setCallChannel(channel)
		end,
	},
	Remove = {
		removePlayerFromRadio = function(self)
			setRadioChannel(0)
		end,
		removePlayerFromCall = function(self)
			setCallChannel(0)
		end,
	},
	Check = {
		isPlayerInRadio = function(self, channel)
			isPlayerInChannel(channel)
		end,
		isPlayerInCall = function(self, channel)
			isPlayerInChannel((1000 + channel))
		end,
	},
	RestrictedChannels = function(self)
		-- TODO
		return {}
	end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
	exports['bs_base']:RegisterComponent('Voip', VOIP)
end)

RegisterNetEvent('Characters:Client:SetData')
AddEventHandler('Characters:Client:SetData', function()
	local currentRadioChannel = LocalPlayer.state.radioChannel

	_character = exports['bs_base']:FetchComponent('Player').LocalPlayer:GetData('Character')
	Utils:Print(_character:GetData())
	
	if _character:GetData('Job').job ~= currentJob then
		if currentRadioChannel ~= 0 then
			VoipStuff.Remove:removePlayerFromRadio()
		end
	end

	if not _character:GetData('JobDuty') then
		if currentRadioChannel ~= 0 then
			VoipStuff.Remove:removePlayerFromRadio()
		end
	end

	currentJob = _character:GetData('Job').job
end)

RegisterNetEvent('Characters:Client:Spawn')
AddEventHandler('Characters:Client:Spawn', function()
	_character = exports['bs_base']:FetchComponent('Player').LocalPlayer:GetData('Character')
	currentJob = _character:GetData('Job').job
	_isloggedIn = true
end)