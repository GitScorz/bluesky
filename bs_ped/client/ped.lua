AddEventHandler('Ped:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    UISounds = exports['bs_base']:FetchComponent('UISounds')
    Spawn = exports['bs_base']:FetchComponent('Spawn')
    Ped = exports['bs_base']:FetchComponent('Ped')
    Creator = exports['bs_base']:FetchComponent('Creator')
    Clotheshop = exports['bs_base']:FetchComponent('Clotheshop')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Ped', {
        'Callbacks',
        'UISounds',
        'Spawn',
        'Ped',
        'Creator',
        'Clotheshop',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
    end)
end)

FROZEN = false

PED = {
    _required = {},
    ApplyToPed = function(self, ped)
        local playerPed = PlayerPedId()
        SetPedHeadBlendData(
                playerPed,
                ped.customization.face.face1.index,
                ped.customization.face.face2.index,
                0,
                ped.customization.face.face1.texture,
                ped.customization.face.face2.texture,
                0,
                (ped.customization.face.face1.mix / 100) + 0.0,
                (ped.customization.face.face2.mix / 100) + 0.0,
                0,
                false
        )
        for index, value in ipairs(ped.customization.face.features) do
            SetPedFaceFeature(playerPed, index, (value / 100) + 0.0)
        end
        for k, value in pairs(ped.customization.overlay) do
            if value.disabled then
                SetPedHeadOverlay(playerPed, value.id, 255, (value.opacity / 100) + 0.0)
            else
                SetPedHeadOverlay(playerPed, value.id, value.index, (value.opacity / 100) + 0.0)
            end
        end
        for k, component in pairs(ped.customization.components) do
            SetPedComponentVariation(playerPed, component.componentId, component.drawableId, component.textureId, component.paletteId)
        end
        SetPedHairColor(playerPed, ped.customization.colors.hair.color1.index, ped.customization.colors.hair.color2.index)
        SetPedHeadOverlayColor(playerPed, 1, 1, ped.customization.colors.facialhair.color1.index, ped.customization.colors.facialhair.color2.index)
        for k, prop in pairs(ped.customization.props) do
            if prop.disabled then
                ClearPedProp(playerPed, prop.componentId)
            else
                SetPedPropIndex(playerPed, prop.componentId, prop.drawableId, prop.textureId)
            end
        end
    end
}
LocalPed = {}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['bs_base']:RegisterComponent('Ped', PED)
end)

RegisterNetEvent('Ped:Client:SetPedData')
AddEventHandler('Ped:Client:SetPedData', function(data)
    LocalPed = data
    SendNUIMessage({
        type = "SET_PED_DATA";
        data = {
            ped = data
        }
    })
end)
