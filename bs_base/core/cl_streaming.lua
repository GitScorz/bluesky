COMPONENTS.Stream = {
    _protected = true,
    _name = 'base',
}

COMPONENTS.Stream = {
    --- @param modelName string The name of the model.
    RequestModel = function(modelName)
        local modelHash = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
        if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
            RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do
                Citizen.Wait(1)
            end
        end
    end,

    --- @param dictName string The dictionary name of the model.
    RequestAnimDict = function(dictName)
        RequestAnimDict(dictName)
        while not HasAnimDictLoaded(dictName) do
            Citizen.Wait(100)
        end
    end,

    --- @param setName string The dictionary name of the model.
    RequestAnimSet = function(setName)
        RequestAnimSet(setName)
        while not HasAnimSetLoaded(setName) do
            Citizen.Wait(100)
        end
    end
}