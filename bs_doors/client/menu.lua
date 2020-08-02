addingDoor, selectedObject = false, false

function LoadMulti(sets)
    local menu = Menu:Create('multiId', 'Multi Door Setup')
    menu.Add:Number('Last inserted door ID: ' .. GetLastTableElement(doors), {}, function(data)
        sets.multi = data.data.value or 0
    end)
    sets.sameSettings = false
    menu.Add:CheckBox('Use same settings as that door?', { 
        checked = false
    }, function(data)
        sets.sameSettings = not sets.sameSettings
    end)
    menu.Add:Button('Confirm', {}, function()
        LoadStatic(sets, menu)
    end)
    menu:Show()
end

function LoadStatic(sets, men)
    if sets.sameSettings then
        AddDoor(sets, men)
    else
        local menu = Menu:Create('authType', 'Authorization')

        menu.Add:Button('Static State (no lock change)', {}, function(data)
            sets.static = true
            AddDoor(sets, men)
        end)

        menu.Add:Button('Dynamic State (job auths)', {}, function(data)
            sets.static = false
            LoadJobs(sets, men)
        end)        

        menu:Show()
    end
end

function AddDoor(sets, men)
    sets.multi = tonumber(sets.multi)
    if sets.sameSettings and sets.multi > 0 then
        if doors[sets.multi] then
            sets.lock = doors[sets.multi].Lock
            sets.defaultLock = doors[sets.multi].DefaultLock
            sets.privacy = doors[sets.multi].Public
            sets.draw = doors[sets.multi].DrawDistance
            sets.auth = doors[sets.multi].Auth
            sets.static = doors[sets.multi].Static
            sets.lockpickable = doors[sets.multi].Lockpickable
        else
            Notification:Error('Multi Door ID not found')
            return
        end
    end
    Callbacks:ServerCallback('Doors:Add', {
        settings = sets
    }, function(done)
        if done then
            Notification:Success('Added door')
        else
            Notification:Error('Failed to add door')
        end
    end)

    men:Close()
end

function SetDuty(jobs, sets)
    local menu = Menu:Create('dutyNeeded', 'Set Duty Needed')
    if sets.auth and Utils:GetTableLength(sets.auth) > 0 then
        for k,v in pairs(sets.auth) do
            menu.Add:Select('Duty needed for ' .. jobs[v.job].label, {
                disabled = false,
                current = true,
                list = {
                    { ['label'] = "Yes", ['value'] = true },
                    { ['label'] = "No", ['value'] = false }
                }
            }, function(data)
                sets.auth[k].dutyNeeded = data.data.value
            end)
        end
        menu.Add:Button('Next', { success = true }, function(data)
            for k,v in pairs(sets.auth) do
                if v.dutyNeeded == nil then v.dutyNeeded = true; end                    
            end
            AddDoor(sets, menu)
        end)
        menu:Show()
    end
end

function SetGrades(jobs, sets)
    local menu = Menu:Create('grades', 'Set Minimum Grades')
    if sets.auth and Utils:GetTableLength(sets.auth) > 0 then
        for k,v in pairs(sets.auth) do
            local grades = {}
            table.insert(grades, { ['label'] = "Select", ['value'] = -1, ['level'] = -1 })
            for j,b in pairs(jobs[v.job].grades) do
                table.insert(grades, { ['label'] = "[" .. b.level .. "] " .. b.label .. " [" .. j .. "]", ['value'] = b.level, ['level'] = b.level })
            end
            table.sort(grades, function(a,b) return a.level < b.level end)

            menu.Add:Select('Select Min Grade', {
                disabled = false,
                current = -1,
                list = grades
            }, function(data)
                sets.auth[k].grade = data.data.value
            end)
        end
        menu.Add:Button('Next', { success = true }, function(data)
            for k,v in pairs(sets.auth) do
                if not v.grade or v.grade == -1 then
                    Notification:Error('Failed to select one or more grades')
                    return
                end
            end
            SetDuty(jobs, sets)
        end)
        menu:Show()
    end
