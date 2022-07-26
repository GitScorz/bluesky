Callbacks = nil
Notifications = nil
Damage = nil
Notification = nil

LocalDamage = nil

RegisterNetEvent('Damage:Client:RecieveUpdate')
AddEventHandler('Damage:Client:RecieveUpdate', function(data, h)
    LocalDamage = data

    if h then 
        Damage:Heal()
    end
end)

AddEventHandler('Damage:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Notifications = exports['bs_base']:FetchComponent('Notifications')
    Damage = exports['bs_base']:FetchComponent('Damage')
    Notification = exports['bs_base']:FetchComponent('Notification')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Damage', {
        'Callbacks',
        'Notifications',
        'Damage',
        'Notification',
    }, function(error)  
        if #error > 0 then return; end
        RetrieveComponents()
    end)
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    LocalDamage = nil
    -- Notification.Persistent:Remove(bleedNotifId)
    -- Notification.Persistent:Remove(limbNotifId)
    -- Notification.Persistent:Remove(bleedMoveNotifId)
end)

AddEventHandler('Characters:Client:Spawn', function()
    local damage = exports['bs_base']:FetchComponent('Player').LocalPlayer:GetData('Character'):GetData('Damage')
    if damage == nil then
        Callbacks:ServerCallback('Damage:GetDamage', {}, function(dmg)
            exports['bs_base']:FetchComponent('Player').LocalPlayer:GetData('Character'):SetData('Damage', dmg)
            LocalDamage = dmg
            StartTracking()
        end)
    else
        LocalDamage = damage
        StartTracking()
    end
end)

