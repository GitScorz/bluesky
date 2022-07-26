_damagedLimbs = {}

DAMAGE = {
    _required = { 'Heal', 'Alerts' },
    GetDamage = function(self)
        return _damagedLimbs
    end,
    IsLimping = function(self)
        return IsInjuryCausingLimp()
    end,
    Heal = function(self)
        local player = PlayerPedId()

        if IsPedDeadOrDying(player) then
            local playerPos = GetEntityCoords(player, true)
            NetworkResurrectLocalPlayer(playerPos, true, true, false)
        end
    
        SetEntityHealth(player, GetEntityMaxHealth(player))
        ClearPedBloodDamage(player)
        SetPlayerSprint(PlayerId(), true)

        _damagedLimbs = {}
        bleedTickTimer = 0
        advanceBleedTimer = 0
        fadeOutTimer = 0
        blackoutTimer = 0
        onDrugs = 0
        wasOnDrugs = false
        onPainKiller = 0
        wasOnPainKillers = false

        -- Notification.Persistent:Remove(bleedNotifId)
        -- Notification.Persistent:Remove(limbNotifId)
        -- Notification.Persistent:Remove(bleedMoveNotifId)
    end,
    Alerts = {
        Bleed = function(self)
            local player = PlayerPedId()
            if not IsEntityDead(player) and LocalDamage.Bleed > 0 then
                -- Notification.Persistent:Custom(bleedNotifId, string.format(Config.Strings.BleedAlert, Config.BleedingStates[LocalDamage.Bleed]), Config.NotifStyle)
            else
                -- Notification.Persistent:Remove(bleedNotifId)
            end
        end,
        Limbs = function(self)
            local player = PlayerPedId()
            if not IsEntityDead(player) then
                if #_damagedLimbs > 0 then
                    local limbDamageMsg = ''
                    if #_damagedLimbs <= Config.AlertShowInfo then
                        for k, v in pairs(_damagedLimbs) do
                            limbDamageMsg = string.format(Config.Strings.LimbAlert, v.label, Config.WoundStates[v.severity])
                            if k < #_damagedLimbs then
                                limbDamageMsg = limbDamageMsg .. Config.Strings.LimbAlertSeperator
                            end
                        end
                    else
                        limbDamageMsg = Config.Strings.LimbAlertMultiple
                    end

                    -- Notification.Persistent:Custom(limbNotifId, limbDamageMsg, Config.NotifStyle)
                else
                    -- Notification.Persistent:Remove(limbNotifId)
                end
            else
                -- Notification.Persistent:Remove(limbNotifId)
            end
        end,
        Debug = function(self, ped, bone, weapon, damageDone)
            Notification:SendAlert('Bone: ' .. Config.Bones[bone])
            if (Config.MinorInjurWeapons[weapon] ~= nil) then
                Notification:SendAlert('Minor Weapon : ' .. weapon, 10000)
            else
                Notification:SendAlert('Major Weapon : ' .. weapon, 10000)
            end
            Notification:SendAlert('Crit Area: ' .. tostring(Config.CriticalAreas[Config.Bones[bone]] ~= nil), 10000)
            Notification:SendAlert('Stagger Area: ' .. tostring(Config.StaggerAreas[Config.Bones[bone]] ~= nil and (Config.StaggerAreas[Config.Bones[bone]].armored or GetPedArmour(ped) <= 0)), 10000)
            Notification:SendAlert('Dmg Done: ' .. damageDone, 10000)
        end,
    },
    CheckDamage = function(self, ped, bone, weapon, damageDone)
        if weapon == nil or LocalDamage == nil then return end
    
        if Config.Bones[bone] ~= nil and not IsEntityDead(ped) then
            if Config.Debug then
                Damage.Alerts:Debug(ped, bone, weapon, damageDone)
            end
    
            Damage.Apply:Effects(ped, bone, weapon, damageDone)
            
            Callbacks:ServerCallback('Damage:ApplyDamage', bone, function(new)
                LocalDamage.Limbs[Config.Bones[bone]] = new
                if LocalDamage.Limbs[Config.Bones[bone]].severity == 1 then
                    table.insert(_damagedLimbs, {
                        part = Config.Bones[bone],
                        label = LocalDamage.Limbs[Config.Bones[bone]].label,
                        severity = LocalDamage.Limbs[Config.Bones[bone]].severity
                    })
                else
                    for k, v in pairs(_damagedLimbs) do
                        if v.part == Config.Bones[bone] then
                            v.severity = LocalDamage.Limbs[Config.Bones[bone]].severity
                            break
                        end
                    end
                end

                Damage.Alerts:Bleed()
                Damage.Alerts:Limbs()
                Damage.Apply:Movement(ped)
            end)
        else
            if not IsEntityDead(ped) then
                print('Bone Not In Index - Report This! - ' .. bone)
            end
        end
    end,
    Apply = {
        StandardDamage = function(self, value, armorFirst)
            ApplyDamageToPed(PlayerPedId(), value, armorFirst)
        end,
        Bleed = function(self, level)
            Callbacks:ServerCallback('Damage:ApplyBleed', level, function(new)
                LocalDamage.Bleed = new
                Damage.Alerts:Bleed()
            end)
        end,
        Effects = function(self, ped, bone, weapon, damageDone)
            local armor = GetPedArmour(ped)
        
            if Config.MinorInjurWeapons[weapon] and damageDone < Config.DamageMinorToMajor then
                if Config.CriticalAreas[Config.Bones[bone]] then
                    if armor <= 0 then
                        Damage.Apply:Bleed(1)
                    end
                end
        
                if Config.StaggerAreas[Config.Bones[bone]] ~= nil and (Config.StaggerAreas[Config.Bones[bone]].armored or armor <= 0) then
                    if math.random(100) <= math.ceil(Config.StaggerAreas[Config.Bones[bone]].minor) then
                        SetPedToRagdoll(ped, 1500, 2000, 3, true, true, false)
                    end
                end
            elseif Config.MajorInjurWeapons[weapon] or (Config.MinorInjurWeapons[weapon] and damageDone >= Config.DamageMinorToMajor) then
                if Config.CriticalAreas[Config.Bones[bone]] ~= nil then
                    if armor > 0 and Config.CriticalAreas[Config.Bones[bone]].armored then
                        if math.random(100) <= math.ceil(Config.MajorArmoredBleedChance) then
                            Damage.Apply:Bleed(1)
                        end
                    else
                        Damage.Apply:Bleed(1)
                    end
                else
                    if armor > 0 then
                        if math.random(100) < (Config.MajorArmoredBleedChance) then
                            Damage.Apply:Bleed(1)
                        end
                    else
                        if math.random(100) < (Config.MajorArmoredBleedChance * 2) then
                            Damage.Apply:Bleed(1)
                        end
                    end
                end
        
                if Config.StaggerAreas[Config.Bones[bone]] ~= nil and (Config.StaggerAreas[Config.Bones[bone]].armored or armor <= 0) then
                    if math.random(100) <= math.ceil(Config.StaggerAreas[Config.Bones[bone]].major) then
                        SetPedToRagdoll(ped, 1500, 2000, 3, true, true, false)
                    end
                end
            end
        end,
        Movement = function(self, ped)
            if IsInjuryCausingLimp() and not (onPainKiller > 0)  then
                RequestAnimSet('move_m@injured')
                while not HasAnimSetLoaded('move_m@injured') do
                    Citizen.Wait(0)
                end
                SetPedMovementClipset(PlayerPedId(), 'move_m@injured', 1 )
                SetPlayerSprint(PlayerId(), false)
        
                if wasOnPainKillers then
                    SetPedToRagdoll(PlayerPedId(), 1500, 2000, 3, true, true, false)
                    wasOnPainKillers = false
                    Notification:Custom(Config.Strings.PainKillersExpired, 5000, Config.NotifStyle)
                end
            else
                SetPedMoveRateOverride(ped, 1.0)
                ResetPedMovementClipset(ped, 1.0)
        
                if not wasOnPainKillers and (onPainKiller > 0) then wasOnPainKillers = true end
        
                if onPainKiller > 0 then
                    onPainKiller = onPainKiller - 1
                end
            end
        end,
    },
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Damage', DAMAGE)
end)