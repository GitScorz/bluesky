COMPONENTS.Spawn = COMPONENTS.Spawn or {
    _required = { 'InitCamera', 'Init' },
    _name = 'base',
}

COMPONENTS.Spawn.SpawnPoint = {
    x = -1276.91, 
    y = 310.76, 
    z = 65.51, 
    h = 150.05
}

function COMPONENTS.Spawn.InitCamera(self)
    return
end

function COMPONENTS.Spawn.Init(self)
    DoScreenFadeOut(500)
    SetEntityCoords(PlayerPedId(), self.SpawnPoint.x, self.SpawnPoint.y, self.SpawnPoint.z)
    SetEntityHeading(PlayerPedId(), self.SpawnPoint.h)
    ShutdownLoadingScreen()

    DoScreenFadeIn(500)

    while not IsScreenFadingIn() do
        Citizen.Wait(10)
    end
end

AddEventHandler('playerSpawned', function()
    COMPONENTS.Spawn:Init()
end)

AddEventHandler('onClientMapStart', function()
    COMPONENTS.Spawn:InitCamera()
    exports['spawnmanager']:spawnPlayer()
    Citizen.Wait(2500)
	exports['spawnmanager']:setAutoSpawn(false)
end)