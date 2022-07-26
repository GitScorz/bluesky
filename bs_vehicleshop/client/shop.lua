Dealers, Vehicles, spawned = {}, {}, {}
playerLoaded, displayedVeh = true, false

AddEventHandler('VehicleShop:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Logger = exports['bs_base']:FetchComponent('Logger')
    Callbacks = exports['bs_base']:FetchComponent('Callbacks')
    Utils = exports['bs_base']:FetchComponent('Utils')
    Game = exports['bs_base']:FetchComponent('Game')
    Menu = exports['bs_base']:FetchComponent('Menu')
    Notification = exports['bs_base']:FetchComponent('Notification')
    Action = exports['bs_base']:FetchComponent('Action')
    Blips = exports['bs_base']:FetchComponent('Blips')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['bs_base']:RequestDependencies('VehicleShop', {
        'Logger',
        'Callbacks',
        'Utils',
        'Game',
        'Menu',
        'Notification',
        'Action',
        'Blips'
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents() -- TODO: Move to client spawn
    end)
end)

function StartShit()
    Wait(1000)
    Callbacks:ServerCallback('VehicleShop:GetStuff', {}, function(dealers, cars)
        Dealers = dealers
        Vehicles = cars
        RegisterBlips()
        _character = exports['bs_base']:FetchComponent('Player').LocalPlayer:GetData('Character'):GetData()
        playerLoaded = true
        Citizen.CreateThread(function()
            while playerLoaded do
                GLOBAL_PED = PlayerPedId()
                Citizen.Wait(5000)
            end
        end)
        
        Citizen.CreateThread(function()
            while playerLoaded do
                if GLOBAL_PED then
                    GLOBAL_COORDS = GetEntityCoords(GLOBAL_PED)
                end
                Citizen.Wait(200)
            end
        end)

        Citizen.CreateThread(function()
            while playerLoaded do
                Citizen.Wait(200)
                if GLOBAL_COORDS and curShowroom then
                    for i = 1, #Dealers[curShowroom].showroomSpots do
                        if spawned[i] ~= nil and spawned[i].obj ~= 0 then
                            local pos = vector3(Dealers[curShowroom].showroomSpots[i].x, Dealers[curShowroom].showroomSpots[i].y, Dealers[curShowroom].showroomSpots[i].z)
                            local dist = #(pos - GLOBAL_COORDS)
                            if dist < 3.0 then
                                if not showingPrice then
                                    showingPrice = i
                                    local vehSpot = GetVehInSpot(curShowroom, i)
                                    Action:Show('<center><strong>' .. Dealers[curShowroom].showroom[vehSpot].data.name .. "<br><span style='color: #00FF00'>$" .. spawned[i].price .. '</span></strong></center>' )
                                end
                            elseif showingPrice == i then
                                showingPrice = false
                                Action:Hide()
                            end
                        end
                    end
                elseif not curShowroom and showingPrice then 
                    showingPrice = false
                    Action:Hide()
                end
            end
        end)
        
        Citizen.CreateThread(function()
            while playerLoaded do
                Citizen.Wait(200)
                if GLOBAL_COORDS then
                    for k,v in pairs(Dealers) do
                        for j,b in pairs(v.coords) do
                            local dist = #(GLOBAL_COORDS - vector3(b.x, b.y, b.z))
                            if j == 'standard' and dist <= 50.0 and not curShowroom then
                                curShowroom = k
                                SpawnShowroom(k)
                            elseif j == 'standard' and dist > 50.0 and (curShowroom == k or not curShowroom) then
                                RemoveShowroom()
                                curShowroom = false
                            end
                            if _character.Job.job == 'cardealer' and _character.Job.workplace.id == v.workplace then
                                if dist < Config.DrawDistance then
                                    if not showing then
                                        showing = k..j
                                        ShowAction(j, showing)
                                    end
                                elseif showing == k..j then
                                    showing = false
                                    Action:Hide()
                                end
                            end
                        end
                    end
                end
            end
        end)
    end)
end

AddEventHandler('Characters:Client:Spawn', function()
    StartShit()
end)

RegisterNetEvent('Characters:Client:Updated')
AddEventHandler('Characters:Client:Updated', function()
    _character = exports['bs_base']:FetchComponent('Player').LocalPlayer:GetData('Character'):GetData()
    showing = false
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    RemoveShowroom()
    playerLoaded = false
end)

function RegisterBlips()
    while Dealers[1] == nil do Wait(10); end
    for k,v in pairs(Dealers) do
        Blips:Add('dealership-'..v._id, v.name, vector3(v.coords.standard.x, v.coords.standard.y, v.coords.standard.z), Config.Blips[v.type].blipSprite, Config.Blips[v.type].blipColor, 0.8)
    end
end

function ShowAction(type, var)
    local title, message = "", ""
    if type == 'duty' then
        message = "Press {key}E{/key} to sign on duty"
    elseif type ~= 'bossmenu' and type == 'dealer' then
        title = "<strong>Dealer Menu</strong><br>"
        message = "Press {key}E{/key} to open"
    elseif type == 'bossmenu' then
        title = "<strong>Boss Menu</strong><br>"
        message = "Press {key}E{/key} to open"
    end

    if title ~= "" or message ~= "" then Action:Show("<center>" .. title .. message .. "</center>") end

    Citizen.CreateThread(function()
        while showing == var do
            Citizen.Wait(1)
            if IsControlJustPressed(0, 38) then
                if type == 'duty' then
                    print('toggle duty')
                elseif type == 'dealer' then
                    OpenDealerMenu()
                elseif type == 'bossmenu' then
                    print('boss menu')
                end
            end
        end
    end)
end

function GetVehInSpot(dealer, spot)
    if Utils:GetTableLength(Dealers[dealer].showroom) > 0 then
        for k,v in pairs(Dealers[dealer].showroom) do
            if v.spot == spot then
                return k
            end
        end
    end
    return false
end