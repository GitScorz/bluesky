fx_version 'bodacious'
game 'gta5'

ui_page 'ui/index.html'

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}

shared_scripts {
    'config.lua',
    'shared/*.lua',
}

files {
	'ui/index.html',
	'ui/mic_click_on.ogg',
	'ui/mic_click_off.ogg',
}