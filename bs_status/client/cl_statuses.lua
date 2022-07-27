local _hungerTicks = 0
local _spawned = false

AddEventHandler('Characters:Client:Spawn', function()
    _spawned = true
    Citizen.CreateThread(function()
        local effectCount = 0
        while _spawned do
            local player = PlayerPedId()
            if DecorExistOn(player, 'PLAYER_THIRST') and not IsEntityDead(player) then
                local val = DecorGetInt(PlayerPedId(), 'PLAYER_THIRST')
                if val <= 25 then
                    SetPlayerSprint(PlayerId(), false)
                    if val == 0 and effectCount >= 500 then
                        ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.4)
                        local luck = math.random(100)
                        if luck <= 20 then
                            SetPedToRagdoll(player, 1500, 2000, 3, true, true, false)
                        end
                        Damage.Apply:StandardDamage(3, false)

                        effectCount = 0
                    elseif effectCount >= 1000 then
                        ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.2)
                        effectCount = 0
                    else
                        effectCount = effectCount + 1
                    end
                else
                    if val - 25 > 0 then
                        Citizen.Wait(60000)
                        effectCount = 0
                    end
                end
                Citizen.Wait(1)
            else
                Citizen.Wait(1000)
            end
        end
    end)
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    _spawned = false
end)

RegisterNetEvent('Status:Client:updateStatus')
AddEventHandler('Status:Client:updateStatus', function(need, action, amount)
    if action then
        Status.Modify:Add(need, tonumber(amount), 2)
    else
        Status.Modify:Remove(need, tonumber(amount))
    end
end)

function RegisterStatuses()
    Status:Register('PLAYER_HUNGER', Status.TYPES.INT, 100, 'hunger', true, function(change)
        local player = PlayerPedId()
        if IsEntityDead(player) then
            return
        end

        if change == nil then
            change = -1
        end
        local val = DecorGetInt(player, 'PLAYER_HUNGER')
        if val + change > 100 then
            val = 100
        elseif val + change < 0 then
            val = 0
        else
            val = val + change
        end
        DecorSetInt(player, 'PLAYER_HUNGER', val)
        TriggerEvent('Status:Client:Update', 'hunger', val)
        TriggerServerEvent('Status:Server:Update', { status = 'PLAYER_HUNGER', value = val })

        if val <= 25 then
            if val > 10 then
                if (GetEntityHealth(player) - 100) > 11 then
                    Damage.Apply:StandardDamage(10, false)
                end
            else
                if (GetEntityHealth(player) - 100) > 1 then
                    Damage.Apply:StandardDamage(1, false)
                else
                    if _hungerTicks <= 10 then
                        SetFlash(0, 0, 100, 10000, 100)
                        _hungerTicks = _hungerTicks + 1
                    else
                        -- Kill Player
                    end
                end
            end
        end
    end)
    Status:Register('PLAYER_THIRST', Status.TYPES.INT, 100, 'thirst', true, function(change)
        local player = PlayerPedId()
        if IsEntityDead(player) then
            return
        end
        if change == nil then
            change = -1
        end
        local val = DecorGetInt(player, 'PLAYER_THIRST')
        if val + change > 100 then
            val = 100
        elseif val + change < 0 then
            val = 0
        else
            val = val + change
        end
        DecorSetInt(player, 'PLAYER_THIRST', val)
        TriggerEvent('Status:Client:Update', 'thirst', val)
        TriggerServerEvent('Status:Server:Update', { status = 'PLAYER_THIRST', value = val })
    end)
end