--[[
    All Credit To Frazzle for the basics of this script - but fuck frazzle hes mia
    Source: https://github.com/FrazzIe/mumble-voip
]]--

local _init = false
local _serverId = GetPlayerServerId(PlayerId())
local _muted = {}

local _disablingKeys = false

AddEventHandler('Voip:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
	Logger = exports['bs_base']:FetchComponent('Logger')
	Voip = exports['bs_base']:FetchComponent('Voip')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Voip', {
        'Callbacks',
        'Logger',
        'Voip',
    }, function(error)  
        if #error > 0 then return; end
		RetrieveComponents()
		if not _init then
            if Config.Use3DAudio then
                NetworkSetTalkerProximity(Config.Modes[2][1] + 0.0)
            else
                NetworkSetTalkerProximity(0.0)
            end
        
            SendNUIMessage({ speakerOption = Config.Speaker.Call })

            Callbacks:ServerCallback('Voip:Init', {}, function()
                _init = true
            end)
        end
    end)
end)


function VOIP.SetMumbleProperty(self, key, value)
    if Config[key] ~= nil and Config[key] ~= "controls" and Config[key] ~= "radioChannelNames" then
        Config[key] = value

        if key == "callSpeakerEnabled" then
            SendNUIMessage({ speakerOption = Config.Speaker.Call })
        end
    end
end

function VOIP.SetRadioChannelName(self, channel, name)
    local channel = tonumber(channel)

    if channel ~= nil and name ~= nil and name ~= "" then
        if not Config.RadioChannels[channel] then
            Config.RadioChannels[channel] = tostring(name)
        end
    end
end

function VOIP.SetCallChannelName(self, channel, name)
    local channel = tonumber(channel)

    if channel ~= nil and name ~= nil and name ~= "" then
        if not Config.PhoneChannels[channel] then
            Config.PhoneChannels[channel] = tostring(name)
        end
    end
end

function VOIP.SetVoiceData(self, key, value)
    Callbacks:ServerCallback('Voip:SetData', {
        key = key,
        value = value
    })
end

VOIP.Add = {
    Call = function(self, channel)
        local channel = tonumber(channel)
    
        if channel ~= nil then
            Voip:SetVoiceData('call', channel)
        end
    end,
    Radio = function(self, channel)
        local channel = tonumber(channel)
    
        if channel ~= nil then
            Voip:SetVoiceData('radio', channel)
        end
    end,
}

VOIP.Remove = {
    Call = function(self)
        Voip.Add:Call(0)
    end,
    Radio = function(self)
        Voip.Add:Radio(0)
    end,
}

VOIP.Input = {
	Enable = function(self)
		if _disablingKeys then return end
        SetNuiFocusKeepInput(true)
		_disablingKeys = true
		Citizen.CreateThread(function()
			while _disablingKeys do
				DisableAllControlActions(0)
				DisableControlAction(0, 2, true)  -- Disable Camera
				DisableControlAction(0, 1, true)  -- Disable Camera
				EnableControlAction(0, 249, true) -- Push to Talk
				EnableControlAction(0, Config.Controls.Proximity.Key, true) -- Change Voice Range
				EnableControlAction(0, Config.Controls.Radio.Key, true) -- Push to Talk Radio
				Citizen.Wait(1)
			end
		end)
    end,
	Disable = function(self)
        SetNuiFocusKeepInput(false)
        _disablingKeys = false
    end,
}

AddEventHandler('Voip:Client:InputEnable', function()
    Voip.Input:Enable()
end)

AddEventHandler('Voip:Client:InputDisable', function()
    Voip.Input:Disable()
end)

AddEventHandler('Characters:Client:Spawn', function()
	NetworkSetTalkerProximity(Config.Modes[1][1])
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
	Voip.Input:Disable()
	Voip.Remove:Call()
	Voip.Remove:Radio()
	NetworkSetTalkerProximity(0.0)
end)

function PlayMicClick(channel, value)
	print(channel, tostring(value))
	if channel <= Config.MicClicks.MaxChannel then
        if (value and Config.MicClicks.On) or (not value and Config.MicClicks.Off) then
            SendNUIMessage({ sound = (value and 'audio_on' or 'audio_off'), volume = Config.MicClicks.Volume })
        end
	end	
end

RegisterNetEvent('Voip:Client:Sync')
AddEventHandler('Voip:Client:Sync', function(voice, radio, call)
	_voice = voice
	_radio = radio
	_call = call
end)

