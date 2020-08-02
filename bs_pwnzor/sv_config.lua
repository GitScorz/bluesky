Config = {

    Components = {
        AFK = {
            Enabled = true,
            Options = {
                AFKTimer = 360,
            }
        },
        Ping = {
            Enabled = true,
            Options = {
                MaxPing = 300,
            },
        },
        GodMode = {
            Enabled = false,
            Options = {},
        },
        NoClip = {
            Enabled = false,
            Options = {},
        },
        Invis = {
            Enabled = true,
            Options = {},
        },
        Hp = {
            Enabled = true,
            Options = {},
        },
        Armor = {
            Enabled = true,
            Options = {},
        },
        Explosions = {
            Enabled = true,
            Options = {
                Types = { 1, 2, 4, 5, 25, 32, 33, 35, 36, 37, 38 },
                Count = 5,
            }
        },
        Tokenizer = {
            Enabled = true,
            Options = {
                Length = 64,
                Charset = '%a%d'
            },
        }
    },

    AuthorizedOverrides = {
        ['Base'] = { Allowed = true, GodMode = true, NoClip = true, Invis = true, Hp = false, Armor = false },
        ['Hospital'] = { Allowed = true, GodMode = true, NoClip = false, Invis = false, Hp = false, Armor = false }
    },
}