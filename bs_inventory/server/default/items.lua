local _ran = false

function DefaultData()
    if _ran then
        return
    end

    _ran = true
    Default:Add('items', 1593044862, {
        {
            name = 'valuegoods',
            label = 'Valuable Goods',
            image = 'valuegood.png',
            price = 0,
            canRemove = true,
            isUsable = false,
            isUnique = false,
            canStack = true,
            max = 10,
            type = 1,
            closeUi = false,
            metalic = false,
        },
        {
            name = 'rolex',
            label = 'Rolex',
            image = 'rolex.png',
            price = 0,
            canRemove = true,
            isUsable = false,
            isUnique = false,
            canStack = true,
            max = 10,
            type = 1,
            closeUi = false,
            metalic = false,
        },
        {
            name = 'ring',
            label = 'Ring',
            image = 'ring.png',
            price = 0,
            canRemove = true,
            isUsable = false,
            isUnique = false,
            canStack = true,
            max = 10,
            type = 1,
            closeUi = false,
            metalic = false,
        }, {
            name = 'vaultcard',
            label = 'Vault Access Card',
            image = 'vaultcard.png',
            price = 0,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 1,
            closeUi = true,
            metalic = false,
        },
        {
            name = 'drill',
            label = 'Drill',
            image = 'drill.png',
            price = 0,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 1,
            closeUi = true,
            metalic = false,
        },
        {
            name = 'computer',
            label = 'Computer',
            image = 'computer.png',
            price = 0,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 1,
            closeUi = true,
            metalic = false,
        },
        {
            name = 'card',
            label = 'Card',
            image = 'mastercard.png',
            price = 0,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 1,
            closeUi = true,
            metalic = false,
        },
        {
            name = 'lockpick',
            label = 'Lockpick',
            image = 'lockpick.png',
            price = 200,
            canRemove = true,
            isUsable = true,
            isUnique = false,
            canStack = true,
            max = 30,
            type = 1,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'evidence-vehiclefragment',
            label = 'Vehicle Fragment',
            image = 'evidence-vehiclefragment.png',
            price = 0,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 1,
            closeUi = true,
            metalic = false,
        },
        {
            name = 'evidence-bulletfragment',
            label = 'Bullet Fragment',
            image = 'evidence-projectile.png',
            price = 0,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 1,
            closeUi = true,
            metalic = false,
        },
        {
            name = 'evidence-casing',
            label = 'Bullet Casing',
            image = 'evidence-projectile.png',
            price = 0,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 1,
            closeUi = true,
            metalic = false,
        },
        {
            name = 'evidence-dna',
            label = 'DNA Sample',
            image = 'evidence-dna.png',
            price = 0,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 1,
            closeUi = true,
            metalic = false,
        },
        {
            name = 'evidence-loco',
            label = 'DNA Sample',
            image = 'evidence-dna.png',
            price = 0,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 1,
            closeUi = true,
            metalic = false,
        },
        {
            name = 'water',
            label = 'Water',
            image = 'water.png',
            price = 10,
            canRemove = true,
            isUsable = true,
            isUnique = false,
            canStack = true,
            max = 50,
            type = 1,
            closeUi = true,
            needsBoost = {
                Add = {
                    thirst = 5
                },
                Remove = {
                    hunger = 0
                }
            },
            metalic = false,
        },
        {
            name = 'bread',
            label = 'Bread',
            image = 'bread.png',
            price = 10,
            canRemove = true,
            isUsable = true,
            isUnique = false,
            canStack = true,
            max = 50,
            type = 1,
            closeUi = true,
            needsBoost = {
                Add = {
                    hunger = 5
                },
                Remove = {
                    thirst = 2
                }
            },
            metalic = false,
        },
        {
            name = 'WEAPON_SMG',
            label = 'SMG',
            image = 'WEAPON_SMG.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = false,
                defaultAmmo = 50,
                dropsFragments = true,
                animation = {}
            },
            price = 1000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_BALL',
            label = 'Ball',
            image = 'WEAPON_BALL.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = true,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 1000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = false,
        },
        {
            name = 'WEAPON_SNOWBALL',
            label = 'Snowball',
            image = 'WEAPON_SNOWBALL.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = true,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 1000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = false,
        },
        {
            name = 'WEAPON_GRENADE',
            label = 'Grenade',
            image = 'WEAPON_GRENADE.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = true,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 1000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_BZGAS',
            label = 'BZ Gas',
            image = 'WEAPON_BZGAS.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = true,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 1000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_MOLOTOV',
            label = 'Molotov',
            image = 'WEAPON_MOLOTOV.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = true,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 1000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = false,
        },
        {
            name = 'WEAPON_STICKYBOMB',
            label = 'Sticky Bomb',
            image = 'WEAPON_STICKYBOMB.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = true,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 1000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_PROXMINE',
            label = 'Proximity Mine',
            image = 'WEAPON_PROXMINE.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = true,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 1000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_PIPEBOMB',
            label = 'Pipe Bomb',
            image = 'WEAPON_PIPEBOMB.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = true,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 1000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_SMOKEGRENADE',
            label = 'Smoke Grenade',
            image = 'WEAPON_SMOKEGRENADE.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = true,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 1000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_FLARE',
            label = 'Flare',
            image = 'WEAPON_FLARE.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = true,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 1000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_FIREEXTINGUISHER',
            label = 'Fire Extinguisher',
            image = 'WEAPON_FIREEXTINGUISHER.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 1000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_PETROLCAN',
            label = 'Petrol Can',
            image = 'WEAPON_PETROLCAN.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 1000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = false,
        },
        {
            name = 'WEAPON_CROWBAR',
            label = 'Crowbar',
            image = 'WEAPON_CROWBAR.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 1000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_BAT',
            label = 'Baseball Bat',
            image = 'WEAPON_BAT.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 1000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = false,
        },
        {
            name = 'WEAPON_DAGGER',
            label = 'Dagger',
            image = 'WEAPON_DAGGER.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 400,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_MACHETE',
            label = 'Machete',
            image = 'WEAPON_MACHETE.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 700,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_KNIFE',
            label = 'Knife',
            image = 'WEAPON_KNIFE.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 400,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_SWITCHBLADE',
            label = 'Switchblade',
            image = 'WEAPON_SWITCHBLADE.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 400,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_BOTTLE',
            label = 'Broken Bottle',
            image = 'WEAPON_BOTTLE.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 400,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_BOTTLE',
            label = 'Broken Bottle',
            image = 'WEAPON_BOTTLE.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 400,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_WRENCH',
            label = 'Pipe Wrench',
            image = 'WEAPON_WRENCH.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 400,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_BATTLEAXE',
            label = 'Battle Axe',
            image = 'WEAPON_BATTLEAXE.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 400,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_HATCHET',
            label = 'Hatchet',
            image = 'WEAPON_HATCHET.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 400,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_STONE_HATCHET',
            label = 'Stone Hatchet',
            image = 'WEAPON_STONE_HATCHET.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 300,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = false,
        },
        {
            name = 'WEAPON_HAMMER',
            label = 'Hammer',
            image = 'WEAPON_HAMMER.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 80,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_GOLFCLUB',
            label = 'Golf Club',
            image = 'WEAPON_GOLFCLUB.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 350,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_KNUCKLE',
            label = 'Knuckle Dusters',
            image = 'WEAPON_KNUCKLE.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 400,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_POOLCUE',
            label = 'Pool Cue',
            image = 'WEAPON_POOLCUE.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 200,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = false,
        },
        {
            name = 'WEAPON_FLASHLIGHT',
            label = 'Flashlight',
            image = 'WEAPON_FLASHLIGHT.png',
            weaponConfig = {
                doAnimation = true,
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.3
                        },
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'move_m@intimidation@cop@unarmed',
                            ['anim'] = 'idle',
                            ['time'] = 1.0,
                        },
                        ['two'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.5,
                        },
                    }
                },
            },
            price = 1000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_RAYPISTOL',
            label = 'Laser Gun',
            image = 'WEAPON_RAYPISTOL.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = false,
                defaultAmmo = 1000,
                dropsFragments = false,
                animation = {},
            },
            price = 1000000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_RAYCARBINE',
            label = 'Super Laser Gun',
            image = 'WEAPON_RAYPISTOL.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = false,
                defaultAmmo = 1000,
                dropsFragments = false,
                animation = {},
            },
            price = 1000000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_NIGHTSTICK',
            label = 'Nightstick',
            image = 'WEAPON_NIGHTSTICK.png',
            weaponConfig = {
                doAnimation = false,
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = false,
                animation = {}
            },
            price = 1000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_PISTOL',
            label = 'Pistol',
            image = 'WEAPON_PISTOL.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.2
                        },
                        ['two'] = {
                            ['dict'] = 'rcmjosh4',
                            ['anim'] = 'josh_leadout_cop2',
                            ['time'] = 1.2
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'move_m@intimidation@cop@unarmed',
                            ['anim'] = 'idle',
                            ['time'] = 1.0,
                        },
                        ['two'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.5,
                        },
                    }
                },
            },
            price = 2500,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_COMBATPISTOL',
            label = 'Combat Pistol',
            image = 'WEAPON_COMBATPISTOL.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.2
                        },
                        ['two'] = {
                            ['dict'] = 'rcmjosh4',
                            ['anim'] = 'josh_leadout_cop2',
                            ['time'] = 1.0
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'move_m@intimidation@cop@unarmed',
                            ['anim'] = 'idle',
                            ['time'] = 1.0,
                        },
                        ['two'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.5,
                        },
                    }
                },
            },
            price = 3200,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_APPISTOL',
            label = 'AP Pistol',
            image = 'WEAPON_APPISTOL.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.2
                        },
                        ['two'] = {
                            ['dict'] = 'rcmjosh4',
                            ['anim'] = 'josh_leadout_cop2',
                            ['time'] = 1.0
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'move_m@intimidation@cop@unarmed',
                            ['anim'] = 'idle',
                            ['time'] = 1.0,
                        },
                        ['two'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.5,
                        },
                    }
                },
            },
            price = 6000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_VINTAGEPISTOL',
            label = 'Vintage Pistol',
            image = 'WEAPON_VINTAGEPISTOL.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.2
                        },
                        ['two'] = {
                            ['dict'] = 'rcmjosh4',
                            ['anim'] = 'josh_leadout_cop2',
                            ['time'] = 1.0
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'move_m@intimidation@cop@unarmed',
                            ['anim'] = 'idle',
                            ['time'] = 1.0,
                        },
                        ['two'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.5,
                        },
                    }
                },
            },
            price = 5500,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_HEAVYPISTOL',
            label = 'Heavy Pistol',
            image = 'WEAPON_HEAVYPISTOL.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.2
                        },
                        ['two'] = {
                            ['dict'] = 'rcmjosh4',
                            ['anim'] = 'josh_leadout_cop2',
                            ['time'] = 1.0
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'move_m@intimidation@cop@unarmed',
                            ['anim'] = 'idle',
                            ['time'] = 1.0,
                        },
                        ['two'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.5,
                        },
                    }
                },
            },
            price = 6000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_SNSPISTOL',
            label = 'SNS Pistol',
            image = 'WEAPON_SNSPISTOL.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.2
                        },
                        ['two'] = {
                            ['dict'] = 'rcmjosh4',
                            ['anim'] = 'josh_leadout_cop2',
                            ['time'] = 1.0
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'move_m@intimidation@cop@unarmed',
                            ['anim'] = 'idle',
                            ['time'] = 1.0,
                        },
                        ['two'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.5,
                        },
                    }
                },
            },
            price = 3500,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_SNSPISTOL_MK2',
            label = 'SNS Pistol MK2',
            image = 'WEAPON_SNSPISTOL_MK2.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.2
                        },
                        ['two'] = {
                            ['dict'] = 'rcmjosh4',
                            ['anim'] = 'josh_leadout_cop2',
                            ['time'] = 1.0
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'move_m@intimidation@cop@unarmed',
                            ['anim'] = 'idle',
                            ['time'] = 1.0,
                        },
                        ['two'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.5,
                        },
                    }
                },
            },
            price = 4500,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_FLAREGUN',
            label = 'Flaregun',
            image = 'WEAPON_FLAREGUN.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.2
                        },
                        ['two'] = {
                            ['dict'] = 'rcmjosh4',
                            ['anim'] = 'josh_leadout_cop2',
                            ['time'] = 1.0
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'move_m@intimidation@cop@unarmed',
                            ['anim'] = 'idle',
                            ['time'] = 1.0,
                        },
                        ['two'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.5,
                        },
                    }
                },
            },
            price = 1000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_MARKSMANPISTOL',
            label = 'Marksman Pistol',
            image = 'WEAPON_MARKSMANPISTOL.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.2
                        },
                        ['two'] = {
                            ['dict'] = 'rcmjosh4',
                            ['anim'] = 'josh_leadout_cop2',
                            ['time'] = 1.0
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'move_m@intimidation@cop@unarmed',
                            ['anim'] = 'idle',
                            ['time'] = 1.0,
                        },
                        ['two'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.5,
                        },
                    }
                },
            },
            price = 7500,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_REVOLVER',
            label = 'Revolver',
            image = 'WEAPON_REVOLVER.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.2
                        },
                        ['two'] = {
                            ['dict'] = 'rcmjosh4',
                            ['anim'] = 'josh_leadout_cop2',
                            ['time'] = 1.0
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'move_m@intimidation@cop@unarmed',
                            ['anim'] = 'idle',
                            ['time'] = 1.0,
                        },
                        ['two'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.5,
                        },
                    }
                },
            },
            price = 7000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_REVOLVER_MK2',
            label = 'Revolver MK2',
            image = 'WEAPON_REVOLVER_MK2.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.2
                        },
                        ['two'] = {
                            ['dict'] = 'rcmjosh4',
                            ['anim'] = 'josh_leadout_cop2',
                            ['time'] = 1.0
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'move_m@intimidation@cop@unarmed',
                            ['anim'] = 'idle',
                            ['time'] = 1.0,
                        },
                        ['two'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.5,
                        },
                    }
                },
            },
            price = 7000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_DOUBLEACTION',
            label = 'Double Action Revolver',
            image = 'WEAPON_DOUBLEACTION.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.2
                        },
                        ['two'] = {
                            ['dict'] = 'rcmjosh4',
                            ['anim'] = 'josh_leadout_cop2',
                            ['time'] = 1.0
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'move_m@intimidation@cop@unarmed',
                            ['anim'] = 'idle',
                            ['time'] = 1.0,
                        },
                        ['two'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.5,
                        },
                    }
                },
            },
            price = 8000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_PISTOL50',
            label = '.50 Pistol',
            image = 'WEAPON_PISTOL50.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.2
                        },
                        ['two'] = {
                            ['dict'] = 'rcmjosh4',
                            ['anim'] = 'josh_leadout_cop2',
                            ['time'] = 1.0
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'move_m@intimidation@cop@unarmed',
                            ['anim'] = 'idle',
                            ['time'] = 1.0,
                        },
                        ['two'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.5,
                        },
                    }
                },
            },
            price = 6000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_PISTOL_MK2',
            label = 'PD 9MM',
            image = 'WEAPON_PISTOL_MK2.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.2
                        },
                        ['two'] = {
                            ['dict'] = 'rcmjosh4',
                            ['anim'] = 'josh_leadout_cop2',
                            ['time'] = 1.0
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'move_m@intimidation@cop@unarmed',
                            ['anim'] = 'idle',
                            ['time'] = 1.0,
                        },
                        ['two'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.5,
                        },
                    }
                },
            },
            price = 2500,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_MICROSMG',
            label = 'Uzi',
            image = 'WEAPON_MICROSMG.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_MINISMG',
            label = 'Skorpion',
            image = 'WEAPON_MINISMG.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_SMG',
            label = 'MP5',
            image = 'WEAPON_SMG.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_SMG',
            label = 'MP5',
            image = 'WEAPON_SMG.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_SMG_MK2',
            label = 'SIG MPX',
            image = 'WEAPON_SMG_MK2.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_SMG_MK2',
            label = 'SIG MPX',
            image = 'WEAPON_SMG_MK2.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_ASSAULTSMG',
            label = 'FN P90',
            image = 'WEAPON_ASSAULTSMG.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_COMBATPDW',
            label = 'H&K MP5',
            image = 'WEAPON_COMBATPDW.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_MACHINEPISTOL',
            label = 'TEC-9',
            image = 'WEAPON_MACHINEPISTOL.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_GUSENBERG',
            label = 'Tommy Gun',
            image = 'WEAPON_GUSENBERG.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_MG',
            label = 'PKM',
            image = 'WEAPON_MG.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_COMBATMG',
            label = 'LMG',
            image = 'WEAPON_COMBATMG.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_COMBATMG_MK2',
            label = 'LMG MK2',
            image = 'WEAPON_COMBATMG_MK2.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_MUSKET',
            label = 'Musket',
            image = 'WEAPON_MUSKET.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_SAWNOFFSHOTGUN',
            label = 'Sawnoff Shotgun',
            image = 'WEAPON_SAWNOFFSHOTGUN.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_PUMPSHOTGUN',
            label = 'Pump Shotgun',
            image = 'WEAPON_PUMPSHOTGUN.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_PUMPSHOTGUN_MK2',
            label = 'PD Shotgun',
            image = 'WEAPON_PUMPSHOTGUN_MK2.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['noPDAnim'] = true,
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_BULLPUPSHOTGUN',
            label = 'Kel-Tel KSG',
            image = 'WEAPON_BULLPUPSHOTGUN.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_ASSAULTSHOTGUN',
            label = 'UTS-15',
            image = 'WEAPON_ASSAULTSHOTGUN.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_DBSHOTGUN',
            label = 'Double Barrel Shotgun',
            image = 'WEAPON_DBSHOTGUN.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_HEAVYSHOTGUN',
            label = 'Double Barrel Shotgun',
            image = 'WEAPON_HEAVYSHOTGUN.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_AUTOSHOTGUN',
            label = 'Double Barrel Shotgun',
            image = 'WEAPON_HEAVYSHOTGUN.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_ASSAULTRIFLE',
            label = 'AK-47',
            image = 'WEAPON_ASSAULTRIFLE.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_ASSAULTRIFLE_MK2',
            label = 'AK-12',
            image = 'WEAPON_ASSAULTRIFLE_MK2.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_CARBINERIFLE',
            label = 'PD .556',
            image = 'WEAPON_CARBINERIFLE.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['noPDAnim'] = true,
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_CARBINERIFLE_MK2',
            label = 'PD .762',
            image = 'WEAPON_CARBINERIFLE_MK2.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['noPDAnim'] = true,
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_COMPACTRIFLE',
            label = 'Draco',
            image = 'WEAPON_COMPACTRIFLE.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_BULLPUPRIFLE',
            label = 'Bullpup Rifle',
            image = 'WEAPON_BULLPUPRIFLE.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_BULLPUPRIFLE_MK2',
            label = 'Bullpup Rifle MK2',
            image = 'WEAPON_BULLPUPRIFLE.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_ADVANCEDRIFLE',
            label = 'Kel-Tec RFB',
            image = 'WEAPON_ADVANCEDRIFLE.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_SPECIALCARBINE',
            label = 'HK G36C',
            image = 'WEAPON_ADVANCEDRIFLE.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_SPECIALCARBINE',
            label = 'HK G36C',
            image = 'WEAPON_SPECIALCARBINE.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_SPECIALCARBINE_MK2',
            label = 'HK G36C MK2',
            image = 'WEAPON_SPECIALCARBINE_MK2.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'intro',
                            ['time'] = 1.8,
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@1h',
                            ['anim'] = 'outro',
                            ['time'] = 1.6,
                        }
                    }
                },
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_SNIPERRIFLE',
            label = 'L96A1',
            image = 'WEAPON_SNIPERRIFLE.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = false,
                animation = {},
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_SNIPERRIFLE',
            label = 'L96A1',
            image = 'WEAPON_SNIPERRIFLE.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = false,
                animation = {},
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_MARKSMANRIFLE',
            label = 'M39 EMR',
            image = 'WEAPON_MARKSMANRIFLE.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = false,
                animation = {},
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_MARKSMANRIFLE_MK2',
            label = 'M39 EMR (MK2)',
            image = 'WEAPON_MARKSMANRIFLE_MK2.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = false,
                animation = {},
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_MARKSMANRIFLE_MK2',
            label = 'M39 EMR (MK2)',
            image = 'WEAPON_MARKSMANRIFLE_MK2.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = false,
                animation = {},
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_HEAVYSNIPER',
            label = 'Barrett M82',
            image = 'WEAPON_HEAVYSNIPER.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = false,
                animation = {},
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_HEAVYSNIPER_MK2',
            label = 'BFG-50A',
            image = 'WEAPON_HEAVYSNIPER_MK2.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = false,
                animation = {},
            },
            price = 10000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_COMPACTLAUNCHER',
            label = 'Compact Launcher',
            image = 'WEAPON_COMPACTLAUNCHER.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = false,
                animation = {},
            },
            price = 100000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_GRENADELAUNCHER',
            label = 'Grenade Launcher',
            image = 'WEAPON_GRENADELAUNCHER.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = false,
                animation = {},
            },
            price = 100000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_GRENADELAUNCHER_SMOKE',
            label = 'S Grenade Launcher',
            image = 'WEAPON_GRENADELAUNCHER.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = false,
                animation = {},
            },
            price = 100000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_FIREWORK',
            label = 'Firework Launcher',
            image = 'WEAPON_FIREWORK.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = false,
                animation = {},
            },
            price = 100000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_HOMINGLAUNCHER',
            label = 'Homing Launcher',
            image = 'WEAPON_HOMINGLAUNCHER.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = false,
                animation = {},
            },
            price = 1000000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_RPG',
            label = 'RPG',
            image = 'WEAPON_RPG.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = false,
                animation = {},
            },
            price = 1000000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_MINIGUN',
            label = 'Minigun',
            image = 'WEAPON_MINIGUN.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = false,
                animation = {},
            },
            price = 1000000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_RAILGUN',
            label = 'Railgun',
            image = 'WEAPON_RAILGUN.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = false,
                animation = {},
            },
            price = 1000000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_RAYMINIGUN',
            label = 'Ray Minigun',
            image = 'WEAPON_RAYMINIGUN.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = false,
                animation = {},
            },
            price = 1000000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        },
        {
            name = 'WEAPON_STUNGUN',
            label = 'Stun Gun',
            image = 'WEAPON_STUNGUN.png',
            weaponConfig = {
                deleteOnNilAmmo = false,
                defaultAmmo = 1,
                dropsFragments = true,
                doAnimation = true,
                animation = {
                    ['intro'] = {
                        ['one'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.2
                        },
                        ['two'] = {
                            ['dict'] = 'rcmjosh4',
                            ['anim'] = 'josh_leadout_cop2',
                            ['time'] = 1.2
                        }
                    },
                    ['outro'] = {
                        ['one'] = {
                            ['dict'] = 'move_m@intimidation@cop@unarmed',
                            ['anim'] = 'idle',
                            ['time'] = 1.0,
                        },
                        ['two'] = {
                            ['dict'] = 'reaction@intimidation@cop@unarmed',
                            ['anim'] = 'intro',
                            ['time'] = 0.5,
                        },
                    }
                },
            },
            price = 1000,
            canRemove = true,
            isUsable = true,
            isUnique = true,
            canStack = false,
            max = 1,
            type = 2,
            closeUi = true,
            metalic = true,
        }
    })
end