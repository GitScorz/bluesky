local _ran = false

function DefaultDataDealerships()
    if _ran then return end

    _ran = true
    Default:Add('dealerships', 1590230538, {
        {
            name = 'Premium Deluxe Motorsport',
            workplace = 1,
            type = 'cars',
            coords = {
                standard =  { x = -39.78, y = -1096.1,  z = 26.37, h = 43.58    },
                bossmenu =  { x = -22.96, y = -1102.16, z = 26.72, h = 34.68    },
                dealer =    { x = -43.59, y = -1094.13, z = 26.85, h = 161.59   },
                duty =      { x = -23.57, y = -1090.22, z = 26.37, h = 160.0    },
                display =   { x = -37.34, y = -1101.5,  z = 25.53, h = 212.43   },
                camera =    { x = 40.9,   y = -1105.58, z = 28.17, h = 312.98   }
            },
            showroomSpots = {
                { x = -53.78, y = -1091.98, z = 25.53, h = 193.35   },
                { x = -56.62, y = -1097.3,  z = 25.53, h = 189.15   },
                { x = -52.97, y = -1098.62, z = 25.53, h = 190.6    },
                { x = -49.33, y = -1099.73, z = 25.53, h = 189.09   },
                { x = -46.07, y = -1100.91, z = 25.53, h = 192.37   },
                { x = -42.92, y = -1102.17, z = 25.53, h = 189.53   },
                { x = -30.86, y = -1111.9,  z = 25.53, h = 95.48    },
                { x = -32.08, y = -1115.06, z = 25.53, h = 93.11    },
                { x = -33.23, y = -1118.11, z = 25.53, h = 92.04    }
            },
            showroom = {},
            testdrive = {
                spawner =  { x = -30.36, y = -1089.5,  z = 26.42, h = 335.17 },
                deliever = { x = -45.68, y = -1082.27, z = 26.71, h = 348.58 }
            },
            sellSpots = {
                {x = -17.75, y = -1085.23, z = 25.81, h = 68.08 },
                {x = -25.45, y = -1082.3,  z = 25.79, h = 68.81 },
                {x = -35.14, y = -1078.65, z = 25.83, h = 73.64 }
            },
            bossSettings = {
                Margin = 10,
                Downpayment = 20,
                FinanceWeeks = { 3, 16, 29 },
                FinancingMargin = 15,
                TestDriveTimer = 9,
                DealershipBuyMargin = 70,
                DealerMargin = 20
            }
        },
    })
end