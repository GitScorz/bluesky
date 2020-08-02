local AnimationDuration = -1
local ChosenAnimation = ""
local ChosenDict = ""
local IsInAnimation = false
local IsAbleToCancel = true
local MovementType = 0
local PlayerHasProp = false
local PlayerProps = {}
local PlayerParticles = {}
local SecondPropEmote = false
local PtfxPrompt = false
local PtfxWait = 500
local PtfxNoProp = false
local isRequestAnim = false


ANIMATIONS.Emotes = {
    Play = function(self, emote, fromUserInput, time, notCancellable)
        if emote ~= nil then
            local name = string.lower(emote)
            local animInfo

            if AnimData.Emotes[name] ~= nil then
                animInfo = AnimData.Emotes[name]
            elseif AnimData.Dances[name] ~= nil then
                animInfo = AnimData.Dances[name]
            elseif AnimData.PropEmotes[name] ~= nil then
                animInfo = AnimData.PropEmotes[name]
            else
                Notification:Error('Invalid Emote')
            end
            local animTime = (time ~= nil and tonumber(time) or nil)
            local notCancellable = notCancellable ~= nil and notCancellable or false
            if animInfo ~= nil then
                DoAnEmote(animInfo, fromUserInput, animTime, notCancellable)
            end
        end
    end,
    Cancel = function(self)
        if IsAbleToCancel then
            CancelEmote()
        end
    end,
    ForceCancel = function(self) -- Force Cancel Regardless of If They Can
        CancelEmote()
    end,
}

