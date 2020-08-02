function MarkerGroup(name, coords, distance)
    return {
        name = name,
        coords = coords,
        distance = distance,
        markers = {}
    }
end

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