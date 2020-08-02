RegisterNetEvent('Progress:Client:Progress')
AddEventHandler('Progress:Client:Progress', function(action, cb)
    Progress:Progress(action, cb)
end)

RegisterNetEvent('Progress:Client:ProgressWithStartEvent')
AddEventHandler('Progress:Client:ProgressWithStartEvent', function(action, start, finish)
    Progress:ProgressWithStartEvent(action, start, finish)
end)

RegisterNetEvent('Progress:Client:ProgressWithTickEvent')
AddEventHandler('Progress:Client:ProgressWithTickEvent', function(action, tick, finish)
    Progress:ProgressWithTickEvent(action, tick, finish)
end)

RegisterNetEvent('Progress:Client:ProgressWithStartAndTick')
AddEventHandler('Progress:Client:ProgressWithStartAndTick', function(action, start, tick, finish)
    Progress:ProgressWithStartAndTick(action, start, tick, finish)
end)

RegisterNetEvent('Progress:Client:Cancel')
AddEventHandler('Progress:Client:Cancel', function()
    Progress:Cancel()
end)

RegisterNetEvent('Progress:Client:Fail')
AddEventHandler('Progress:Client:Fail', function()
    Progress:Fail()
end)

RegisterNUICallback('actionFinish', function(data, cb)
    Finish()
end)