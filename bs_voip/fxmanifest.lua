fx_version 'bodacious'
games {'gta5'} -- 'gta5' for GTAv / 'rdr3' for Red Dead 2, 'gta5','rdr3' for both

description 'Blue Sky TokoVoip'
name 'Blue Sky: [bs_voip]'
author '[Chris Rogers + Dylan "Itokoyamato" Thuillier]'
version 'v1.0.0'
url 'https://www.blueskyrp.com'

server_scripts {
    'config/s_config.lua',
    'server/main.lua',
    'server/utils.lua',
}

client_scripts {
    'client/utils.lua',
    'config/c_config.lua',
    'client/main.lua',
    'client/tokovoip.lua',
    'client/nuiProxy.js',
}

ui_page "ui/html/index.html"

files({
    "ui/html/index.html",
    "ui/html/main.js",
    "ui/html/*.png",
})