end

function SetWorkplaces(jobs, picked, sets, men)
    local function exists(job)
        local count = 0
        local lastfound = 0
        for k,v in pairs(picked) do
            if v.job == job then
                count = count + 1
                if count > 1 then picked[k] = nil; end
            end
        end
    end

    if Utils:GetTableLength(picked) > 0 then
        local menu = Menu:Create('workplaces', 'Set Workplaces')
        for k,v in pairs(picked) do
            exists(v.job)
            local workplaces = {}
            table.insert(workplaces, { label = "Accessed by all workplaces", value = 0 })
            if jobs[v.job].workplaces and Utils:GetTableLength(jobs[v.job].workplaces) > 0 then
                for i = 1, Utils:GetTableLength(jobs[v.job].workplaces) do
                    table.insert(workplaces, { label = jobs[v.job].workplaces[i] .. " (ID: " .. i .. ")", value = i })
                end
                table.sort(workplaces, function(a,b) return a.value < b.value end)
            end
            menu.Add:Select('Select Workplace for ' .. jobs[v.job].label, {
                disabled = false,
                current = 0,
                list = workplaces
            }, function(data)
                picked[k] = { ['job'] = v.job, ['workplace'] = data.data.value }
            end)
        end
        menu.Add:Button('Next', { success = true }, function(data)
            for k,v in pairs(picked) do
                if v.workplace == nil then v.workplace = 0; end
            end
            sets.auth = picked
            SetGrades(jobs, sets)
        end)
        menu:Show()
    end
end

function LoadJobs(sets, men)
    if sets.sameSettings then
        AddDoor(sets, men)
    else
        Callbacks:ServerCallback('Doors:GetJobs', {}, function(jobs)
            if jobs then
                local menu = Menu:Create('jobs', 'Job Authorization')
                local jobTable = {}
                table.insert(jobTable, { label = "None", value = 0 })
                for k,v in pairs(jobs) do
                    table.insert(jobTable, { label = v.label, value = k })
                end

                local pickedJobs = {}
                for i = 1, Config.MaxAuthed do
                    menu.Add:Select('Select Job #' .. i, {
                        disabled = false,
                        current = 0,
                        list = jobTable
                    }, function(data)
                        pickedJobs[i] = { ['job'] = data.data.value }
                    end)
                end
                
                menu.Add:Button('Confirm', { success = true }, function(data)
                    SetWorkplaces(jobs, pickedJobs, sets, men)
                end)
                menu:Show()
            end
        end)
    end
end

function AdjustDoor(door, setting, value)
    Callbacks:ServerCallback('Doors:AdjustSettings', {
        door = doors[door].id,
        setting = setting,
        value = value
    }, function(done)
        if done then
            Notification:Success('Door updated')
        else
            Notification:Error('Error updating Door')
        end
        SettingsMenu(door)
    end)
end

function EditAuthFieldWP(jobs, auth, door)
    local menu = Menu:Create('editFieldWP'..auth, 'Edit Authorization')
    local curAuth = doors[door].Auth[auth]
    
    local workplaces = {}
    table.insert(workplaces, { label = "Accessed by all workplaces", value = 0 })
    if jobs[curAuth.job].workplaces and Utils:GetTableLength(jobs[curAuth.job].workplaces) > 0 then
        for i = 1, Utils:GetTableLength(jobs[curAuth.job].workplaces) do
            table.insert(workplaces, { label = jobs[curAuth.job].workplaces[i] .. " (ID: " .. i .. ")", value = i })
        end
        table.sort(workplaces, function(a,b) return a.value < b.value end)
    end
    menu.Add:Select('Select Workplace for ' .. jobs[curAuth.job].label, {
        disabled = false,
        current = 0,
        list = workplaces
    }, function(data)
        doors[door].Auth[auth].workplace = data.data.value
        AdjustDoor(door, 'Auth', doors[door].Auth)
    end)

    menu.Add:SubMenuBack('Back')
    return menu
end