function StartTracking()
    Citizen.CreateThread(function()
        while LocalDamage ~= nil do
            if #_damagedLimbs > 0 then
                local level = 0
                for k, v in pairs(_damagedLimbs) do
                    if v.severity > level then
                        level = v.severity
                    end
                end
    
                SetPedMoveRateOverride(PlayerPedId(), Config.MovementRate[level])
                
                Citizen.Wait(5)
            else
                Citizen.Wait(1000)
            end
        end
    end)
    
    local prevPos = nil
    Citizen.CreateThread(function()
        prevPos = GetEntityCoords(PlayerPedId(), true)
        while LocalDamage ~= nil do
            if LocalDamage.Bleed > 0 then
                local player = PlayerPedId()
                if bleedTickTimer >= Config.BleedTickRate then
                    if not IsEntityDead(player) then
                        if LocalDamage.Bleed > 0 then
                            if LocalDamage.Bleed == 1 then
                                SetFlash(0, 0, 100, 100, 100)
                            elseif LocalDamage.Bleed == 2 then
                                SetFlash(0, 0, 100, 250, 100)
                            elseif LocalDamage.Bleed == 3 then
                                SetFlash(0, 0, 100, 500, 100)
                            elseif LocalDamage.Bleed == 4 then
                                SetFlash(0, 0, 100, 500, 100)
                            end
    
                            if fadeOutTimer + 1 == Config.FadeOutTimer then
                                if blackoutTimer + 1 == Config.BlackoutTimer then
                                    Notification:Custom('You Suddenly Black Out', 5000, Config.NotifStyle)
                                    SetFlash(0, 0, 100, 7000, 100)
    
                                    DoScreenFadeOut(500)
                                    while not IsScreenFadedOut() do
                                        Citizen.Wait(0)
                                    end
    
                                    if not IsPedRagdoll(player) and IsPedOnFoot(player) and not IsPedSwimming(player) then
                                        ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08) -- change this float to increase/decrease camera shake
                                        SetPedToRagdollWithFall(PlayerPedId(), 7500, 9000, 1, GetEntityForwardVector(player), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                                    end
    
                                    Citizen.Wait(1500)
                                    DoScreenFadeIn(1000)
                                    blackoutTimer = 0
                                else
                                    DoScreenFadeOut(500)
                                    while not IsScreenFadedOut() do
                                        Citizen.Wait(0)
                                    end
                                    DoScreenFadeIn(500)
    
                                    if LocalDamage.Bleed > 3 then
                                        blackoutTimer = blackoutTimer + 2
                                    else
                                        blackoutTimer = blackoutTimer + 1
                                    end
                                end
    
                                fadeOutTimer = 0
                            else
                                fadeOutTimer = fadeOutTimer + 1
                            end
    
                            local bleedDamage = tonumber(LocalDamage.Bleed) * Config.BleedTickDamage
                            ApplyDamageToPed(player, bleedDamage, false)
                            playerHealth = playerHealth - bleedDamage
    
                            if advanceBleedTimer >= Config.AdvanceBleedTimer then
                                Damage.Apply:Bleed(1)
                                advanceBleedTimer = 0
                            else
                                advanceBleedTimer = advanceBleedTimer + 1
                            end
                        end
                    end
                    bleedTickTimer = 0
                else
                    if math.floor(bleedTickTimer % (Config.BleedTickRate / 10)) == 0 then
                        local currPos = GetEntityCoords(player, true)
                        local moving = #(vector2(prevPos.x, prevPos.y) - vector2(currPos.x, currPos.y))
                        if (moving > 1 and not IsPedInAnyVehicle(player)) and LocalDamage.Bleed > 2 then
                            -- Notification.Persistent:Custom(bleedMoveNotifId, 'You notice blood oozing from your wounds faster when you\'re moving', Config.NotifStyle)
                            advanceBleedTimer = advanceBleedTimer + Config.BleedMovementAdvance
                            bleedTickTimer = bleedTickTimer + Config.BleedMovementTick
                            prevPos = currPos
                        else
                            -- Notification.Persistent:Remove(bleedMoveNotifId)
                            bleedTickTimer = bleedTickTimer + 1
                        end
    
                    else
    
                    end
                    bleedTickTimer = bleedTickTimer + 1
                end
            end
    
            Citizen.Wait(1000)
        end
    end)
    
    Citizen.CreateThread(function()
        while LocalDamage ~= nil do
            local ped = PlayerPedId()
            local health = GetEntityHealth(ped)
            local armor = GetPedArmour(ped)
    
            if not playerHealth then
                playerHealth = health
            end
    
            if not playerArmor then
                playerArmor = armor
            end
    
            local armorDamaged = (playerArmor ~= armor and armor < (playerArmor - Config.ArmorDamage) and armor > 0) -- Players armor was damaged
            local healthDamaged = (playerHealth ~= health) -- Players health was damaged
    
            local damageDone = (playerHealth - health)
    
            if armorDamaged or healthDamaged then
                local hit, bone = GetPedLastDamageBone(ped)
                local bodypart = Config.Bones[bone]
                local weapon = GetDamagingWeapon(ped)
    
                if hit and bodypart ~= 'NONE' then
                    if damageDone >= Config.HealthDamage then
                        local checkDamage = true
                        if weapon ~= nil then
                            if armorDamaged and (bodypart == 'SPINE' or bodypart == 'UPPER_BODY') or weapon == Config.WeaponClasses['NOTHING'] then
                                checkDamage = false -- Don't check damage if the it was a body shot and the weapon class isn't that strong
                            end
        
                            if checkDamage then
        
                                if IsDamagingEvent(damageDone, weapon) then
                                    Damage:CheckDamage(ped, bone, weapon, damageDone)
                                end
                            end
                        end
                    elseif Config.AlwaysBleedChanceWeapons[weapon] then
                        if math.random(100) < Config.AlwaysBleedChance then
                            Damage.Apply:Bleed(1)
                        end
                    end
                end
            end
    
            playerHealth = health
            playerArmor = armor
            ProcessDamage(ped)
            Citizen.Wait(100)
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        if (Config.MaxHp - 100) > 0 and Config.MaxHp <= 200 then
            SetEntityMaxHealth(PlayerPedId(), Config.MaxHp)
        else
            SetEntityMaxHealth(PlayerPedId(), 200)
        end

        if Config.RegenRate >= 0 and Config.RegenRate <= 1.0 then
            SetPlayerHealthRechargeMultiplier(PlayerId(), Config.RegenRate)
        else
            SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
        end

        Citizen.Wait(10000)
    end
end)