-- Events
RegisterNetEvent('Voip:Client:SetData')
AddEventHandler('Voip:Client:SetData', function(player, key, value)
    if not _voice[player] then
        _voice[player] = {
            mode = 2,
            radio = 0,
            radioActive = false,
            call = 0,
            callSpeaker = false,
        }
	end

	local radioChannel = _voice[player]['radio']
    local callChannel = _voice[player]['call']
	local radioActive = _voice[player]['radioActive']

    if key == 'radio' and radioChannel ~= value then -- Check if channel has changed
        if radioChannel > 0 then -- Check if player was in a radio channel
            if _radio[radioChannel] then  -- Remove player from radio channel
                if _radio[radioChannel][player] then
                    Logger:Trace('Voip', ('Player %s Was Removed From Radio Channel %s'):format(player, radioChannel))
                    _radio[radioChannel][player] = nil
                end
            end
        end

        if value > 0 then
            if not _radio[value] then -- Create channel if it does not exist
                Logger:Trace('Voip', ('Player %s Is Creating Channel %s'):format(player, value))
                _radio[value] = {}
            end
            
            Logger:Trace('Voip', ('Player %s Was Added To Channel %s'):format(player, value))
            _radio[value][player] = true -- Add player to channel
        end
    elseif key == 'call' and callChannel ~= value then
        if callChannel > 0 then -- Check if player was in a call channel
            if _call[callChannel] then  -- Remove player from call channel
                if _call[callChannel][player] then
                    Logger:Trace('Voip', ('Player %s Was Removed From Call %s'):format(player, callChannel))
                    _call[callChannel][player] = nil
                end
            end
        end

        if value > 0 then
            if not _call[value] then -- Create call if it does not exist
                Logger:Trace('Voip', ('Player %s Is Creating Call %s'):format(player, value))
                _call[value] = {}
            end
            
            Logger:Trace('Voip', ('Player %s Was Added To Call %s'):format(player, value))
            _call[value][player] = true -- Add player to call
        end
    elseif key == 'radioActive' and radioActive ~= value then
        Logger:Trace('Voip', ('Player %s Talking State Changed From %s To %s'):format(player, tostring(radioActive):upper(), tostring(value):upper()))
        if radioChannel > 0 then
			local playerData = _voice[_serverId]

			if playerData.radio ~= nil then
				if playerData.radio == radioChannel then -- Check if player is in the same radio channel as you
					PlayMicClick(radioChannel, value)
				end
			end
        end
    end

	_voice[player][key] = value

    Logger:Trace('Voip', ('Player %s Changed %s To %s'):format(player, key, tostring(value)))
end)

RegisterNetEvent('Voip:Client:RemoveData')
AddEventHandler('Voip:Client:RemoveData', function(player)
    if _voice[player] then
		local radioChannel = _voice[player]['radio'] or 0
		local callChannel = _voice[player]['call'] or 0

        if radioChannel > 0 then -- Check if player was in a radio channel
            if _radio[radioChannel] then  -- Remove player from radio channel
                if _radio[radioChannel][player] then
                    Logger:Trace('Voip', ('Player %s Was Removed From Radio Channel %s'):format(player, radioChannel))
                    _radio[radioChannel][player] = nil
                end
            end
        end

        if callChannel > 0 then -- Check if player was in a call channel
            if _call[callChannel] then  -- Remove player from call channel
                if _call[callChannel][player] then
                    Logger:Trace('Voip', ('Player %s Was Removed From Call %s'):format(player, callChannel))
                    _call[callChannel][player] = nil
                end
            end
        end

        _voice[player] = nil
    end
end)

AddEventHandler('onClientMapStart', function()
	NetworkSetTalkerProximity(0.0)
end)

AddEventHandler('onClientResourceStart', function(resName)
	if GetCurrentResourceName() ~= resName then
		return
	end

	if Config.Use3DAudio then
		NetworkSetTalkerProximity(Config.Modes[2][1] + 0.0)
	else
		NetworkSetTalkerProximity(0.0)
	end

	SendNUIMessage({ speakerOption = Config.Speaker.Call })
end)