function EditAuthFieldGrade(jobs, auth, door)
    local menu = Menu:Create('editFieldGrade'..auth, 'Edit Authorization')
    local curAuth = doors[door].Auth[auth]
    
    local grades = {}
    table.insert(grades, { ['label'] = "Select", ['value'] = -1, ['level'] = -1 })
    for j,b in pairs(jobs[curAuth.job].grades) do
        table.insert(grades, { ['label'] = "[" .. b.level .. "] " .. b.label .. " [" .. j .. "]", ['value'] = b.level, ['level'] = b.level })
    end
    table.sort(grades, function(a,b) return a.level < b.level end)
    menu.Add:Select('Select Min Grade', {
        disabled = false,
        current = -1,
        list = grades
    }, function(data)
        if data.data.value == -1 then Notification:Error('Select a grade'); return end
        doors[door].Auth[auth].grade = data.data.value
        AdjustDoor(door, 'Auth', doors[door].Auth)
    end)
    
    menu.Add:SubMenuBack('Back')
    return menu
end

function EditAuthFieldJob(jobs, auth, door)
    local menu = Menu:Create('editFieldJob'..auth, 'Edit Authorization')
    local curAuth = doors[door].Auth[auth]

    local jobTable = {}
    for k,v in pairs(jobs) do
        table.insert(jobTable, { label = v.label, value = k })
    end
    menu.Add:Select('Select Job', {
        disabled = false,
        current = curAuth.job,
        list = jobTable
    }, function(data)
        doors[door].Auth[auth].job = data.data.value
        doors[door].Auth[auth].workplace = 0
        AdjustDoor(door, 'Auth', doors[door].Auth)
    end)
        
    menu.Add:SubMenuBack('Back')
    return menu
end

function EditThisAuth(jobs, auth, door)
    local menu = Menu:Create('editAuth'..auth, 'Edit Authorization')
    local curAuth = doors[door].Auth[auth]
    menu.Add:SubMenu('Change Job: ' .. jobs[curAuth.job].label, EditAuthFieldJob(jobs, auth, door))
    menu.Add:SubMenu('Change Grade: ' .. curAuth.grade, EditAuthFieldGrade(jobs, auth, door))
    menu.Add:SubMenu('Change Workplace: ' .. curAuth.workplace, EditAuthFieldWP(jobs, auth, door))
    menu.Add:Select('Change Duty Needed', {
        disabled = false,
        current = curAuth.dutyNeeded,
        list = {
            { label = 'Yes', value = true },
            { label = 'No', value = false },
        }
    }, function(data)
        doors[door].Auth[auth].dutyNeeded = data.data.value
        AdjustDoor(door, 'Auth', doors[door].Auth)
    end)
    if Utils:GetTableLength(doors[door].Auth) > 1 then
        menu.Add:SubMenuBack('Delete Auth', {}, function(data)
            doors[door].Auth[auth] = nil
            AdjustDoor(door, 'Auth', doors[door].Auth)
            menu:Close()
            Wait(50)
            ManageDoorMenu(door)
        end)
    end
    menu.Add:SubMenuBack('Back')
    return menu
end

function NewAuthDuty(jobs, pickedJob, door)
    local menu = Menu:Create('newauthduty', 'New Authorization')
    menu.Add:Select('Duty needed for ' .. jobs[pickedJob.job].label, {
        disabled = false,
        current = true,
        list = {
            { ['label'] = "Yes", ['value'] = true },
            { ['label'] = "No", ['value'] = false }
        }
    }, function(data)
        pickedJob.dutyNeeded = data.data.value
    end)

    menu.Add:Button('Save Auth', { success = true }, function(data)
        table.insert(doors[door].Auth, { ['job'] = pickedJob.job, ['grade'] = pickedJob.grade, ['workplace'] = pickedJob.workplace or 0, ['dutyNeeded'] = pickedJob.dutyNeeded or true })
        AdjustDoor(door, 'Auth', doors[door].Auth)
        ManageDoorMenu(door)
    end)

    menu:Show()
