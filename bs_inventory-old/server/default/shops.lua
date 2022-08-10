local _ran = false

function DefaultShopData()
    if _ran then return end

    _ran = true
    Default:Add('shops', 1590249435, {
        {
            id = 1,
            shop_name = "24/7",
            shop_itemset = 1,
            shop_coords = {
                x = -1347.5,
                y = 95.37,
                z = 29.50,
                h = 95.37
            },
            marker = true,
            robbery = {

            },
            hasSafe = true,
        },
        {
            id = 2,
            shop_name = "24/7",
            shop_itemset = 1,
            shop_coords = {
                x = 536.73,
                y = -153.42,
                z = 57.14,
                h = 215.30
            },
            marker = true,
            robbery = {

            },
            hasSafe = true,
        },
        
    })
end