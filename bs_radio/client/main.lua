local radioOpen = false
local _isloggedIn = false
local currentJob
local currentChannel = {}
local latestChannel
local radioOn = false

AddEventHandler('Radio:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Notification = exports['bs_base']:FetchComponent('Notification')
    Action = exports['bs_base']:FetchComponent('Action')
    Progress = exports['bs_base']:FetchComponent('Progress')
	Voip = exports['bs_base']:FetchComponent('Voip')
    Utils = exports['bs_base']:FetchComponent('Utils')
    Radio = exports['bs_base']:FetchComponent('Radio')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Radio', {
        'Callbacks',
        'Notification',
        'Action',
        'Progress',
		'Voip',
        'Utils',
        'Radio'
    }, function(error)  
        if #error > 0 then return; end
        RetrieveComponents()
    end)
end)

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Radio', RADIO)
end)

RADIO = {

}

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    for k, v in pairs(currentChannel) do
        Voip.Remove:removePlayerFromRadio(v.channel)
    end 
    SendNUIMessage({
        type = 'SET_FREQ',
        data = { 
            frequency = '',
            frequencyName = ''
        }
    })
    currentChannel = {}
    latestChannel = nil
    radioOn = false
    _isloggedIn = false
end)

RegisterNetEvent('Characters:Client:Spawn')
AddEventHandler('Characters:Client:Spawn', function()
	_character = exports['bs_base']:FetchComponent('Player').LocalPlayer:GetData('Character')
	currentJob = _character:GetData('Job').job
    _isloggedIn = true
    
    Citizen.CreateThread(function()
        while _isloggedIn do
            if IsControlJustPressed(0, 243) and not radioOpen then
                radioOpen = true
                Citizen.Wait(200)
                SetNuiFocus(true, true)
                SendNUIMessage({
                    type = 'APP_SHOW'
                })
            end
            Citizen.Wait(0)
        end 
    end) 
end)

RegisterNetEvent('Characters:Client:SetData')
AddEventHandler('Characters:Client:SetData', function()
	_character = exports['bs_base']:FetchComponent('Player').LocalPlayer:GetData('Character')
    channels = Voip.Check:RestrictedChannels()

    if _character:GetData('Job').job ~= currentJob then
		if currentRadioChannel ~= -1 and channels[latestChannel] ~= nil then
            for k, v in pairs(currentChannel) do
                Voip.Remove:removePlayerFromRadio(v.channel)
            end            
            SendNUIMessage({
                type = 'SET_FREQ',
                data = { 
                    frequency = '',
                    frequencyName = ''
                }
            })
            currentChannel = {}
            latestChannel = nil
            radioOn = false
		end
	end
	
	if not _character:GetData('JobDuty') then
		if currentRadioChannel ~= -1 and channels[latestChannel] ~= nil then
			for k, v in pairs(currentChannel) do
                Voip.Remove:removePlayerFromRadio(v.channel)
            end            
            SendNUIMessage({
                type = 'SET_FREQ',
                data = { 
                    frequency = '',
                    frequencyName = ''
                }
            })
            currentChannel = {}
            latestChannel = nil
            radioOn = false
		end
	end

    currentJob = _character:GetData('Job').job
end)

RegisterNUICallback('Close', function(data, cb)
    if radioOpen then
        SetNuiFocus(false, false)
        SendNUIMessage({
            type = 'APP_HIDE'
        })
        Wait(500)
        radioOpen = false
    end
end)

RegisterNUICallback('power', function(data, cb)
    if radioOn then
        SendNUIMessage({
            type = 'SET_FREQ',
            data = { 
                frequency = '',
                frequencyName = ''
            }
        })
        for k, v in pairs(currentChannel) do
            Voip.Remove:removePlayerFromRadio(v.channel)
        end
        currentChannel = {}

    else
        if latestChannel ~= nil then
            channelName = Voip.Check:ChannelName(latestChannel)
            SendNUIMessage({
                type = 'SET_FREQ',
                data = { 
                    frequency = latestChannel,
                    frequencyName = (channelName ~= nil and channelName or latestChannel..' Mhz')
                }
            })
            Voip.Add:addPlayerToRadio(latestChannel)
            table.insert(currentChannel, { channel = latestChannel })
        end
    end
    radioOn = not radioOn
end)

RegisterNUICallback('setChannel', function(data, cb)
    if data.freq then
        Callbacks:ServerCallback('Commands:ValidateAdmin', {}, function(isAdmin)
            local channel = tonumber(data.freq)
            channels = Voip.Check:RestrictedChannels()
            if channels[channel] then
                local success = false
                if _character then
                    if channel == 999 then
                        if isAdmin then
                            channelName = Voip.Check:ChannelName(channel)
                            SendNUIMessage({
                                type = 'SET_FREQ',
                                data = { 
                                    frequency = channel,
                                    frequencyName = (channelName ~= nil and channelName or channel..' Mhz')
                                }
                            })
                            Voip.Add:addPlayerToRadio(channel)
                            table.insert(currentChannel, { channel = channel })
                            latestChannel = channel
                            radioOn = true
                        else
                            Notification:SendError('This is a restricted radio channel.', 3500)
                        end
                    else
                        for k, v in pairs(channels[channel]) do
                            if v == _character:GetData('Job').job and _character:GetData('JobDuty') then
                                success = true
                                channelName = Voip.Check:ChannelName(channel)
                                SendNUIMessage({
                                    type = 'SET_FREQ',
                                    data = { 
                                        frequency = channel,
                                        frequencyName = (channelName ~= nil and channelName or channel..' Mhz')
                                    }
                                })
                                Voip.Add:addPlayerToRadio(channel)
                                table.insert(currentChannel, { channel = channel })
                                latestChannel = channel
                                radioOn = true
                                break;
                            end
                        end
                    end
                end
                    
                if not success then
                    if not _character:GetData('JobDuty') and (_character:GetData('Job').job == "police" or _character:GetData('Job').job == "ems" or _character:GetData('Job').job == "doctor" or _character:GetData('Job').job == "fire" or _character:GetData('Job').job == "corrections") then
                        Notification:SendError('You can not access this channel off duty.', 3500)
                    else
                        Notification:SendError('This is a restricted radio channel.', 3500)
                    end
                end
            else
                channelName = Voip.Check:ChannelName(channel)
                SendNUIMessage({
                    type = 'SET_FREQ',
                    data = { 
                        frequency = channel,
                        frequencyName = (channelName ~= nil and channelName or channel..' Mhz')
                    }
                })
                Voip.Add:addPlayerToRadio(channel)
                table.insert(currentChannel, { channel = channel })
                latestChannel = channel
                radioOn = true
                
            end
        end)
    end
end)

RegisterNUICallback('clearChannel', function(data, cb)
    SendNUIMessage({
        type = 'SET_FREQ',
        data = { 
            frequency = '',
            frequencyName = ''
        }
    })
    for k, v in pairs(currentChannel) do
        Voip.Remove:removePlayerFromRadio(v.channel)
    end
    currentChannel = {}
    latestChannel = nil
    radioOn = false
end)