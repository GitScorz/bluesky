TokoVoipConfig = {}

AddEventHandler('Voip:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports['bs_base']:FetchComponent('Callbacks')
	Notification = exports['bs_base']:FetchComponent('Notification')
	Action = exports['bs_base']:FetchComponent('Action')
	Progress = exports['bs_base']:FetchComponent('Progress')
	VoipStuff = exports['bs_base']:FetchComponent('Voip')
	Utils = exports['bs_base']:FetchComponent('Utils')
	Sounds = exports['bs_base']:FetchComponent('Sounds')
	Convar = exports['bs_base']:FetchComponent('Convar')
	Logger = exports['bs_base']:FetchComponent('Logger')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Voip', {
			'Callbacks',
			'Notification',
			'Action',
			'Progress',
			'Voip',
			'Sounds',
			'Utils',
			'Convar',
			'Logger',
    }, function(error)  
        if #error > 0 then return; end
		RetrieveComponents()
		
		TokoVoipConfig = {
			refreshRate = 500, -- Rate at which the data is sent to the TSPlugin
			networkRefreshRate = 2500, -- Rate at which the network data is updated/reset on the local ped
			playerListRefreshRate = 5500, -- Rate at which the playerList is updated
			minVersion = "1.2.4", -- Version of the TS plugin required to play on the server
		
			distance = {
				12, -- Normal speech distance in gta distance units
				4, -- Whisper speech distance in gta distance units
				34, -- Shout speech distance in gta distance units
			},
			headingType = 1, -- headingType 0 uses GetGameplayCamRot, basing heading on the camera's heading, to match how other GTA sounds work. headingType 1 uses GetEntityHeading which is based on the character's direction
			radioKey = Keys["CAPS"], -- Keybind used to talk on the radio
			keySwitchChannels = Keys["Z"], -- Keybind used to switch the radio channels
			keySwitchChannelsSecondary = Keys["LEFTSHIFT"], -- If set, both the keySwitchChannels and keySwitchChannelsSecondary keybinds must be pressed to switch the radio channels
			keyProximity = Keys["Z"], -- Keybind used to switch the proximity mode
			minVolume = 20,
			radioClickMaxChannel = 999, -- Set the max amount of radio channels that will have local radio clicks enabled
			radioAnim = true, -- Enable or disable the radio animation
			radioEnabled = true, -- Enable or disable using the radio
			channelRestrictions = {
				[1] = {"police", "ems", "corrections"}, -- Dispatch
				[2] = {"police"}, -- Police Only
				[3] = {"ems", "doctor"}, -- EMS / Doctors Only
				[4] = {"fire"}, -- Fire
				[5] = {"police", "corrections"}, -- Police and Corrections
				[6] = {"judges"}, -- Judges Channel
			},
			
			plugin_data = {
				-- TeamSpeak channel name used by the voip
				-- If the TSChannelWait is enabled, players who are currently in TSChannelWait will be automatically moved
				-- to the TSChannel once everything is running
				TSPassword = "bluesky123", -- TeamSpeak channel password (can be empty)
		
				-- Optional: TeamSpeak waiting channel name, players wait in this channel and will be moved to the TSChannel automatically
				-- If the TSChannel is public and people can join directly, you can leave this empty and not use the auto-move
				TSChannelWait = "FiveM Queue",
				TSChannelSupport = "Support Channel",
				TSChannel = Convar.VOIP_CHANNEL.value,
		
				-- Blocking screen informations
				TSServer = "ts.blueskyrp.com", -- TeamSpeak server address to be displayed on blocking screen
				TSDownload = "https://www.blueskyrp.com", -- Download link displayed on blocking screen
				TSChannelWhitelist = { -- Black screen will not be displayed when users are in those TS channels
					"creaKtive",
					"Alzar",
					"Dr Nick's Clinic",
					"Panda's Hotel v8.9",
					"DiscworldZA",
					"Development Main Channel",
					"Staff Chat #1",
				},
				
				-- The following is purely TS client settings, to match tastes
				local_click_on = true, -- Is local click on sound active
				local_click_off = true, -- Is local click off sound active
				remote_click_on = true, -- Is remote click on sound active
				remote_click_off = true, -- Is remote click off sound active
				enableStereoAudio = true, -- If set to true, positional audio will be stereo (you can hear people more on the left or the right around you)
				clickVolume = 15 + 0.0,
		
				localName = "", -- If set, this name will be used as the user's teamspeak display name
				localNamePrefix = "[" .. GetPlayerServerId(PlayerId()) .. "] ", -- If set, this prefix will be added to the user's teamspeak display name
			}
		}

		Citizen.CreateThread(function()
			TokoVoipConfig.plugin_data.localName = escape(GetPlayerName(PlayerId())); -- Set the local name
			if Convar.VOIP_CHANNEL.value ~= "NOT SET" then
				TriggerEvent("initializeVoip"); -- Trigger this event whenever you want to start the voip
			else
				Logger:Error('Voip', 'Teamspeak Channel has not been set in the ServerCFG files')
			end
		end);
    end)
end)

-- Update config properties from another script
function SetTokoProperty(key, value)
	if TokoVoipConfig[key] ~= nil and TokoVoipConfig[key] ~= "plugin_data" then
		TokoVoipConfig[key] = value

		if voip then
			if voip.config then
				if voip.config[key] ~= nil then
					voip.config[key] = value
				end
			end
		end
	end
end