function AddPropToPlayer(prop1, bone, off1, off2, off3, rot1, rot2, rot3)
    local x,y,z = table.unpack(GetEntityCoords(GLOBAL_PED))

    if not HasModelLoaded(prop1) then
        LoadPropDict(prop1)
    end

    prop = CreateObject(GetHashKey(prop1), x, y, z+0.2,  true,  true, true)
    AttachEntityToEntity(prop, GLOBAL_PED, GetPedBoneIndex(GLOBAL_PED, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
    table.insert(PlayerProps, prop)
    PlayerHasProp = true
    SetModelAsNoLongerNeeded(prop1)
end

function DestroyAllProps()
    for _,v in pairs(PlayerProps) do
        DeleteEntity(v)
    end
    PlayerHasProp = false
end

function DoAnEmote(emoteData, fromUserInput, length, notCancellable)

    if (fromUserInput and emoteData.AdditionalOptions.AvailableToChar) or (not fromUserInput) then
        IsAbleToCancel = not notCancellable
        local InVehicle = IsPedInAnyVehicle(GLOBAL_PED, true)

        if IsPedArmed(GLOBAL_PED, 7) then
            SetCurrentPedWeapon(GLOBAL_PED, GetHashKey('WEAPON_UNARMED'), true)
        end
        ChosenDict, ChosenAnimation = emoteData.AnDictionary, emoteData.AnAnim
        AnimationDuration = -1

        if PlayerHasProp then
            DestroyAllProps()
        end

        if ChosenDict == "MaleScenario" or "Scenario" then 
            if ChosenDict == "MaleScenario" then 
                if InVehicle then 
                    return 
                end
                ClearPedTasks(GLOBAL_PED)
                TaskStartScenarioInPlace(GLOBAL_PED, ChosenAnimation, 0, true)
                IsInAnimation = true
                return
            elseif ChosenDict == "ScenarioObject" then 
                if InVehicle then 
                    return 
                end
                BehindPlayer = GetOffsetFromEntityInWorldCoords(GLOBAL_PED, 0.0, 0 - 0.5, -0.5);
                ClearPedTasks(GLOBAL_PED)
                TaskStartScenarioAtPosition(GLOBAL_PED, ChosenAnimation, BehindPlayer['x'], BehindPlayer['y'], BehindPlayer['z'], GetEntityHeading(GLOBAL_PED), 0, 1, false)
                IsInAnimation = true
                return
            elseif ChosenDict == "Scenario" then 
                if InVehicle then 
                    return 
                end
                ClearPedTasks(GLOBAL_PED)
                TaskStartScenarioInPlace(GLOBAL_PED, ChosenAnimation, 0, true)
                IsInAnimation = true
                return 
            end 
        end

        LoadAnim(ChosenDict)

        if emoteData.AdditionalOptions.EmoteMoving then
            MovementType = 51
        elseif emoteData.AdditionalOptions.EmoteLoop then
            MovementType = 1
        else
            MovementType = 0
        end

        if InVehicle == 1 then
            MovementType = 51
        end

        if emoteData.AdditionalOptions then
            if emoteData.AdditionalOptions.EmoteDuration == nil then 
                emoteData.AdditionalOptions.EmoteDuration = -1
                AttachWait = 0
            else
                AnimationDuration = emoteData.AdditionalOptions.EmoteDuration
                AttachWait = emoteData.AdditionalOptions.EmoteDuration
            end

            if emoteData.AdditionalOptions.PtfxAsset then
                    PtfxAsset = emoteData.AdditionalOptions.PtfxAsset
                    PtfxName = emoteData.AdditionalOptions.PtfxName
                if emoteData.AdditionalOptions.PtfxNoProp then
                    PtfxNoProp = emoteData.AdditionalOptions.PtfxNoProp
                else
                    PtfxNoProp = false
                end
                Ptfx1, Ptfx2, Ptfx3, Ptfx4, Ptfx5, Ptfx6, PtfxScale = table.unpack(emoteData.AdditionalOptions.PtfxPlacement)
                PtfxInfo = emoteData.AdditionalOptions.PtfxInfo
                PtfxWait = emoteData.AdditionalOptions.PtfxWait
                PtfxPrompt = true
                Notification:Info(PtfxInfo, 5000)
                Citizen.CreateThread(function()
                    while PtfxPrompt do
                        if IsControlPressed(0, 47) then
                            PtfxStart()
                            Wait(PtfxWait)
                            PtfxStop()
                        end
                        Citizen.Wait(5)
                    end
                end)
                PtfxThis(PtfxAsset)
            else
                PtfxPrompt = false
            end
        end

        TaskPlayAnim(GLOBAL_PED, ChosenDict, ChosenAnimation, 2.0, 2.0, AnimationDuration, MovementType, 0, false, false, false)
        RemoveAnimDict(ChosenDict)
        IsInAnimation = true
        MostRecentDict = ChosenDict
        MostRecentAnimation = ChosenAnimation

        if emoteData.AdditionalOptions then
            if emoteData.AdditionalOptions.Prop then
                PropName = emoteData.AdditionalOptions.Prop
                PropBone = emoteData.AdditionalOptions.PropBone
                PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6 = table.unpack(emoteData.AdditionalOptions.PropPlacement)
                if emoteData.AdditionalOptions.SecondProp then
                    SecondPropName = emoteData.AdditionalOptions.SecondProp
                    SecondPropBone = emoteData.AdditionalOptions.SecondPropBone
                    SecondPropPl1, SecondPropPl2, SecondPropPl3, SecondPropPl4, SecondPropPl5, SecondPropPl6 = table.unpack(emoteData.AdditionalOptions.SecondPropPlacement)
                    SecondPropEmote = true
                else
                    SecondPropEmote = false
                end
                Wait(AttachWait)
                AddPropToPlayer(PropName, PropBone, PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6)
                if SecondPropEmote then
                    AddPropToPlayer(SecondPropName, SecondPropBone, SecondPropPl1, SecondPropPl2, SecondPropPl3, SecondPropPl4, SecondPropPl5, SecondPropPl6)
                end
            end
        end

        if length ~= nil and length ~= 0 then
            Citizen.SetTimeout(length, function()
                Animations.Emotes:ForceCancel()
                IsAbleToCancel = true
            end)
        end
    end
end

function CancelEmote()
    if ChosenDict == "MaleScenario" and IsInAnimation then
        ClearPedTasksImmediately(GLOBAL_PED)
        IsInAnimation = false
    elseif ChosenDict == "Scenario" and IsInAnimation then
        ClearPedTasksImmediately(GLOBAL_PED)
        IsInAnimation = false
    end
    PtfxPrompt = false
    if IsInAnimation then
        PtfxStop()
        ClearPedTasks(GLOBAL_PED)
        DestroyAllProps()
        IsInAnimation = false
    end
end

function PtfxStart()
    if PtfxNoProp then
        PtfxAt = GLOBAL_PED
    else
        PtfxAt = prop
    end
    UseParticleFxAssetNextCall(PtfxAsset)
    Ptfx = StartNetworkedParticleFxLoopedOnEntityBone(PtfxName, PtfxAt, Ptfx1, Ptfx2, Ptfx3, Ptfx4, Ptfx5, Ptfx6, GetEntityBoneIndexByName(PtfxName, "VFX"), 1065353216, 0, 0, 0, 1065353216, 1065353216, 1065353216, 0)
    SetParticleFxLoopedColour(Ptfx, 1.0, 1.0, 1.0)
    table.insert(PlayerParticles, Ptfx)
end

function PtfxStop()
    for a,b in pairs(PlayerParticles) do
        StopParticleFxLooped(b, false)
        table.remove(PlayerParticles, a)
    end
end

RegisterNetEvent('Animations:Client:CharacterDoAnEmote')
AddEventHandler('Animations:Client:CharacterDoAnEmote', function(emote)
    if characterLoaded then
        Animations.Emotes:Play(emote, true)
    end
end)

RegisterNetEvent('Animations:Client:CharacterCancelEmote')
AddEventHandler('Animations:Client:CharacterCancelEmote', function()
    if characterLoaded then
        Animations.Emotes:Cancel()
    end
end)