_call = nil
local _calling = false

function StartCallTimeout()
    if _calling then return end
    _calling = true

    PhonePlayCall(false)

    Citizen.CreateThread(function()
        local count = 0

        while _calling do
            Citizen.Wait(1) 

            if count < 1000 then
                count = count + 1
            else
                _calling = false
            end
        end
    end)
end

PHONE.Call = {
    Create = function(self, data)

        SendNUIMessage({
            type = 'SET_CALL_PENDING',
            data = { number = data.number }
        })

        Callbacks:ServerCallback('Phone:Phone:CreateCall', data, function(status)
            _call = {
                id = status,
                state = 0,
                number = data.number,
                duration = -1,
                method = 1
            }
    
            StartCallTimeout()
        end)
    end,
    Recieve = function(self, id, number)
        _call = {
            id = id,
            state = 1,
            number = number,
            duration = -1,
            method = 0
        }
        SendNUIMessage({
            type = 'SET_CALL_INCOMING',
            data = { number = number }
        })
    end,
    Accept = function(self)
        Callbacks:ServerCallback('Phone:Phone:AcceptCall', _call)
    end,
    End = function(self)
        _calling = false
        Callbacks:ServerCallback('Phone:Phone:EndCall', _call)
    end,
    Read = function(self)
        Callbacks:ServerCallback('Phone:Phone:ReadCalls')
    end,
    Status = function(self)
        return _call ~= nil
    end
}

RegisterNetEvent('Phone:Client:Phone:EndCall')
AddEventHandler('Phone:Client:Phone:EndCall', function(call)
    SendNUIMessage({
        type = 'END_CALL'
    })
    Phone.Data:Add('calls', call)
    _call = nil

    print(_phoneOpen)
    if _phoneOpen then
        PhoneCallToText()
    else
        PhonePlayOut()
    end
end)

RegisterNetEvent('Phone:Client:Phone:RecieveCall')
AddEventHandler('Phone:Client:Phone:RecieveCall', function(id, number)
    Phone.Call:Recieve(id, number)
end)

RegisterNetEvent('Phone:Client:Phone:AcceptCall')
AddEventHandler('Phone:Client:Phone:AcceptCall', function(number)
    _calling = false
    _call.state = 2
    _call.duration = 0
    SendNUIMessage({
        type = 'SET_CALL_ACTIVE',
        data = { number = number }
    })

    Voip.Add:Call(_call.id)
end)

RegisterNUICallback('CreateCall', function(data, cb)
    Phone.Call:Create(data)
end)

RegisterNUICallback('AcceptCall', function(data, cb)
    Phone.Call:Accept()
end)

RegisterNUICallback('EndCall', function(data, cb)
    Phone.Call:End()
end)

RegisterNUICallback('ReadCalls', function(data, cb)
    Phone.Call:Read()
end)