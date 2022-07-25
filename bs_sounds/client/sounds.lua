local SoundLibrary = {
    text = 'text1.ogg',
    text2 = 'text2.mp3',
    panic = 'panic.mp3',
    panicEnd = 'panic_clear.mp3',
}

local _sounds = {}

AddEventHandler('Sounds:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Logger = exports['bs_base']:FetchComponent('Logger')
    Sounds = exports['bs_base']:FetchComponent('Sounds')
    UISounds = exports['bs_base']:FetchComponent('UISounds')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Sounds', {
        'Callbacks',
        'Logger',
        'Sounds',
        'UISounds',
    }, function(error)  
        if #error > 0 then return; end
        RetrieveComponents()
    end)
end)

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Sounds', SOUNDS)
end)

RegisterNUICallback('SoundEnd', function(data, cb)
    Logger:Trace('Sounds', ('^2Stopping Sound %s For ID %s^7'):format(data.file, data.source))
    if _sounds[data.source] ~= nil and _sounds[data.source][data.file] ~= nil then
        _sounds[data.source][data.file] = nil
    end
end)

SOUNDS = {}
SOUNDS.Do = {
    Loop = {
        One = function(self, soundFile, soundVolume)
            Logger:Trace('Sounds', ('^2Looping Sound %s On Client Only^7'):format(soundFile))
            local id = GetPlayerServerId(PlayerId())
            _sounds[id] = _sounds[id] or {}
            _sounds[id][soundFile] = {
                file = soundFile,
                volume = soundVolume,
                distance = maxDistance
            }
            SendNUIMessage({
                action = 'loopSound',
                source = id,
                file = SoundLibrary[soundFile] or soundFile,
                volume = soundVolume
            })
        end,
        Distance = function(self, playerNetId, maxDistance, soundFile, soundVolume)
            Logger:Trace('Sounds', ('^2Looping Sound %s Per Request From %s For Distance %s^7'):format(soundFile, playerNetId, maxDistance))
            local lCoords = GetEntityCoords(PlayerPedId())
            local eCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerNetId)))
            local distIs  = #(vector3(lCoords.x, lCoords.y, lCoords.z) - vector3(eCoords.x, eCoords.y, eCoords.z))
            if(distIs <= maxDistance) then
                _sounds[playerNetId] = _sounds[playerNetId] or {}
                _sounds[playerNetId][soundFile] = {
                    file = soundFile,
                    volume = soundVolume,
                    distance = maxDistance
                }
                SendNUIMessage({
                    action = 'loopSound',
                    source = playerNetId,
                    file = SoundLibrary[soundFile] or soundFile,
                    volume = soundVolume * (1.0 - (distIs / 100))
                })
            else
                Sounds.Stop:Looping(playerNetId, soundFile)
            end
        
            Citizen.CreateThread(function()
                while _sounds[playerNetId] ~= nil do
                    local lCoords = GetEntityCoords(PlayerPedId())
                    local eCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerNetId)))
                    local distIs  = #(vectory3(lCoords.x, lCoords.y, lCoords.z) - vector3(eCoords.x, eCoords.y, eCoords.z))
                    SendNUIMessage({
                        action = 'changeVol',
                        source = playerNetId,
                        volume = soundVolume * (1.0 - (distIs / 100))
                    })
                    Citizen.Wait(100)
                end
            end)
        end
    },
    Play = {
        One = function(self, playetNedId, soundFile, soundVolume)
            Logger:Trace('Sounds', ('^2Playing Sound %s On Client Only^7'):format(soundFile))
            local id = GetPlayerServerId(PlayerId())
            _sounds[playetNedId] = _sounds[playetNedId] or {}
            _sounds[playetNedId][soundFile] = {
                file = soundFile,
                volume = soundVolume
            }
            SendNUIMessage({
                action = 'playSound',
                source = playetNedId,
                file = SoundLibrary[soundFile] or soundFile,
                volume = soundVolume
            })
        end,
        Distance = function(self, playerNetId, maxDistance, soundFile, soundVolume)
            Logger:Trace('Sounds', ('^2Playing Sound %s Once Per Request From %s For Distance %s^7'):format(soundFile, playerNetId, maxDistance))
            local lCoords = GetEntityCoords(PlayerPedId())
            local eCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerNetId)))
            local distIs  = #(vector3(lCoords.x, lCoords.y, lCoords.z) - vector3(eCoords.x, eCoords.y, eCoords.z))
            if(distIs <= maxDistance) then
                _sounds[playerNetId] = _sounds[playerNetId] or {}
                _sounds[playerNetId][soundFile] = {
                    file = soundFile,
                    volume = soundVolume
                }

                SendNUIMessage({
                    action = 'playSound',
                    source = playerNetId,
                    file = SoundLibrary[soundFile] or soundFile,
                    volume = soundVolume * (1.0 - (distIs / 100))
                })
            end
        end,
    },
    Stop = {
        One = function(self, soundFile)
            Logger:Trace('Sounds', ('^2Stopping Sound %s On Client^7'):format(soundFile))
            local id = GetPlayerServerId(PlayerId())
            if _sounds[id] ~= nil and _sounds[id][soundFile] ~= nil then
                _sounds[id][soundFile] = nil
                SendNUIMessage({
                    action = 'stopSound',
                    source = id,
                    file = soundFile
                })
            end
        end,
        Distance = function(self, playerNetId, soundFile)
            Logger:Trace('Sounds', ('^2Stopping Sound %s Per Request From %s^7'):format(soundFile, playerNetId))
            if _sounds[playerNetId] ~= nil and _sounds[playerNetId][soundFile] ~= nil then
                _sounds[playerNetId][soundFile] = nil
                SendNUIMessage({
                    action = 'stopSound',
                    source = playerNetId,
                    file = soundFile
                })
            end
        end
    }
}

