local Logger
local Notifications
local UI = nil

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Markers', MARKERS)
end)

AddEventHandler('Markers:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Logger = exports['bs_base']:FetchComponent('Logger')
    Notifications = exports['bs_base']:FetchComponent('Notifications')
    UI = exports['bs_base']:FetchComponent('UI')
end

AddEventHandler('Core:Shared:Ready', function()
    markerGroups = {}
    withinDistanceGroups = {}
    exports['bs_base']:RequestDependencies('Markers', {
        'Logger',
        'Notifications',
        'UI',
    }, function(error)
        if #error > 0 then
            return ;
        end
        RetrieveComponents()
    end)
end)

local markerGroups = {}
local withinDistanceGroups = {}

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler("Characters:Client:Logout", function()
    markerGroups = {}
    withinDistanceGroups = {}
end)

MARKERS = {
    MarkerGroups = {
        Add = function(self, groupName, groupCoords, groupDistance)
            if groupName == "" or groupName == nil or type(groupName) ~= 'string' then
                Logger:Error('Markers', 'Invalid Group Name for Marker Group: ' .. tostring(groupName))
                return
            end

            if groupCoords == nil then
                Logger:Error('Markers', 'Invalid Group Coords for Marker Group: ' .. tostring(groupName))
                return
            end

            if type(groupCoords) == 'table' then
                groupCoords = vector3(groupCoords.x, groupCoords.y, groupCoords.z)
            end

            if groupDistance == nil or type(groupDistance) ~= 'number' then
                Logger:Error('Markers', 'Invalid Group Distance for Marker Group: ' .. tostring(groupName))
                return
            end
            markerGroups[groupName] = MarkerGroup(groupName, groupCoords, groupDistance)
            withinDistanceGroups[groupName] = nil
        end,
        Remove = function(self, groupName)
            if markerGroups[groupName] == nil then
                Logger:Error('Markers', 'Attempting to remove non-existent Marker Group: ' .. tostring(groupName))
                return
            end
            markerGroups[groupName] = nil
            withinDistanceGroups[groupName] = nil
        end,
        Update = function(self, groupName, groupCoords, groupDistance)
            if groupName == "" or groupName == nil or type(groupName) ~= 'string' then
                Logger:Error('Markers', 'Invalid Group Name for Marker Group: ' .. tostring(groupName))
                return
            end

            if groupCoords == nil then
                Logger:Error('Markers', 'Invalid Group Coords for Marker Group: ' .. tostring(groupName))
                return
            end
            local markers = markerGroups[groupName].markers
            markerGroups[groupName] = MarkerGroup(groupName, groupCoords, groupDistance)
            markerGroups[groupName].markers = markers
        end
    },
    Markers = {
        Refresh = function(self)
            withinDistanceGroups = {}
        end,
        Add = function(self, groupName, markerId, markerCoords, markerType, markerScale, markerColor, shouldMarkerShow, hint, interfuckingactiondistance, action)
            if markerGroups[groupName] == nil then
                Logger:Error('Markers', 'Invalid Group for Marker: ' .. tostring(groupName))
                return
            end

            if markerGroups[groupName].markers[markerId] ~= nil then
                Logger:Error('Markers', 'Marker Already Exists: ' .. tostring(markerId))
                return
            end

            if markerCoords == nil then
                Logger:Error('Markers', 'Invalid Marker Coords for Marker: ' .. tostring(markerCoords))
                return
            end

            if type(markerCoords) == 'table' then
                markerCoords = vector3(markerCoords.x, markerCoords.y, markerCoords.z)
            end

            if markerType == nil or type(markerType) ~= 'number' then
                Logger:Error('Markers', 'Invalid Marker Type for Marker: ' .. tostring(markerId))
                return
            end

            if markerColor == nil or type(markerColor) ~= 'table' then
                Logger:Error('Markers', 'Invalid Marker Color for Marker: ' .. tostring(markerId))
                return
            end

            if shouldMarkerShow == nil or type(shouldMarkerShow) ~= 'table' then
                Logger:Error('Markers', 'Invalid Marker shouldMarkerShow for Marker: ' .. tostring(markerId))
                return
            end

            if markerCoords == nil then
                Logger:Error('Markers', 'Invalid Group Coords for Marker Group: ' .. tostring(groupName))
                return
            end
            withinDistanceGroups[groupName] = nil
            markerGroups[groupName].markers[markerId] = Marker(groupName, markerId, markerCoords, markerType, markerScale, markerColor, shouldMarkerShow, hint, interfuckingactiondistance, action)
        end,
        ItemAdd = function(self, groupName, markerId, itemName, markerCoords, hint, distance, shouldMarkerShow, action)
            if markerGroups[groupName] == nil then
                Logger:Error('Markers', 'Invalid Group for Item Marker: ' .. tostring(groupName))
                return
            end
            if markerGroups[groupName].markers[markerId] ~= nil then
                Logger:Error('Markers', 'Item Marker Already Exists: ' .. tostring(markerId))
                return
            end
            if itemName == nil then
                Logger:Error('Markers', 'Invalid Item for Item Marker: ' .. tostring(itemName))
                return
            end

            if markerCoords == nil then
                Logger:Error('Markers', 'Invalid Marker Coords for Item Marker: ' .. tostring(markerCoords))
                return
            end

            if type(markerCoords) == 'table' then
                markerCoords = vector3(markerCoords.x, markerCoords.y, markerCoords.z)
            end

            if type(distance) ~= 'number' then
                Logger:Error('Markers', 'Invalid Distance Item Marker: ' .. tostring(markerCoords))
                return
            end

            if shouldMarkerShow == nil or type(shouldMarkerShow) ~= 'table' then
                Logger:Error('Markers', 'Invalid Marker shouldMarkerShow for Item Marker: ' .. tostring(markerId))
                return
            end
            markerGroups[groupName].markers[markerId] = ItemMarker(groupName, markerId, itemName, markerCoords, hint, distance, shouldMarkerShow, action)
        end,
        Remove = function(self, groupName, markerId)
            if markerGroups[groupName] == nil then
                Logger:Error('Markers', 'Invalid Group for Marker: ' .. tostring(groupName))
                return
            end

            if markerGroups[groupName].markers[markerId] == nil then
                Logger:Error('Markers', 'Attempting to remove non-existent Marker: ' .. tostring(markerId))
                return
            end
            markerGroups[groupName].markers[markerId] = nil
        end,
        Update = function(self, groupName, markerId, markerCoords, markerType, markerScale, markerColor, shouldMarkerShow, hint, interfuckingactiondistance, action)
            if markerGroups[groupName] == nil then
                Logger:Error('Markers', 'Invalid Group for Marker: ' .. tostring(groupName))
                return
            end

            if markerGroups[groupName].markers[markerId] == nil then
                Logger:Error('Markers', 'Attempting to update non-existent Marker: ' .. tostring(markerId))
                return
            end

            if markerCoords == nil then
                Logger:Error('Markers', 'Invalid Marker Coords for Marker: ' .. tostring(markerCoords))
                return
            end

            if markerType == nil or type(markerType) ~= 'number' then
                Logger:Error('Markers', 'Invalid Marker Type for Marker: ' .. tostring(markerId))
                return
            end

            if markerColor == nil or type(markerColor) ~= 'table' then
                Logger:Error('Markers', 'Invalid Marker Color for Marker: ' .. tostring(markerId))
                return
            end

            if shouldMarkerShow == nil or type(shouldMarkerShow) ~= 'function' then
                Logger:Error('Markers', 'Invalid Marker shouldMarkerShow for Marker: ' .. tostring(shouldMarkerShow))
                return
            end

            if markerCoords == nil then
                Logger:Error('Markers', 'Invalid Group Coords for Marker Group: ' .. tostring(groupName))
                return
            end
            markerGroups[groupName].markers[markerId] = Marker(groupName, markerId, markerCoords, markerType, markerScale, markerColor, shouldMarkerShow, hint, interfuckingactiondistance, action)
        end
    }
}

local HasAlreadyEnteredMarker
local CurrentMarker

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        for groupName, group in pairs(markerGroups) do
            local distance = #(playerCoords - group.coords)
            if withinDistanceGroups[groupName] ~= nil then
                if distance > group.distance then
                    withinDistanceGroups[groupName] = nil
                end
            else
                if distance < group.distance then
                    withinDistanceGroups[groupName] = group
                    for k, v in pairs(withinDistanceGroups[groupName].markers) do
                        v.show = v.shouldShow()
                    end
                end
            end
        end
        Citizen.Wait(100)
        local isInMarker = false
        local lastMarker
        for groupName, group in pairs(withinDistanceGroups) do
            for markerId, marker in pairs(group.markers) do
                local distance = #(playerCoords - marker.coords)
                print(json.encode(marker.distance))
                if distance < marker.distance then
                    marker.show = marker.shouldShow()
                    if marker.show then
                        isInMarker = true
                        lastMarker = marker
                    end
                else
                    marker.show = false
                end
            end
        end
        if isInMarker then
            CurrentMarker = lastMarker
        end
        if not hasExited and not isInMarker then
            CurrentMarker = nil
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        for _, group in pairs(withinDistanceGroups) do
            for _, marker in pairs(group.markers) do
                if marker.show and marker.draw then
                    DrawMarker(marker.type, marker.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, marker.scale.x, marker.scale.y, marker.scale.z, marker.colour.r, marker.colour.g, marker.colour.b, 100, false, true, 2, false, false, false, false)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    local showing = false
    while true do
        Citizen.Wait(0)
        if CurrentMarker and CurrentMarker.show then
            if not showing then
                UI.Action:Show(CurrentMarker.hint or "This Hint is Empty")
                showing = true
            end
            if CurrentMarker.show and CurrentMarker.draw and IsControlJustReleased(0, 38) then
                if CurrentMarker.action ~= nil then
                    CurrentMarker.action(CurrentMarker)
                end
            end
        else
            if showing then
                UI.Action:Hide()
                showing = false
            end
        end
    end
end)

RegisterNetEvent('Markers:ItemAction')
AddEventHandler('Markers:ItemAction', function(item)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    for groupName, group in pairs(withinDistanceGroups) do
        for markerId, marker in pairs(group.markers) do
            if marker.show and not marker.draw and marker.itemName == item.Name then
                local distance = #(playerCoords - marker.coords)
                if distance < marker.distance then
                    marker.action(item)
                end
            end
        end
    end
end)