end

function NewAuthGrades(jobs, pickedJob, door)
    local menu = Menu:Create('newauthgrades', 'New Authorization')
    local grades = {}
    table.insert(grades, { ['label'] = "Select", ['value'] = -1, ['level'] = -1 })
    for j,b in pairs(jobs[pickedJob.job].grades) do
        table.insert(grades, { ['label'] = "[" .. b.level .. "] " .. b.label .. " [" .. j .. "]", ['value'] = b.level, ['level'] = b.level })
    end
    table.sort(grades, function(a,b) return a.level < b.level end)

    menu.Add:Select('Select Min Grade', {
        disabled = false,
        current = -1,
        list = grades
    }, function(data)
        pickedJob.grade = data.data.value
    end)

    menu.Add:Button('Confirm', { success = true }, function(data)
        if not pickedJob.grade then Notification:Error('You must pick a grade level')
        else NewAuthDuty(jobs, pickedJob, door) end
    end)

    menu:Show()
end

function NewAuthWorkplaces(jobs, pickedJob, door)
    local menu = Menu:Create('newauthwp', 'New Authorization')
    local workplaces = {}
    table.insert(workplaces, { label = "Accessed by all workplaces", value = 0 })
    if jobs[pickedJob.job].workplaces and Utils:GetTableLength(jobs[pickedJob.job].workplaces) > 0 then
        for i = 1, Utils:GetTableLength(jobs[pickedJob.job].workplaces) do
            table.insert(workplaces, { label = jobs[pickedJob.job].workplaces[i] .. " (ID: " .. i .. ")", value = i })
        end
        table.sort(workplaces, function(a,b) return a.value < b.value end)
    end
    menu.Add:Select('Select Workplace for ' .. jobs[pickedJob.job].label, {
        disabled = false,
        current = 0,
        list = workplaces
    }, function(data)
        pickedJob.workplace = data.data.value
    end)

    menu.Add:Button('Confirm', { success = true }, function(data)
        if not pickedJob.workplace then pickedJob.workplace = 0 end
        NewAuthGrades(jobs, pickedJob, door)
    end)

    menu:Show()
end

function NewAuth(jobs, door)
    local menu = Menu:Create('newauth', 'New Authorization')
    local jobTable = {}
    table.insert(jobTable, { label = "None", value = 0 })
    for k,v in pairs(jobs) do
        if Utils:GetTableLength(doors[door].Auth) > 0 then
            for j,b in pairs(doors[door].Auth) do
                if b.job ~= k then
                    table.insert(jobTable, { label = v.label, value = k })
                end
            end
        else
            table.insert(jobTable, { label = v.label, value = k })
        end
    end

    local pickedJob = {}
    menu.Add:Select('Select Job', {
        disabled = false,
        current = 0,
        list = jobTable
    }, function(data)
        pickedJob.job = data.data.value
    end)
    
    menu.Add:Button('Confirm', { success = true }, function(data)
        if pickedJob.job then NewAuthWorkplaces(jobs, pickedJob, door) end
    end)

    menu:Show()
end

function EditAuth(door)
    local menu = Menu:Create('authorization', 'Authorization')
    if doors[door].Auth and Utils:GetTableLength(doors[door].Auth) > 0 then
        Callbacks:ServerCallback('Doors:GetJobs', {}, function(jobs)
            for k,v in pairs(doors[door].Auth) do
                menu.Add:SubMenu('Job: ' .. jobs[v.job].label, EditThisAuth(jobs, k, door))
            end
            menu.Add:Button('New Auth', { success = true }, function(data)
                NewAuth(jobs, door)
            end)
            menu.Add:SubMenuBack('Back')
        end)
        return menu
    else
        menu.Add:SubMenuBack('Back')
        return menu
    end            
end

