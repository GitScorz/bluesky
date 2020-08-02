COMPONENTS.Stream = {
    _protected = true,
    _name = 'base',
}

COMPONENTS.Stream = {
    RequestModel = function(modelName)
        local modelHash = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
        if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
            RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do
                Citizen.Wait(1)
            end
        end
    end,
    RequestAnimDict = function(dictName)
        RequestAnimDict(dictName)
        while not HasAnimDictLoaded(dictName) do
            Citizen.Wait(100)
        end
    end,
    RequestAnimSet = function(setName)
        RequestAnimSet(setName)
        while not HasAnimSetLoaded(setName) do
            Citizen.Wait(100)
        end
    end
}