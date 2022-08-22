local phoneOpen = false
local phoneModel = "prop_player_phone_01"
local phoneProp = 0

Phone = {
  Open = function(self)
    UI:SetFocus(true)
    UI:SendUIMessage('phone:toggle', true)
    Phone:PlayPhoneAnim()
    phoneOpen = true

    -- Phone Apps Init
    Phone.Data:Get()
    Phone.Contacts:Get()
  end,

  Close = function(self)
    UI:SetFocus(false)
    UI:SendUIMessage('phone:toggle', false)
    Phone:StopPhoneAnim()
    phoneOpen = false
  end,

  PlayPhoneAnim = function(self)
    local ped = PlayerPedId()
    local testdic = "cellphone@"
    local testanim = "cellphone_text_read_base"

    RequestAnimDict(testdic)
    while not HasAnimDictLoaded(testdic) do
      Citizen.Wait(0)
    end

    RequestModel(phoneModel)
    while not HasModelLoaded(phoneModel) do
      Citizen.Wait(1)
    end

    Phone:DestroyProp()

    phoneProp = CreateObject(phoneModel, 1.0, 1.0, 1.0, 1, 1, 0)

    local bone = GetPedBoneIndex(ped, 28422)
    AttachEntityToEntity(phoneProp, ped, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)

    TaskPlayAnim(ped, "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
  end,

  StopPhoneAnim = function(self)
    StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 1.0)
    if not Phone:IsInCall() then
      Phone:DestroyProp()
    end
  end,

  DestroyProp = function(self)
    if phoneProp ~= 0 then
      Citizen.InvokeNative(0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized(phoneProp))
      phoneProp = 0
    end
  end,

  SelfieMode = function(self)
    DestroyMobilePhone()
    Wait(0)
    CreateMobilePhone(0)
    CellCamActivate(true, true)
    CellCamDisableThisFrame(true)
    CreateThread(function()
      local selfieMode = true
      while selfieMode == true do
        if IsControlJustPressed(0, 177) then
          selfieMode = false
          DestroyMobilePhone()
          Wait(0)
          CellCamDisableThisFrame(false)
          CellCamActivate(false, false)
          Phone:Open()
        end
        Wait(0)
      end
    end)
  end,

  IsInCall = function(self)
    -- return IsInActiveCall()
    return false
  end,

  IsPhoneOpen = function(self)
    return phoneOpen
  end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
  exports['bs_base']:RegisterComponent('Phone', Phone)
end)
