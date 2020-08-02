local _retrieved = false

Citizen.CreateThread(function()
    while Callbacks == nil do
        Citizen.Wait(10)
    end

    Callbacks:ServerCallback('Housing:GetProperties', {}, function(properties)
        _properties = properties
        _retrieved = true
    end)
end)

Citizen.CreateThread(function()
    while not _retrieved do
        Citizen.Wait(100)
    end

    while true do
        local player = PlayerPedId()
        local distance, nearest, isBackdoor = IsNearPlayerHouse()
        if nearest ~= nil then
            print(nearest.location.backdoor)
            if not isBackdoor then
                DrawMarker(25, nearest.location.front.x, nearest.location.front.y, nearest.location.front.z - 0.99, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 1.0, 139, 16, 20, 250, false, false, 2, false, false, false, false)
            elseif nearest.location.backdoor ~= nil
                DrawMarker(25, nearest.location.backdoor.x, nearest.location.backdoor.y, nearest.location.backdoor.z - 0.99, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 1.0, 139, 16, 20, 250, false, false, 2, false, false, false, false)
            end

            if distance < 2.0 then
                if not isBackdoor then
                    Print3DText(nearest.location.front, GenerateString(nearest))
                else
                    Print3DText(nearest.location.backdoor, GenerateString(nearest))
                end

                if IsControlJustReleased(1, 51) then
                    if not IsPedInAnyVehicle(player, true) then
                        Housing:Enter(nearest, isBackdoor)
                    end
                elseif IsControlJustReleased(1,47) then
                    Callbacks:ServerCallback('Housing:ToggleLock', nearest.id, function(status)
                        if status then
                            Notification:Info('House Locked')
                        else
                            Notification:Info('House Unlocked')
                        end
                    end)
                end
            end
        end

        Citizen.Wait(1)
    end
end)