function SettingsMenu(door, setting)
    local setMenu
    if setting == 'draw' then
        setMenu = Menu:Create('set', 'Current Draw Distance: ' .. doors[door].DrawDistance)
        setMenu.Add:Slider('Draw Distance', {
            disabled = false,
            min = 1,
            max = 20,
            step = 0.1,
            current = doors[door].DrawDistance
        }, function(data)
            Callbacks:ServerCallback('Doors:AdjustSettings', {
                door = doors[door].id,
                setting = 'DrawDistance',
                value = tonumber(data.data.value)
            }, function(done)
                if done then
                    Notification:Success('Door updated')
                else
                    Notification:Error('Error updating Door')
                end
                SettingsMenu(door):Show()
            end)
        end)
    else
        setMenu = Menu:Create('set', 'Door Settings')
        setMenu.Add:Select('Current Lock', {
            disabled = false,
            current = doors[door].Lock,
            list = {
                { label = 'Locked', value = true },
                { label = 'Unlocked', value = false }
            }
        }, function(data)
            Callbacks:ServerCallback('Doors:AdjustSettings', {
                door = doors[door].id,
                setting = 'Lock',
                value = data.data.value
            }, function(done)
                if done then
                    Notification:Success('Door updated')
                else
                    Notification:Error('Error updating Door')
                end
            end)
        end)
        setMenu.Add:Select('Default Lock', {
            disabled = false,
            current = doors[door].DefaultLock,
            list = {
                { label = 'Locked', value = true },
                { label = 'Unlocked', value = false }
            }
        }, function(data)
            Callbacks:ServerCallback('Doors:AdjustSettings', {
                door = doors[door].id,
                setting = 'DefaultLock',
                value = data.data.value
            }, function(done)
                if done then
                    Notification:Success('Door updated')
                else
                    Notification:Error('Error updating Door')
                end
            end)
        end)
        setMenu.Add:Button('Draw Distance: ' .. doors[door].DrawDistance, {}, function(data)
            SettingsMenu(door, 'draw'):Show()
        end)
        setMenu.Add:CheckBox((not doors[door].Lockpickable and 'Not ' or '') .. 'Lockpickable', { 
            checked = doors[door].Lockpickable
        }, function(data)
            Callbacks:ServerCallback('Doors:AdjustSettings', {
                door = doors[door].id,
                setting = 'Lockpickable',
                value = not doors[door].Lockpickable
            }, function(done)
                if done then
                    setMenu.Update:Item(data.id, (not doors[door].Lockpickable and 'Not ' or '') .. 'Lockpickable', {})
                end
            end)
        end)
        setMenu.Add:CheckBox((not doors[door].Lockdown and 'Not ' or '') .. 'On Lockdown', { 
            checked = doors[door].Lockdown
        }, function(data)
            if CanLockdownDoor(door) then
                Callbacks:ServerCallback('Doors:AdjustSettings', {
                    door = doors[door].id,
                    setting = 'Lockdown',
                    value = not doors[door].Lockdown
                }, function(done)
                    if done then
                        setMenu.Update:Item(data.id, (not doors[door].Lockdown and 'Not ' or '') .. 'On Lockdown', {})
                    end
                end)
            else
                Notification:Error('Can\'t lockdown emergency services doors')
            end
        end)
        setMenu.Add:SubMenu('Authorization', EditAuth(door))
        setMenu.Add:SubMenuBack('Back')
    end

    if setMenu then return setMenu end
end

