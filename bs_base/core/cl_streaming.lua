COMPONENTS.Stream = {
    _protected = true,
    _name = 'base',
}

COMPONENTS.Stream = {
    --- @param modelName string|number The name or hash of the model.
    RequestModel = function(modelName)
        local modelHash = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
        if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
            RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do
                Wait(1)
            end
        end
    end,

    --- @param dictName string The dictionary name of the model.
    RequestAnimDict = function(dictName)
        RequestAnimDict(dictName)
        while not HasAnimDictLoaded(dictName) do
            Wait(100)
        end
    end,

    --- @param setName string The dictionary name of the set.
    RequestAnimSet = function(setName)
        RequestAnimSet(setName)
        while not HasAnimSetLoaded(setName) do
            Wait(100)
        end
    end
}