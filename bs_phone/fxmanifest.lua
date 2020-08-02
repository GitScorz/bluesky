fx_version 'adamant'

game 'gta5'

ui_page 'ui/html/index.html'

files {
  'ui/html/*.js',
  'ui/html/index.html',
  'ui/html/*.ttf',
  'ui/html/*.jpg',
  'ui/html/*.png',
  'ui/html/*.webp',
}
  
client_scripts {
  'client/*.lua',
  'client/apps/*.lua',
}
shared_scripts {
  'config.lua',
}

server_scripts {
  'server/*.lua',
  'server/apps/*.lua',
}