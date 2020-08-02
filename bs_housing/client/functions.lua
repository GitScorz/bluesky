function Print3DText(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)

    if onScreen then
        local px, py, pz = table.unpack(GetGameplayCamCoords())
        local dist = #(vector3(px, py, pz) - vector3(coords.x, coords.y, coords.z))    
        local scale = (1 / dist) * 20
        local fov = (1 / GetGameplayCamFov()) * 100
        local scale = scale * fov   
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(250, 250, 250, 255)		-- You can change the text color here
        SetTextDropshadow(1, 1, 1, 1, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        SetDrawOrigin(coords.x, coords.y, coords.z, 0)
        DrawText(0.0, 0.0)
        ClearDrawOrigin()
    end
end

function comma_value(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function GenerateString(house)
    if house.locked then
        if _charData ~= nil and _charData.Job ~= nil then
            if _charData.Keys ~= nil and _charData.Keys[house.id] then
                return '[~b~E~s~] Enter ' .. house.label .. ' ~m~| ~s~[~b~G~s~] ~r~Locked'
            else
                for k, v in ipairs(Config.AutoKey) do
                    if _charData.Job.job == v then
                        if house.sold then
                            return '[~b~E~s~] Enter ' .. house.label .. ' ~m~| ~s~[~b~G~s~] ~r~Locked'
                        else
                            return '[~b~E~s~] Enter ' .. house.label .. ' ~m~| ~s~[~b~G~s~] ~r~Locked' .. ' ~m~| ~g~$~s~' .. comma_value(house.price)
                        end
                    end
                end
            end
        end

        if house.sold then
            return house.label .. ' ~m~| ~r~Locked'
        else
            return house.label .. ' ~m~| ~r~Locked' .. ' ~m~| ~g~$~s~' .. comma_value(house.price)
        end
    else
        if _charData ~= nil and _charData.Job ~= nil then
            if _charData.Keys ~= nil and _charData.Keys[house.id] then
                return '[~b~E~s~] Enter ' .. house.label .. ' ~m~| ~s~[~b~G~s~] ~g~Unlocked'
            else
                for k, v in ipairs(Config.AutoKey) do
                    if _charData.Job.job == v then
                        if house.sold then
                            return '[~b~E~s~] Enter ' .. house.label .. ' ~m~| ~s~[~b~G~s~] ~g~Unlocked'
                        else
                            return '[~b~E~s~] Enter ' .. house.label .. ' ~m~| ~s~[~b~G~s~] ~g~Unlocked' .. ' ~m~| ~g~$~s~' .. comma_value(house.price)
                        end
                    end
                end
            end
        end

        if house.sold then
            return house.label .. ' ~m~| ~g~Unlocked'
        else
            return house.label .. ' ~m~| ~g~Unlocked' .. ' ~m~| ~g~$~s~' .. comma_value(house.price)
        end
    end
end

function IsNearPlayerHouse()
    local shortest = 10000
    local nearest = nil
    local nearestBd = false
    local ply = PlayerPedId()
    for _, home in pairs(_properties) do
        local plyCoords = GetEntityCoords(ply, 0)
        local distance = #(vector3(home.location.front.x, home.location.front.y, home.location.front.z) - plyCoords)
        local distance2 = 1000

        if home.location.backdoor ~= nil then
            distance2 = #(vector3(home.location.backdoor.x, home.location.backdoor.y, home.location.backdoor.z) - plyCoords)
        end

        if (distance < distance2 and distance < shortest) then
            shortest = distance
            nearest = home
            nearestBd = false
        elseif (distance2 < distance and distance2 < shortest) then
            shortest = distance
            nearest = home
            nearestBd = true
        end
    end

    if shortest < 10 then
        return shortest, nearest, nearestBd
    end

    Citizen.Wait(math.floor(shortest))
end