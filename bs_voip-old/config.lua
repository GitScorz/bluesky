Config = {
    Modes = {
        { 2.5, "Whisper" }, -- Whisper speech distance in gta distance units
        { 8.0, "Normal" }, -- Normal speech distance in gta distance units
        { 20.0, "Shouting" }, -- Shout speech distance in gta distance units
    },
    Speaker = {
        Range = 1.5,
        Call = true,
        Radio = true,
    },
    Radio = true,
    MicClicks = {
        On = true,
        Off = true,
        Volume = 0.1,
        MaxChannel = 100,
    },
    Controls = {
        Proximity = {
            Key = 20, -- Z
        }, -- Switch proximity mode
        Radio = {
            Pressed = false, -- don't touch
            Key = 137, -- capital
        }, -- Use radio
        Speaker = {
            Key = 20, -- Z
            Secondary = 21, -- LEFT SHIFT
        } -- Toggle speaker mode (phone calls)
    },
    RadioChannels = { -- Add named radio channels (Defaults to [channel number] MHz)
        [1] = "LEO Tac 1",
        [2] = "LEO Tac 2",
        [3] = "EMS Tac 1",
        [4] = "EMS Tac 2",
    },
    PhoneChannels = {},
    Use3DAudio = false, -- (currently doesn't work properly) make sure setr voice_use3dAudio true and setr voice_useSendingRangeOnly true is in your server.cfg (currently doesn't work properly)
}