SOUNDS.Play = {
    One = function(self, soundFile, soundVolume)
        Sounds.Do.Play:One(soundFile, soundVolume)
    end,
    Distance = function(self, maxDistance, soundFile, soundVolume)
        Callbacks:ServerCallback('Sounds:Play:Distance', {
            maxDistance = maxDistance,
            soundFile = soundFile,
            soundVolume = soundVolume
        })
    end,
}

SOUNDS.Loop = {
    One = function(self, soundFile, soundVolume)
        Sounds.Do.Loop:One(soundFile, soundVolume)
    end,
    Distance = function(self, maxDistance, soundFile, soundVolume)
        Callbacks:ServerCallback('Sounds:Loop:Distance', {
            maxDistance = maxDistance,
            soundFile = soundFile,
            soundVolume = soundVolume
        })
    end
}

SOUNDS.Stop = {
    One = function(self, soundFile)
        Sounds.Do.Stop:One(soundFile)
    end,
    Distance = function(self, soundFile)
        Callbacks:ServerCallback('Sounds:Stop:Distance', {
            maxDistance = soundFile
        })
    end
}

RegisterNetEvent('Sounds:Client:Play:One')
AddEventHandler('Sounds:Client:Play:One', function(playetNedId, soundFile, soundVolume)
    print(('Playing %s You Cunt'):format(soundFile))
    Sounds.Do.Play:One(playetNedId, soundFile, soundVolume)
end)

RegisterNetEvent('Sounds:Client:Play:Distance')
AddEventHandler('Sounds:Client:Play:Distance', function(playerNetId, maxDistance, soundFile, soundVolume)
    Sounds.Do.Play:Distance(playerNetId, maxDistance, soundFile, soundVolume)
end)

RegisterNetEvent('Sounds:Client:Loop:One')
AddEventHandler('Sounds:Client:Loop:One', function(soundFile, soundVolume)
    Sounds.Do.Loop:One(soundFile, soundVolume)
end)

RegisterNetEvent('Sounds:Client:Loop:Distance')
AddEventHandler('Sounds:Client:Loop:Distance', function(playerNetId, maxDistance, soundFile, soundVolume)
    Sounds.Do.Loop:Distance(playerNetId, maxDistance, soundFile, soundVolume)
end)

RegisterNetEvent('Sounds:Client:Stop:One')
AddEventHandler('Sounds:Client:Stop:One', function(soundFile)
    Sounds.Do.Stop:One(soundFile)
end)

RegisterNetEvent('Sounds:Client:Stop:Distance')
AddEventHandler('Sounds:Client:Stop:Distance', function(playerNetId, soundFile)
    Sounds.Do.Stop:Distance(playerNetId, soundFile)
end)