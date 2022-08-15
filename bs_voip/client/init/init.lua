local firstInitialize = true
VOIP = {}

function RetrieveComponents()
	Notification = exports['bs_base']:FetchComponent('Notification')
	Utils = exports['bs_base']:FetchComponent('Utils')
	Convar = exports['bs_base']:FetchComponent('Convar')
	Logger = exports['bs_base']:FetchComponent('Logger')
	UI = exports['bs_base']:FetchComponent('UI')
	Keybinds = exports['bs_base']:FetchComponent('Keybinds')
	UISounds = exports['bs_base']:FetchComponent('UISounds')
	RegisterKeybinds()
	RegisterRadioKeybinds()
end

AddEventHandler('Voip:Shared:DependencyUpdate', RetrieveComponents)

--- Initialize the plugin
local function InitializeVoip()
	print('Starting script initialization')

	-- Some people modify pma-voice and mess up the resource Kvp, which means that if someone
	-- joins another server that has pma-voice, it will error out, this will catch and fix the kvp.
	local success = pcall(function()
		local micClicksKvp = GetResourceKvpString('pma-voice_enableMicClicks')
		if not micClicksKvp then
			SetResourceKvp('pma-voice_enableMicClicks', tostring(true))
		else
			if micClicksKvp ~= 'true' and micClicksKvp ~= 'false' then
				error('Invalid Kvp, throwing error for automatic cleaning')
			end
			micClicks = micClicksKvp
		end
	end)

	if not success then
		Logger:Warn('Voip',
			'Failed to load resource Kvp, likely was inappropriately modified by another server, resetting the Kvp.')
		SetResourceKvp('pma-voice_enableMicClicks', tostring(true))
		micClicks = 'true'
	end

	-- Reinitialize channels if they're set.
	if LocalPlayer.state.radioChannel ~= 0 then
		setRadioChannel(LocalPlayer.state.radioChannel)
	end

	if LocalPlayer.state.callChannel ~= 0 then
		setCallChannel(LocalPlayer.state.callChannel)
	end

	print('Script initialization finished.')
end

AddEventHandler('Core:Shared:Ready', function()
	exports['bs_base']:RequestDependencies('Voip', {
		'Notification',
		'Utils',
		'Convar',
		'Logger',
		'UI',
		'Keybinds',
		'UISounds',
	}, function(error)
		if #error > 0 then return; end
		RetrieveComponents()
		InitializeVoip()
	end)
end)

AddEventHandler('onClientResourceStart', function(resource)
	if resource ~= GetCurrentResourceName() then return; end

	if firstInitialize then
		InitializeVoip()
		firstInitialize = false
	end
end)

AddEventHandler('Characters:Client:Spawn', function()
	VOIP.Radio:SetRadioChannel(0)
	VOIP.Call:SetCallChannel(0)
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
	VOIP.Radio:SetRadioChannel(0)
	VOIP.Call:SetCallChannel(0)
end)
