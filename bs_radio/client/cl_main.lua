local radioModel = "prop_cs_hand_radio"
local radioProp = nil
local radioOpen = false

AddEventHandler('Radio:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
  Callbacks = exports['bs_base']:FetchComponent('Callbacks')
  Notification = exports['bs_base']:FetchComponent('Notification')
  UI = exports['bs_base']:FetchComponent('UI')
  Voip = exports['bs_base']:FetchComponent('Voip')
  Radio = exports['bs_base']:FetchComponent('Radio')
end

AddEventHandler('Core:Shared:Ready', function()
  exports['bs_base']:RequestDependencies('Radio', {
    'Callbacks',
    'Notification',
    'UI',
    'Voip',
    'Radio'
  }, function(error)  
    if #error > 0 then return; end
    RetrieveComponents()
  end)
end)

Radio = {
  Open = function(self)
    radioOpen = true
    UI:SetFocus(true)
    UI:SendUIMessage("hud:radio:toggle", true)
    Radio:PlayRadioAnim()
  end,

  Close = function(self)
    radioOpen = false
    UI:SetFocus(false)
    UI:SendUIMessage("hud:radio:toggle", false)
    Radio:StopRadioAnim()
  end,

  PlayRadioAnim = function(self)
    local ped = PlayerPedId()
    local testdic = "cellphone@"
    local testanim = "cellphone_text_read_base"
    
    RequestAnimDict(testdic)
    while not HasAnimDictLoaded(testdic) do
      Citizen.Wait(0)
    end
    
    RequestModel(radioModel)
    while not HasModelLoaded(radioModel) do
      Citizen.Wait(1)
    end
    
    radioProp = CreateObject(radioModel, 1.0, 1.0, 1.0, 1, 1, 0)
    
    local bone = GetPedBoneIndex(ped, 28422)
    AttachEntityToEntity(radioProp, ped, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
    
    TaskPlayAnim(ped, "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
  end,

  StopRadioAnim = function(self)
    StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 1.0)
    Radio:DestroyProp()
  end,

  DestroyProp = function(self)
    if radioProp ~= 0 then
      Citizen.InvokeNative(0xAE3CBE5BF394C9C9 , Citizen.PointerValueIntInitialized(radioProp))
      radioProp = 0
    end
  end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['bs_base']:RegisterComponent('Radio', Radio)
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
  _isloggedIn = false
end)

RegisterCommand("radio", function(src, args, raw) -- test command since we don't have a inventory yet
  if not radioOpen then
    Radio:Open()
  end
end)