-- Simulate PTT when radio is active
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerData = _voice[_serverId]
		local playerMode = 2
		local playerRadio = 0
		local playerRadioActive = false
		local playerCall = 0
		local playerCallSpeaker = false

		if playerData ~= nil then
			playerMode = playerData.mode or 2
			playerRadio = playerData.radio or 0
			playerRadioActive = playerData.radioActive or false
			playerCall = playerData.call or 0
			playerCallSpeaker = playerData.callSpeaker or false
		end

		if playerRadioActive then -- Force PTT enabled
			SetControlNormal(0, 249, 1.0)
			SetControlNormal(1, 249, 1.0)
			SetControlNormal(2, 249, 1.0)
		end

		if IsControlJustPressed(0, Config.Controls.Proximity.Key) then
			if Config.Controls.Speaker.Key == Config.Controls.Proximity.Key and not ((Config.Controls.Speaker.Secondary == nil) and true or IsControlPressed(0, Config.Controls.Speaker.Secondary)) then
				local voiceMode = playerMode
			
				local newMode = voiceMode + 1
			
				if newMode > #Config.Modes then
					voiceMode = 1
				else
					voiceMode = newMode
				end
				
				if Config.Use3DAudio then
					NetworkSetTalkerProximity(Config.Modes[voiceMode][1])
				end

				Voip:SetVoiceData('mode', voiceMode)
				playerData.mode = voiceMode
			end
		end

		if Config.Radio then
			if not Config.Controls.Radio.Pressed then
				if IsControlJustPressed(0, Config.Controls.Radio.Key) then
					if playerRadio > 0 then
						Voip:SetVoiceData('radioActive', true)
						playerData.radioActive = true
						PlayMicClick(playerRadio, true)
						Config.Controls.Radio.Pressed = true

						Citizen.CreateThread(function()
							while IsControlPressed(0, Config.Controls.Radio.Key) do
								Citizen.Wait(0)
							end

							Voip:SetVoiceData('radioActive', false)
							PlayMicClick(playerRadio, false)
							playerData.radioActive = false
							Config.Controls.Radio.Pressed = false
						end)
					end
				end
			end
		else
			if playerRadioActive then
				Voip:SetVoiceData('radioActive', false)
				playerData.radioActive = false
			end
		end

		if Config.Speaker.Radio then
			if ((Config.Controls.Speaker.Secondary == nil) and true or IsControlPressed(0, Config.Controls.Speaker.Secondary)) then
				if IsControlJustPressed(0, Config.Controls.Speaker.Key) then
					if playerCall > 0 then
						Voip:SetVoiceData('callSpeaker', not playerCallSpeaker)
						playerData.callSpeaker = not playerCallSpeaker
					end
				end
			end
		end
	end
end)

-- UI
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)
		local playerId = PlayerId()
		local playerData = _voice[_serverId]
		local playerTalking = NetworkIsPlayerTalking(playerId)
		local playerMode = 2
		local playerRadio = 0
		local playerRadioActive = false
		local playerCall = 0
		local playerCallSpeaker = false

		if playerData ~= nil then
			playerMode = playerData.mode or 2
			playerRadio = playerData.radio or 0
			playerRadioActive = playerData.radioActive or false
			playerCall = playerData.call or 0
			playerCallSpeaker = playerData.callSpeaker or false
		end

		-- Update UI
		SendNUIMessage({
			talking = playerTalking,
			mode = Config.Modes[playerMode][2],
			radio = Config.RadioChannels[playerRadio] ~= nil and Config.RadioChannels[playerRadio] or playerRadio,
			radioActive = playerRadioActive,
			call = Config.PhoneChannels[playerCall] ~= nil and Config.PhoneChannels[playerCall] or playerCall,
			speaker = playerCallSpeaker,
		})
	end
end)