function ManageDoorMenu(door)
    local nearDoor = Menu:Create('doorInfo', 'Door ID: ' .. doors[door].id)
    nearDoor.Add:Text('Door Info', { 'heading', 'pad', 'center' })
    nearDoor.Add:Text('<strong><span style="color:#00ddff">Static Door</span></strong>: ' .. (doors[door].Static and "<strong><span style='color:#00ff22'>Yes</span></strong>" or "<strong><span style='color:#ff0000'>No</span></strong>") .. '<br><strong><span style="color:#00ddff">Multi Door</span></strong>: ' .. (doors[door].Multi > 0 and "<strong><span style='color:#00ff22'>Yes</span></strong> <i>(ID: " .. doors[door].Multi .. ")</i>" or "<strong><span style='color:#ff0000'>No</span></strong>") .. '<br><strong><span style="color:#00ddff">Model Hash</span></strong>:' .. doors[door].Model, { 'pad', 'left', 'textLarge' })
    nearDoor.Add:Text('Position Info', { 'heading', 'pad', 'center' })
    nearDoor.Add:Text('<strong><span style="color:#00ddff">X</span></strong>: ' .. doors[door].Coords.x .. '<br><strong><span style="color:#00ddff">Y</span></strong>: ' .. doors[door].Coords.y .. '<br><strong><span style="color:#00ddff">Z</span></strong>: ' .. doors[door].Coords.z .. '<br><strong><span style="color:#00ddff">Heading</span></strong>: ' .. doors[door].Coords.h .. '<br><strong><span style="color:#00ddff">Yaw</span></strong>: ' .. doors[door].Yaw .. '<br><strong><span style="color:#00ddff">Pitch</span></strong>: ' .. doors[door].Pitch, { 'pad', 'left', 'textLarge' })
    nearDoor.Add:SubMenu('Settings', SettingsMenu(door))
    nearDoor.Add:SubMenuBack('Delete Door', {}, function()
        Callbacks:ServerCallback('Doors:Remove', {
            door = doors[door].id
        }, function(done)
            if done then
                Notification:Success('Door deleted')
            else
                Notification:Error('Error deleting Door')
            end
        end)
    end)
    nearDoor.Add:SubMenuBack('Back', {}, function()
        TriggerEvent('Doors:AddDoor')
    end)

    nearDoor:Show()
end

