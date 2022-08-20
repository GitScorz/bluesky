fx_version 'bodacious'
games { 'gta5' } -- 'gta5' for GTAv / 'rdr3' for Red Dead 2, 'gta5','rdr3' for both

description 'Blue Sky Vehicle Shop'
name 'Blue Sky: [bs_vehicleshop]'
author 'creaKtive'
version 'v2.0.0'
url 'https://www.blueskyrp.com'

server_scripts {
    'server/default/*.lua',
    'server/*.lua',
}

client_scripts {
    'client/shop.lua',
    'client/menu.lua',
    'client/showroom.lua',
    'client/events.lua'
}

shared_script 'config/config.lua'