-- Main thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)

		local playerId = PlayerId()
		local playerPed = PlayerPedId()
		local playerPos = GetPedBoneCoords(playerPed, headBone)
		local playerList = GetActivePlayers()
		local playerData = _voice[_serverId]
		local playerMode = 2
		local playerRadio = 0
		local playerCall = 0

		if playerData ~= nil then
			playerMode = playerData.mode or 2
			playerRadio = playerData.radio or 0
			playerCall = playerData.call or 0
		end

		local voiceList = {}
		local muteList = {}
		local callList = {}
		local radioList = {}

		-- Check if a player is close to the source voice mode distance, if close send voice
		for i = 1, #playerList do -- Proximity based voice (probably won't work for infinity?)
			local remotePlayerId = playerList[i]

			if playerId ~= remotePlayerId then
				local remotePlayerServerId = GetPlayerServerId(remotePlayerId)
				local remotePlayerPed = GetPlayerPed(remotePlayerId)
				local remotePlayerPos = GetPedBoneCoords(remotePlayerPed, headBone)
				local remotePlayerData = _voice[remotePlayerServerId]

				local distance = #(playerPos - remotePlayerPos)
				local mode = 2
				local radio = 0
				local radioActive = false
				local call = 0
				local callSpeaker = false

				if remotePlayerData ~= nil then
					mode = remotePlayerData.mode or 2
					radio = remotePlayerData.radio or 0
					radioActive = remotePlayerData.radioActive or false
					call = remotePlayerData.call or 0
					callSpeaker = remotePlayerData.callSpeaker or false
				end

				local inRange = false

				if Config.Use3DAudio then
					inRange = distance < Config.Modes[playerMode][1]
				else
					inRange = distance < Config.Modes[mode][1]
				end

				-- Check if player is in range
				if inRange then
					local idx = #voiceList + 1

					voiceList[idx] = {
						id = remotePlayerServerId,
						player = remotePlayerId,
					}

					if not Config.Use3DAudio then
						local volume = 1.0 - (distance / Config.Modes[mode][1])^0.5

						if volume < 0 then
							volume = 0.0
						end

						voiceList[idx].volume = volume
					end

					if distance < Config.Speaker.Range then
						local volume = 1.0 - (distance / Config.Speaker.Range)^0.5

						if Config.Speaker.Call then
							if call > 0 then -- Collect all players in the phone call
								if callSpeaker then
									local callParticipants = _call[call]
									if callParticipants ~= nil then
										for id, _ in pairs(callParticipants) do
											if id ~= remotePlayerServerId then
												callList[id] = volume
											end
										end
									end
								end
							end
						end
						
						if Config.Speaker.Radio then
							if radio > 0 then -- Collect all players in the radio channel
								local radioParticipants = _radio[radio]
								if radioParticipants then
									for id, _ in pairs(radioParticipants) do
										if id ~= remotePlayerServerId then
											radioList[id] = volume
										end
									end
								end
							end
						end
					end
				else
					muteList[#muteList + 1] = {
						id = remotePlayerServerId,
						player = remotePlayerId,
						volume = Config.Use3DAudio and -1.0 or 0.0,
						radio = radio,
						radioActive = radioActive,
						distance = distance,
						call = call,
					}					
				end
			end
		end
		
		if Config.Use3DAudio then
			MumbleClearVoiceTarget(0)

			for j = 1, #voiceList do
				if _muted[voiceList[j].id] ~= nil then -- Only re-enable 3d audio if player was muted
					_muted[voiceList[j].id] = nil
					MumbleSetVolumeOverride(voiceList[j].player, -1.0) -- Re-enable 3d audio
				end

				MumbleAddVoiceTargetPlayer(2, voiceList[j].player) -- Broadcast voice to player if they are in my voice range
			end

			MumbleSetVoiceTarget(0)
		else
			for j = 1, #voiceList do
				if _muted[voiceList[j].id] ~= nil then
					_muted[voiceList[j].id] = nil
				end

				MumbleSetVolumeOverride(voiceList[j].player, voiceList[j].volume)
			end
		end
		
		for j = 1, #muteList do
			if Config.Speaker.Call then
				if callList[muteList[j].id] ~= nil then
					if callList[muteList[j].id] > muteList[j].volume then
						muteList[j].volume = callList[muteList[j].id]
					end
				end
			end

			if Config.Speaker.Radio then
				if radioList[muteList[j].id] ~= nil then
					if muteList[j].radioActive then
						if radioList[muteList[j].id] > muteList[j].volume then
							muteList[j].volume = radioList[muteList[j].id]
						end
					end
				end
			end

			if muteList[j].radio > 0 and muteList[j].radio == playerRadio and muteList[j].radioActive then
				muteList[j].volume = 1.0
			end

			if muteList[j].call > 0 and muteList[j].call == playerCall then
				muteList[j].volume = 1.2
			end

			if _muted[muteList[j].id] ~= muteList[j].volume then -- Only update volume if its changed
				_muted[muteList[j].id] = muteList[j].volume
				MumbleSetVolumeOverride(muteList[j].player, muteList[j].volume) -- Set player volume
			end
		end
	end
end)