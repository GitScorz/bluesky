COMPONENTS.Fetch = {
    _required = { 'Player' },
    _name = 'base',
}

function COMPONENTS.Fetch.Player(self)
    return COMPONENTS.Player.LocalPlayer
end