RegisterNetEvent('Doors:AddDoor')
AddEventHandler('Doors:AddDoor', function()  
    addingDoor, selectedObject = false, false
    local playerPed = PlayerPedId()
    local menu = Menu:Create('doors', 'Door', function() end, function()
        Notification.Persistent:Remove('addingDoor')
    end)
    menu.Add:Button('Add New Door', {}, function()
        menu:Toggle(false)
        Notification.Persistent:Info('addingDoor', 'Point to a door and press SHIFT+X to add it to the door system and SHIFT+C to cancel the operation')
        addingDoor = true
        Citizen.CreateThread(function()
            while addingDoor do
                Citizen.Wait(1)
                if IsControlJustPressed(0, 73) and IsControlPressed(0, 21) then -- Shift+x
                    local CoordFrom = GetEntityCoords(playerPed, true)
                    local CoordTo = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 20.0, 0.0)
                    local RayHandle = StartShapeTestRay(CoordFrom.x, CoordFrom.y, CoordFrom.z, CoordTo.x, CoordTo.y, CoordTo.z, 16, playerPed, 0)
                    local _, _, _, _, object = GetShapeTestResult(RayHandle)
                    if object ~= 0 then
                        selectedObject = object
                        local objCoords = GetEntityCoords(object)
                        Citizen.CreateThread(function()
                            while (addingDoor and selectedObject == object) do
                                Citizen.Wait(1)
                                DrawMarker(1, objCoords.x, objCoords.y, objCoords.z - 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.8, 255, 0, 0, 200, false, true, 2, false, nil, nil, false)
                            end
                        end)
                        local model = GetEntityModel(object)
                        local x, y, z = table.unpack(GetEntityCoords(object))
                        local heading = GetEntityHeading(object)
                        local pitch, _, yaw = table.unpack(GetEntityRotation(object, 2))
                        local curSettings = {
                            ['model'] = model,
                            ['type'] = 'door',
                            ['coords'] = { ['x'] = x, ['y'] = y, ['z'] = z, ['h'] = heading },
                            ['pitch'] = pitch, ['yaw'] = yaw,
                            ['lock'] = true,
                            ['privacy'] = true,
                            ['draw'] = 2,
                            ['multi'] = 0,
                            ['sameSettings'] = false,
                            ['static'] = false,
                            ['lockpickable'] = false,
                            ['auth'] = {}
                        }
                        local multi = Menu:Create('multiSettings', 'Part of a Double Door?')
                        multi.Add:Button('Yes', {}, function()
                            LoadMulti(curSettings)
                        end)
                        multi.Add:Button('No', {}, function()
                            LoadStatic(curSettings, menu)
                        end)

                        local defaultSettings = Menu:Create('doorSettings', 'Default Settings')
                        defaultSettings.Add:Select('Default Lock (on server start)', {
                            disabled = false,
                            current = true,
                            list = {
                                { label = 'Locked', value = true },
                                { label = 'Unlocked', value = false },
                            }
                        }, function(data)
                            curSettings.lock = data.data.value
                        end)
                        defaultSettings.Add:Select('Privacy Options (Allow every player to see lock state)', {
                            disabled = false,
                            current = true,
                            list = {
                                { label = 'Public', value = true },
                                { label = 'Private', value = false },
                            }
                        }, function(data)
                            curSettings.privacy = data.data.value
                        end)
                        defaultSettings.Add:CheckBox('Not Lockpickable', { 
                            checked = false
                        }, function(data)
                            curSettings.lockpickable = not curSettings.lockpickable
                            defaultSettings.Update:Item(data.id, (not curSettings.lockpickable and 'Not ' or '') .. 'Lockpickable', {})
                        end)
                        defaultSettings.Add:Slider('Draw Distance: 2.0', {
                            disabled = false,
                            min = 1,
                            max = 20,
                            step = 0.1,
                            current = 2
                        }, function(data)
                            curSettings.draw = data.data.value
                            defaultSettings.Update:Item(data.id, 'Draw Distance: ' .. (curSettings.draw + 0.0), {})
                        end)
                        defaultSettings.Add:SubMenu('Confirm', multi)

                        local doorTypes = Menu:Create('doorTypes', 'Door Type')
                        doorTypes.Add:Select('Type', {
                            disabled = false,
                            current = 'door',
                            list = {
                                { label = 'Door', value = 'door' },
                                { label = 'Gate', value = 'gate' },
                                { label = 'Garage Door', value = 'garage' },
                                { label = 'Motel Room Door', value = 'motel' },
                            }
                        }, function(data)
                            curSettings.type = data.data.value
                        end)
                        doorTypes.Add:SubMenu('Confirm', defaultSettings)

                        local newDoorMenu = Menu:Create('door', 'Found Door', function() end, function()
                            Notification.Persistent:Remove('addingDoor')
                            addingDoor, selectedObject = false, false
                        end)
                        newDoorMenu.Add:Text('Door Info', { 'heading', 'center' })
                        newDoorMenu.Add:Text('<strong><span style="color:#00ddff">Model Hash</span></strong>: ' .. model .. '<br><strong><span style="color:#00ddff">X</span></strong>: ' .. x .. '<br><strong><span style="color:#00ddff">Y</span></strong>: ' .. y .. '<br><strong><span style="color:#00ddff">Z</span></strong>: ' .. z .. '<br><strong><span style="color:#00ddff">Heading</span></strong>: ' .. heading .. '<br><strong><span style="color:#00ddff">Yaw</span></strong>: ' .. yaw, { 'pad', 'left', 'textLarge' })
                        newDoorMenu.Add:SubMenu('Confirm', doorTypes)
                        newDoorMenu.Add:SubMenuBack('Cancel', {}, function()
                            Wait(100)
                            TriggerEvent('Doors:AddDoor')
                        end)
                        newDoorMenu:Show()
                        Notification.Persistent:Remove('addingDoor')
                    else
                        Notification:Error('Door not found')
                    end
                end

                if IsControlJustPressed(0, 79) and IsControlPressed(0, 21) then -- Shift+c
                    Notification.Persistent:Remove('addingDoor')
                    TriggerEvent('Doors:AddDoor')
                end
            end
        end)
    end)

    if showing then
        menu.Add:Button('Manage Near Door', {}, function(data)
            ManageDoorMenu(showing)
        end)
    end

    menu:Show()
end)

