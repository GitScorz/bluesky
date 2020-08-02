local atmModels = {
    [-1126237515] = true,
    [506770882] = true,
    [-1364697528] = true,
    [-870868698] = true,
}

function FindNearestATM()
    local coords = GetEntityCoords(PlayerPedId())
    local atms = {}
    local handle, object = FindFirstObject()
    local success

    repeat
        if atmModels[GetEntityModel(object)] then
            table.insert(atms, object)
        end

        success, object = FindNextObject(handle, object)
    until not success

    EndFindObject(handle)

    local atmObject = 0
    local atmDistance = 1000

    for k,v in pairs(atms) do

        local dstcheck = #(vector3(coords.x, coords.y, coords.z) - GetEntityCoords(v))

        if dstcheck < atmDistance then
            atmDistance = dstcheck
            atmObject = v
        end
    end

    return atmObject, atmDistance
end