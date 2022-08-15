local radioChannel = 0
local radioNames = {}
local disableRadioAnim = false

--- event syncRadioData
--- syncs the current players on the radio to the client
---@param radioTable table the table of the current players on the radio
---@param localPlyRadioName string the local players name
function syncRadioData(radioTable, localPlyRadioName)
	radioData = radioTable
	Logger:Info('Voip', 'Syncing radio table.')

	for tgt, enabled in pairs(radioTable) do
		if tgt ~= playerServerId then
			toggleVoice(tgt, enabled, 'radio')
		end
	end

	-- sendUIMessage({
	-- 	radioChannel = radioChannel,
	-- 	radioEnabled = radioEnabled
	-- })
	if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
		radioNames[playerServerId] = localPlyRadioName
	end
end

RegisterNetEvent('pma-voice:syncRadioData', syncRadioData)

--- event setTalkingOnRadio
--- sets the players talking status, triggered when a player starts/stops talking.
---@param plySource number the players server id.
---@param enabled boolean whether the player is talking or not.
function setTalkingOnRadio(plySource, enabled)
	toggleVoice(plySource, enabled, 'radio')
	radioData[plySource] = enabled
	playMicClicks(enabled)
end

RegisterNetEvent('pma-voice:setTalkingOnRadio', setTalkingOnRadio)

--- event addPlayerToRadio
--- adds a player onto the radio.
---@param plySource number the players server id to add to the radio.
function addPlayerToRadio(plySource, plyRadioName)
	radioData[plySource] = false
	if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
		radioNames[plySource] = plyRadioName
	end

	if radioPressed then
		Logger:Info('Voip',
			('%s joined radio %s while we were talking, adding them to targets'):format(plySource, radioChannel))
		playerTargets(radioData, MumbleIsPlayerTalking(PlayerId()) and callData or {})
	else
		Logger:Info('Voip', ('%s joined radio %s'):format(plySource, radioChannel))
	end
end

RegisterNetEvent('pma-voice:addPlayerToRadio', addPlayerToRadio)

--- event removePlayerFromRadio
--- removes the player (or self) from the radio
---@param plySource number the players server id to remove from the radio.
function removePlayerFromRadio(plySource)
	if plySource == playerServerId then
		Logger:Info('Voip', ('Left radio %s, cleaning up.'):format(radioChannel))
		for tgt, _ in pairs(radioData) do
			if tgt ~= playerServerId then
				toggleVoice(tgt, false, 'radio')
			end
		end

		-- sendUIMessage({
		-- 	radioChannel = 0,
		-- 	radioEnabled = radioEnabled
		-- })
		radioNames = {}
		radioData = {}
		playerTargets(MumbleIsPlayerTalking(PlayerId()) and callData or {})
	else
		toggleVoice(plySource, false)
		if radioPressed then
			Logger:Info('Voip', ('%s left radio %s while we were talking, updating targets'):format(plySource, radioChannel))
			playerTargets(radioData, MumbleIsPlayerTalking(PlayerId()) and callData or {})
		else
			Logger:Info('Voip', ('%s has left radio %s'):format(plySource, radioChannel))
		end
		radioData[plySource] = nil
		if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
			radioNames[plySource] = nil
		end
	end
end

RegisterNetEvent('pma-voice:removePlayerFromRadio', removePlayerFromRadio)

--- function setRadioChannel
--- sets the local players current radio channel and updates the server
---@param channel number the channel to set the player to, or 0 to remove them.
function setRadioChannel(channel)
	type_check({ channel, "number" })
	TriggerServerEvent('pma-voice:setPlayerRadio', channel)
	radioChannel = channel
end

VOIP.Radio = {
	--- Sets the local players current radio channel and updates the server
	--- @param _channel number the channel to set the player to, or 0 to remove them.
	SetRadioChannel = function(self, _channel)
		setRadioChannel(_channel)
	end,

	--- Sets the local players current radio channel and updates the server
	Remove = function(self)
		setRadioChannel(0)
	end,

	--- Toggles whether the client should play radio anim or not, if the animation should be played or notvaliddance
	ToggleRadioAnim = function(self)
		disableRadioAnim = not disableRadioAnim
		TriggerEvent('pma-voice:toggleRadioAnim', disableRadioAnim)
	end,

	--- Returns whether the client is undercover or not
	GetRadioAnimState = function(self)
		return disableRadioAnim
	end,
}

--- check if the player is dead
--- seperating this so if people use different methods they can customize
--- it to their need as this will likely never be changed
--- but you can integrate the below state bag to your death resources.
--- LocalPlayer.state:set('isDead', true or false, false)
function isDead()
	if LocalPlayer.state.isDead then
		return true
	elseif IsPlayerDead(PlayerId()) then
		return true
	end
end

AddEventHandler('Characters:Client:Spawn', function()
	VOIP.Radio:SetRadioChannel(0)
end)

AddEventHandler('Characters:Client:Logout', function()
	VOIP.Radio:SetRadioChannel(0)
end)

RegisterCommand('+radiotalk', function()
	if isDead() then return end

	if not radioPressed and radioEnabled then
		if radioChannel > 0 then
			Logger:Info('Voip', "Start broadcasting, update targets and notify server.")

			playerTargets(radioData, MumbleIsPlayerTalking(PlayerId()) and callData or {})
			TriggerServerEvent('pma-voice:setTalkingOnRadio', true)
			radioPressed = true
			-- playMicClicks(true)

			if not disableRadioAnim then
				RequestAnimDict('random@arrests')
				while not HasAnimDictLoaded('random@arrests') do
					Wait(10)
				end

				TaskPlayAnim(PlayerPedId(), "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0)
			end

			CreateThread(function()
				TriggerEvent("pma-voice:radioActive", true)
				while radioPressed do
					Wait(0)
					SetControlNormal(0, 249, 1.0)
					SetControlNormal(1, 249, 1.0)
					SetControlNormal(2, 249, 1.0)
				end
			end)
		end
	end
end, false)

RegisterCommand('-radiotalk', function()
	if (radioChannel > 0 or radioEnabled) and radioPressed then
		radioPressed = false
		MumbleClearVoiceTargetPlayers(voiceTarget)
		playerTargets(MumbleIsPlayerTalking(PlayerId()) and callData or {})
		TriggerEvent("pma-voice:radioActive", false)
		-- playMicClicks(false)
		StopAnimTask(PlayerPedId(), "random@arrests", "generic_radio_enter", -4.0)
		TriggerServerEvent('pma-voice:setTalkingOnRadio', false)
	end
end, false)

function RegisterRadioKeybinds()
	Keybinds:Register("Voip", "Talk over the radio.", "+radiotalk", "-radiotalk", "keyboard", 'CAPITAL')
end

--- event syncRadio
--- syncs the players radio, only happens if the radio was set server side.
---@param _radioChannel number the radio channel to set the player to.
function syncRadio(_radioChannel)
	Logger:Info('Voip', ('radio set serverside update to radio %s'):format(_radioChannel))
	radioChannel = _radioChannel
end

RegisterNetEvent('pma-voice:clSetPlayerRadio', syncRadio)
