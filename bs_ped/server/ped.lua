Database = nil
Callbacks = nil

local TemplateData = {
    model = '',
    customization = {
        face = {
            face1 = {
                index = 0,
                texture = 0,
                mix = 50.0
            },
            face2 = {
                index = 0,
                texture = 0,
                mix = 50.0
            },
            features = {
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
            },
        },
        overlay = {
            blemish = {
                id = 0,
                index = 0,
                opacity = 100.0,
                disabled = true
            },
            facialhair = {
                id = 1,
                index = 0,
                opacity = 100.0,
                disabled = true
            },
            eyebrows = {
                id = 2,
                index = 0,
                opacity = 100.0,
                disabled = true
            },
            ageing = {
                id = 3,
                index = 0,
                opacity = 100.0,
                disabled = true
            },
            makeup = {
                id = 4,
                index = 0,
                opacity = 100.0,
                disabled = true
            },
            blush = {
                id = 5,
                index = 0,
                opacity = 100.0,
                disabled = true
            },
            complexion = {
                id = 6,
                index = 0,
                opacity = 100.0,
                disabled = true
            },
            sundamage = {
                id = 7,
                index = 0,
                opacity = 100.0,
                disabled = true
            },
            lipstick = {
                id = 8,
                index = 0,
                opacity = 100.0,
                disabled = true
            },
            freckles = {
                id = 9,
                index = 0,
                opacity = 100.0,
                disabled = true
            },
            chesthair = {
                id = 10,
                index = 0,
                opacity = 100.0,
                disabled = true
            },
            bodyblemish = {
                id = 11,
                index = 0,
                opacity = 100.0,
                disabled = true
            },
            addbodyblemish = {
                id = 12,
                index = 0,
                opacity = 100.0,
                disabled = true
            },
        },
        colors = {
            hair = {
                color1 = {
                    index = 0,
                    rgb = "rgb(0, 0, 0)"
                },
                color2 = {
                    index = 0,
                    rgb = "rgb(0, 0, 0)"
                }
            },
            facialhair = {
                color1 = {
                    index = 0,
                    rgb = "rgb(0, 0, 0)"
                },
                color2 = {
                    index = 0,
                    rgb = "rgb(0, 0, 0)"
                }
            },
            chesthair = {
                color1 = {
                    index = 0,
                    rgb = "rgb(0, 0, 0)"
                },
                color2 = {
                    index = 0,
                    rgb = "rgb(0, 0, 0)"
                }
            }
        },
        components = {
            face = {
                componentId = 0,
                drawableId = 0,
                textureId = 0,
                paletteId = 0,
            },
            mask = {
                componentId = 1,
                drawableId = 0,
                textureId = 0,
                paletteId = 0,
            },
            hair = {
                componentId = 2,
                drawableId = 0,
                textureId = 0,
                paletteId = 0,
            },
            torso = {
                componentId = 3,
                drawableId = 0,
                textureId = 0,
                paletteId = 0,
            },
            leg = {
                componentId = 4,
                drawableId = 0,
                textureId = 0,
                paletteId = 0,
            },
            bag = {
                componentId = 5,
                drawableId = 0,
                textureId = 0,
                paletteId = 0,
            },
            shoes = {
                componentId = 6,
                drawableId = 0,
                textureId = 0,
                paletteId = 0,
            },
            accessory = {
                componentId = 7,
                drawableId = 0,
                textureId = 0,
                paletteId = 0,
            },
            undershirt = {
                componentId = 8,
                drawableId = 0,
                textureId = 0,
                paletteId = 0,
            },
            kevlar = {
                componentId = 9,
                drawableId = 0,
                textureId = 0,
                paletteId = 0,
            },
            badge = {
                componentId = 10,
                drawableId = 0,
                textureId = 0,
                paletteId = 0,
            },
            torso2 = {
                componentId = 11,
                drawableId = 0,
                textureId = 0,
                paletteId = 0,
            },
        },
        props = {
            hat = {
                componentId = 0,
                drawableId = 0,
                textureId = 0,
                disabled = true
            },
            glass = {
                componentId = 1,
                drawableId = 0,
                textureId = 0,
                disabled = true
            },
            ear = {
                componentId = 2,
                drawableId = 0,
                textureId = 0,
                disabled = true
            },
            watch = {
                componentId = 6,
                drawableId = 0,
                textureId = 0,
                disabled = true
            },
            bracelet = {
                componentId = 7,
                drawableId = 0,
                textureId = 0,
                disabled = true
            }
        }
    }
}

AddEventHandler('Ped:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Database = exports['bs_base']:FetchComponent('Database')
    Clotheshop = exports['bs_base']:FetchComponent('Clotheshop')
    Locations = exports['bs_base']:FetchComponent('Locations')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('Ped', {
        'Callbacks',
        'Database',
        'Clotheshop',
        'Locations',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        RegisterCallbacks()
    end)
end)

function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Ped:CheckPed', function(source, data, cb)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        local char = player:GetData('Character')
        Database.Game:findOne({
            collection = 'peds',
            query = {
                Char = char:GetData('ID')
            }
        }, function(success, results)
            if not success then
                return
            end
            if #results == 0 then
                TriggerClientEvent('Ped:Client:SetPedData', source, TemplateData)
                cb(false)
            else
                TriggerClientEvent('Ped:Client:SetPedData', source, results[1].Ped)
                cb(true)
            end
        end)
    end)
    Callbacks:RegisterServerCallback('Ped:SavePed', function(source, data, cb)
        local player = exports['bs_base']:FetchComponent('Fetch'):Source(source)
        local char = player:GetData('Character')
        Database.Game:findOne({
            collection = 'peds',
            query = {
                Char = char:GetData('ID')
            }
        }, function(success, results)
            if not success then
                return
            end
            if #results == 0 then
                local doc = {
                    Char = char:GetData('ID'),
                    Ped = data.ped
                }
                Database.Game:insertOne({
                    collection = 'peds',
                    document = doc
                }, function(success, results)
                    if not success then
                        return
                    end
                    cb(results > 0)
                end)
            else
                Database.Game:updateOne({
                    collection = 'peds',
                    query = {
                        Char = char:GetData('ID')
                    },
                    update = {
                        ['$set'] = {
                            Ped = data.ped
                        }
                    }
                }, function(success, results)
                    if not success then
                        return
                    end
                    cb(results > 0)
                end)
            end
        end)
    end)
end