local myFeatures = {}
local crouched = false

ANIMATIONS.PedFeatures = {
    SetWalk = function(self, walk, label)
        if walk == 'reset' then
            ResetPedMovementClipset(GLOBAL_PED, 0.0)
            walkStyle = walk
            Callbacks:ServerCallback('Animations:UpdatePedFeatures', { type = 'walk', data = 'default'}, function(success)
                if success then
                    Notification:SendAlert('Reset Walking Style', 5000)
                end
            end)
        else
            ReqAnimSet(walk)
            SetPedMovementClipset(GLOBAL_PED, walk, 0.2)
            RemoveAnimSet(walk)
            walkStyle = walk
            Callbacks:ServerCallback('Animations:UpdatePedFeatures', { type = 'walk', data = walk}, function(success)
                if success then
                    Notification:SendAlert('Saved Walking Style: ' .. label, 5000)
                end
            end)
        end
    end,
    SetExpression = function(self, expression, label)
        if expression == 'reset' then
            ClearFacialIdleAnimOverride(GLOBAL_PED)
            facialExpression = expression
            Callbacks:ServerCallback('Animations:UpdatePedFeatures', { type = 'expression', data = 'default'}, function(success)
                if success then
                    Notification:SendAlert('Expression Reset', 5000)
                end
            end)
        else
            SetFacialIdleAnimOverride(GLOBAL_PED, expression, 0)
            facialExpression = expression
            Callbacks:ServerCallback('Animations:UpdatePedFeatures', { type = 'expression', data = expression}, function(success)
                if success then
                    Notification:SendAlert('Saved Expression: ' .. label, 5000)
                end
            end)
        end
    end,
    RequestFeaturesUpdate = function(self, feats)
        if walkStyle ~= 'default' then
            ReqAnimSet(walkStyle)
            SetPedMovementClipset(GLOBAL_PED, walkStyle, 0.6)
            RemoveAnimSet(walkStyle)
        end
        if facialExpression ~= 'default' then
            SetFacialIdleAnimOverride(GLOBAL_PED, facialExpression, 0)
        end
    end,
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        if characterLoaded then
            if not Damage:IsLimping() and not crouched then
                Animations.PedFeatures:RequestFeaturesUpdate()
            end
        end
    end
end)

RegisterNetEvent('Animations:Client:UpdateCrouch')
AddEventHandler('Animations:Client:UpdateCrouch', function(toggle)
    if characterLoaded then
        crouched = toggle
    end
end)