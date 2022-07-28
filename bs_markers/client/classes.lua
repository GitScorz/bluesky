--- @param name string @The name of the marker.
--- @param pos vector3 @The position of the marker.
--- @param color table @The color of the marker.
function MarkerGroup(name, coords, distance)
    return {
        name = name,
        coords = coords,
        distance = distance,
        markers = {}
    }
end

--- @param groupName string @The name of the group.
--- @param id string @The id of the marker.
--- @param coords vector3 @The position of the marker.
--- @param type string @The type of the marker.
--- @param scale number @The scale of the marker.
--- @param colour table @The color of the marker.
--- @param shouldShow boolean @Should the marker be shown?
--- @param hint string @The hint of the marker.
--- @param distance number @The distance of the marker.
--- @param action string @The action of the marker.
function Marker(groupName, id, coords, type, scale, colour, shouldShow, hint, distance, action)
    return {
        groupName = groupName,
        id = id,
        coords = coords,
        type = type,
        scale = scale,
        colour = colour,
        shouldShow = shouldShow,
        show = false,
        hint = hint,
        distance = distance,
        action = action,
        draw = true
    }
end

--- @param groupName string @The name of the group.
--- @param id string @The id of the marker.
--- @param name string @The name of the marker.
--- @param coords vector3 @The position of the marker.
--- @param hint string @The hint of the marker.
--- @param distance number @The distance of the marker.
--- @param shouldShow boolean @Should the marker be shown?
--- @param action string @The action of the marker.
function ItemMarker(groupName, id, name, coords, hint, distance, shouldShow, action)
    return {
        groupName = groupName,
        id = id,
        hint = hint,
        itemName = name,
        coords = coords,
        distance = distance,
        shouldShow = shouldShow,
        action = action,
        draw = false
    }
end