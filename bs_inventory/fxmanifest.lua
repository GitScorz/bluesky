fx_version 'bodacious'
games {'gta5'} -- 'gta5' for GTAv / 'rdr3' for Red Dead 2, 'gta5','rdr3' for both

description 'Blue Sky Inventory'
name 'Blue Sky: bs_inventory'
author '[Chris Rogers]'
version 'v1.0.0'
url 'https://www.blueskyrp.com'

server_scripts {
    'config.lua',
    'config/*.lua',
    'server/items.lua',
    'server/entityTypes.lua',
    'server/inventory.lua',
    'server/default/*.lua',
}

client_scripts {
    'config.lua',
    'config/*.lua',
    'client/*.lua'
}

ui_page "ui/html/index.html"

files{
    "ui/html/main.js",
    "ui/html/index.html",
    "ui/images/items/*.png"
}