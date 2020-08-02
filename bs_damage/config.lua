Config = Config or {}
Config.Debug = false

Config.NotifStyle = {
    class = {
        background = '#760036',
        color = '#ffffff',
    },
    progress = {
        background = '#ffffff'
    }
}

--[[
    GENERAL SETTINGS | THESE WILL AFFECT YOUR ENTIRE SERVER SO BE SURE TO SET THESE CORRECTLY
    MaxHp : Maximum HP Allowed, set to -1 if you want to disable mythic_hospital from setting this
        NOTE: Anything under 100 and you are dead
    RegenRate : 
]]
Config.MaxHp = 200
Config.RegenRate = 0.0

--[[
    AlertShowInfo : 
]]
Config.AlertShowInfo = 2