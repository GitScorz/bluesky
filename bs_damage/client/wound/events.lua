
RegisterNetEvent('mythic_hospital:client:SyncLimbs')
AddEventHandler('mythic_hospital:client:SyncLimbs', function(limbs)
    LocalDamage.Limbs = limbs

	injured = {}
    for k, v in pairs(LocalDamage.Limbs) do
        if v.isDamaged then
            table.insert(injured, {
                part = k,
                label = v.label,
                severity = v.severity
            })
        end
    end

    DoLimbAlert()
end)

RegisterNetEvent('mythic_hospital:client:SyncBleed')
AddEventHandler('mythic_hospital:client:SyncBleed', function(bleedStatus)
    isBleeding = tonumber(bleedStatus)
    DoBleedAlert()
end)

RegisterNetEvent('mythic_hospital:client:FieldTreatLimbs')
AddEventHandler('mythic_hospital:client:FieldTreatLimbs', function()
    for k, v in pairs(LocalDamage.Limbs) do
        v.isDamaged = false
        v.severity = 1
    end

    for k, v in pairs(injured) do
        if v.part == Config.Bones[bone] then
            v.severity = LocalDamage.Limbs[Config.Bones[bone]].severity
        end
    end

    TriggerServerEvent('Damage:Server:SyncInjuries', {
        limbs = LocalDamage.Limbs,
        isBleeding = tonumber(isBleeding)
    })

    ProcessRunStuff(PlayerPedId())
    DoLimbAlert()
end)
RegisterNetEvent('mythic_hospital:client:FieldTreatBleed')
AddEventHandler('mythic_hospital:client:FieldTreatBleed', function()
    if isBleeding > 1 then
        isBleeding = tonumber(isBleeding) - 1

        TriggerServerEvent('Damage:Server:SyncInjuries', {
            limbs = LocalDamage.Limbs,
            isBleeding = tonumber(isBleeding)
        })

        ProcessRunStuff(PlayerPedId())
        DoBleedAlert()
    end
end)

RegisterNetEvent('mythic_hospital:client:ReduceBleed')
AddEventHandler('mythic_hospital:client:ReduceBleed', function()
    if isBleeding > 0 then
        isBleeding = tonumber(isBleeding) - 1

        TriggerServerEvent('Damage:Server:SyncInjuries', {
            limbs = LocalDamage.Limbs,
            isBleeding = tonumber(isBleeding)
        })

        ProcessRunStuff(PlayerPedId())
        DoBleedAlert()
    end
end)


RegisterNetEvent('mythic_hospital:client:ResetLimbs')
AddEventHandler('mythic_hospital:client:ResetLimbs', function()
    injured = {}

    for k, v in pairs(LocalDamage.Limbs) do
        v.isDamaged = false
        v.severity = 0
    end
    TriggerServerEvent('Damage:Server:SyncInjuries', {
        limbs = LocalDamage.Limbs,
        isBleeding = tonumber(isBleeding)
    })

    ProcessRunStuff(PlayerPedId())
    DoLimbAlert()
end)

RegisterNetEvent('mythic_hospital:client:RemoveBleed')
AddEventHandler('mythic_hospital:client:RemoveBleed', function()
    isBleeding = 0

    TriggerServerEvent('Damage:Server:SyncInjuries', {
        limbs = LocalDamage.Limbs,
        isBleeding = tonumber(isBleeding)
    })

    ProcessRunStuff(PlayerPedId())
    DoBleedAlert()
end)

RegisterNetEvent('mythic_hospital:client:UsePainKiller')
AddEventHandler('mythic_hospital:client:UsePainKiller', function(tier)
    if tier < 10 then
        onPainKiller = 90 * tier
    end

    Notification:Custom(Config.Strings.UsePainKillers, 5000, Config.NotifStyle)
    ProcessRunStuff(PlayerPedId())
end)

RegisterNetEvent('mythic_hospital:client:UseAdrenaline')
AddEventHandler('mythic_hospital:client:UseAdrenaline', function(tier)
    if tier < 10 then
        onDrugs = 180 * tier
    end

    Notification:Custom(Config.Strings.UseAdrenaline, 5000, Config.NotifStyle)
    ProcessRunStuff(PlayerPedId())
end)