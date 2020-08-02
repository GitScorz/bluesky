function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Damage:GetDamage', function(source, data, cb)
        local char = exports['bs_base']:FetchComponent('Fetch'):Source(source):GetData('Character')
    
        if char:GetData('Damage') == nil then
            char:SetData('Damage', { Bleed = 0, Limbs = {
                ['HEAD'] = { label = 'Head', causeLimp = false, isDamaged = false, severity = 0 },
                ['NECK'] = { label = 'Neck', causeLimp = false, isDamaged = false, severity = 0 },
                ['SPINE'] = { label = 'Spine', causeLimp = true, isDamaged = false, severity = 0 },
                ['UPPER_BODY'] = { label = 'Upper Body', causeLimp = false, isDamaged = false, severity = 0 },
                ['LOWER_BODY'] = { label = 'Lower Body', causeLimp = true, isDamaged = false, severity = 0 },
                ['LARM'] = { label = 'Left Arm', causeLimp = false, isDamaged = false, severity = 0 },
                ['LHAND'] = { label = 'Left Hand', causeLimp = false, isDamaged = false, severity = 0 },
                ['LFINGER'] = { label = 'Left Hand Fingers', causeLimp = false, isDamaged = false, severity = 0 },
                ['LLEG'] = { label = 'Left Leg', causeLimp = true, isDamaged = false, severity = 0 },
                ['LFOOT'] = { label = 'Left Foot', causeLimp = true, isDamaged = false, severity = 0 },
                ['RARM'] = { label = 'Right Arm', causeLimp = false, isDamaged = false, severity = 0 },
                ['RHAND'] = { label = 'Right Hand', causeLimp = false, isDamaged = false, severity = 0 },
                ['RFINGER'] = { label = 'Right Hand Fingers', causeLimp = false, isDamaged = false, severity = 0 },
                ['RLEG'] = { label = 'Right Leg', causeLimp = true, isDamaged = false, severity = 0 },
                ['RFOOT'] = { label = 'Right Foot', causeLimp = true, isDamaged = false, severity = 0 },
            }})
        end
        cb(char:GetData('Damage'))
    end)

    Callbacks:RegisterServerCallback('Damage:SyncDamage', function(source, data, cb)
        local char = exports['bs_base']:FetchComponent('Fetch'):Source(source):GetData('Character')
        char:SetData('Damage', data.damage)
        cb(data.damage)
    end)

    Callbacks:RegisterServerCallback('Damage:ApplyBleed', function(source, level, cb)
        local char = exports['bs_base']:FetchComponent('Fetch'):Source(source):GetData('Character')
        
        if char ~= nil then
            local damage = char:GetData('Damage')
            if damage.Bleed ~= 4 then
                if damage.Bleed + level > 4 then
                    damage.Bleed = 4
                else
                    damage.Bleed = damage.Bleed + level
                end
                
                char:SetData('Damage', damage)
                cb(damage.Bleed)
            end
        end
    end)

    Callbacks:RegisterServerCallback('Damage:ApplyDamage', function(source, bone, cb)
        local char = exports['bs_base']:FetchComponent('Fetch'):Source(source):GetData('Character')
        
        if char ~= nil then
            local damage = char:GetData('Damage')
            if not damage.Limbs[Config.Bones[bone]].isDamaged then
                damage.Limbs[Config.Bones[bone]].isDamaged = true
                damage.Limbs[Config.Bones[bone]].severity = 1
            else
                if damage.Limbs[Config.Bones[bone]].severity < 4 then
                    damage.Limbs[Config.Bones[bone]].severity = damage.Limbs[Config.Bones[bone]].severity + 1
                end
            end
            char:SetData('Damage', damage)
            cb(damage.Limbs[Config.Bones[bone]])
        end
    end)
end